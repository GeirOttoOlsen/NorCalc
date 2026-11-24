&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File:         Use to add parameter capabilities to the dynamic selector:
  
                        PROCEDURE mySelectorObject :
                        /*------------------------------------------------------------------------------
                          Purpose:     Overrides for browsers in selector
                          Parameters:  <none>
                          Notes:       
                        ------------------------------------------------------------------------------*/
                        DEF INPUT PARAM ioSelector   AS JBoxDynSelector NO-UNDO.

                        IF ioSelector:NAME = "Department" THEN
                          ioSelector:LoadPanel("DepartmentSelectPanel.w").
                        END PROCEDURE.

                        PROCEDURE getSelectorAttributes :
                        /*------------------------------------------------------------------------------
                          Purpose:     Retrieve value(s) from the selector panel
                          Parameters:  <none>
                          Notes:       
                        ------------------------------------------------------------------------------*/
                        DEF INPUT  PARAM ihBrwSource AS HANDLE NO-UNDO.
                        DEF INPUT  PARAM ihBrwTarget AS HANDLE NO-UNDO.
                        DEF INPUT  PARAM icDeSelRows AS CHAR   NO-UNDO.
                        DEF OUTPUT PARAM oiReturn    AS INT    NO-UNDO.

                        IF VALID-HANDLE(JBoxServerAPI:Instance:SELECTOR-PANEL-HANDLE) THEN
                          MESSAGE PROGRAM-NAME(1) SKIP
                                          "Liquidation date: " DYNAMIC-FUNCTION("getBrowseObject" IN JBoxServerAPI:Instance:SELECTOR-PANEL-HANDLE)
                                          VIEW-AS ALERT-BOX.
                        END PROCEDURE.


  Description: See winsrc\samples\OO\SelectorUsageOO.w for a working example

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:       Brynjar

  Created: 

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR ix           AS INT    NO-UNDO.
DEF VAR bOk          AS LOG    NO-UNDO.
DEF VAR hParent      AS HANDLE NO-UNDO.
DEF VAR hSourceProc  AS HANDLE NO-UNDO.
DEF VAR oBrwFlatFile AS JBoxBrowse NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frmSelectorPanel

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brwFlatFile fiTableName fiMaxImportRows ~
cmbCodePage 
&Scoped-Define DISPLAYED-OBJECTS fiTableName fiMaxImportRows cmbCodePage 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseObject C-Win 
FUNCTION getBrowseObject RETURNS JBoxBrowse
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFrameHandle C-Win 
FUNCTION getFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cmbCodePage AS CHARACTER 
     LABEL "Code page" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "1252","ISO 8859-1","UTF-8" 
     DROP-DOWN
     SIZE 16 BY 1 TOOLTIP "Code page input file" NO-UNDO.

DEFINE VARIABLE fiMaxImportRows AS INTEGER FORMAT ">>>>>>>9":U INITIAL 9999999 
     LABEL "Max rows to import" 
     VIEW-AS FILL-IN 
     SIZE 12.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiTableName AS CHARACTER FORMAT "X(32)":U 
     LABEL "Table name" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 TOOLTIP "Specify table name for imported data" NO-UNDO.

DEFINE RECTANGLE brwFlatFile
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112 BY 7.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frmSelectorPanel
     fiTableName AT ROW 8.95 COL 12.8 COLON-ALIGNED
     fiMaxImportRows AT ROW 9 COL 68.2 COLON-ALIGNED
     cmbCodePage AT ROW 9 COL 95.8 COLON-ALIGNED WIDGET-ID 4
     brwFlatFile AT ROW 1.24 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 114.6 BY 9.29 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 9.29
         WIDTH              = 114.6
         MAX-HEIGHT         = 23.33
         MAX-WIDTH          = 192.6
         VIRTUAL-HEIGHT     = 23.33
         VIRTUAL-WIDTH      = 192.6
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
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME frmSelectorPanel
   FRAME-NAME                                                           */
ASSIGN 
       fiMaxImportRows:PRIVATE-DATA IN FRAME frmSelectorPanel     = 
                "9,999,999".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cmbCodePage
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cmbCodePage C-Win
ON VALUE-CHANGED OF cmbCodePage IN FRAME frmSelectorPanel /* Code page */
DO:
  oBrwFlatFile:setJBoxAttribute("importCodePage",cmbCodePage:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiMaxImportRows
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiMaxImportRows C-Win
ON LEAVE OF fiMaxImportRows IN FRAME frmSelectorPanel /* Max rows to import */
DO:
  IF fiMaxImportRows:MODIFIED THEN
    oBrwFlatFile:setJBoxAttribute("importMaxRows",fiMaxImportRows:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiTableName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTableName C-Win
ON LEAVE OF fiTableName IN FRAME frmSelectorPanel /* Table name */
DO:
  IF fiTableName:MODIFIED THEN DO:
    IF fiTableName:SCREEN-VALUE = "" THEN
      fiTableName:SCREEN-VALUE = oBrwFlatFile:BUFFER-HANDLE:NAME.
    oBrwFlatFile:setJBoxAttribute("importTableName",fiTableName:SCREEN-VALUE).
  END.    
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
ON CLOSE OF THIS-PROCEDURE 
  APPLY "close" TO hParent.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  hParent = SOURCE-PROCEDURE.

  SUBSCRIBE TO "selectorResized" ANYWHERE.

  DYNAMIC-FUNCTION("setNoMoveY",THIS-PROCEDURE:CURRENT-WINDOW,FRAME frmSelectorPanel:HANDLE,"brwFlatFile"). 
  DYNAMIC-FUNCTION("setNoResizeY",THIS-PROCEDURE:CURRENT-WINDOW,FRAME frmSelectorPanel:HANDLE,"frmSelectorPanel,brwFlatFile").
  DYNAMIC-FUNCTION("setAddMoveY",THIS-PROCEDURE:CURRENT-WINDOW,FRAME frmSelectorPanel:HANDLE,"frmSelectorPanel,fiTableName,fiMaxImportRows").  
  DYNAMIC-FUNCTION("setNoMoveX",THIS-PROCEDURE:CURRENT-WINDOW,FRAME frmSelectorPanel:HANDLE,"fiMaxImportRows,cmbCodePage").  

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createBrowse C-Win 
PROCEDURE createBrowse :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihttFlatFileSample AS HANDLE NO-UNDO.

oBrwFlatFile = NEW JBoxBrowse (brwFlatFile:HANDLE IN FRAME {&FRAME-NAME},NO,"Data sample (max 500 rows)",YES,ihttFlatFileSample).
oBrwFlatFile:BROWSE-HANDLE:FIT-LAST-COLUMN = NO.

fiTableName:SCREEN-VALUE = oBrwFlatFile:BUFFER-HANDLE:NAME.
cmbCodePage:SCREEN-VALUE = "UTF-8".

oBrwFlatFile:setJBoxAttribute("importTableName",fiTableName:SCREEN-VALUE).
oBrwFlatFile:setJBoxAttribute("importMaxRows",fiMaxImportRows:SCREEN-VALUE).
oBrwFlatFile:setJBoxAttribute("importCodePage",cmbCodePage:SCREEN-VALUE).

oBrwFlatFile:createGridFilter("").

oBrwFlatFile:openQuery().

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
  /* Hide all frames. */
  HIDE FRAME frmSelectorPanel.
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
  DISPLAY fiTableName fiMaxImportRows cmbCodePage 
      WITH FRAME frmSelectorPanel.
  ENABLE brwFlatFile fiTableName fiMaxImportRows cmbCodePage 
      WITH FRAME frmSelectorPanel.
  {&OPEN-BROWSERS-IN-QUERY-frmSelectorPanel}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectFields C-Win 
PROCEDURE selectFields :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icSelectedFields AS CHAR NO-UNDO.

DEF VAR ix AS INT NO-UNDO.

DO ix = 1 TO oBrwFlatFile:BROWSE-HANDLE:NUM-COlUMNS:
  oBrwFlatFile:BROWSE-HANDLE:GET-BROWSE-COLUMN(ix):VISIBLE = CAN-DO(icSelectedFields,oBrwFlatFile:BROWSE-HANDLE:GET-BROWSE-COLUMN(ix):NAME).
END.  
DYNAMIC-FUNCTION("reDrawGridFilter",oBrwFlatFile:BROWSE-HANDLE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectorResized C-Win 
PROCEDURE selectorResized :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihWindow AS HANDLE NO-UNDO.

IF VALID-OBJECT(oBrwFlatFile) AND ihWindow = THIS-PROCEDURE:CURRENT-WINDOW THEN DO WITH FRAME {&FRAME-NAME}:
  oBrwFlatFile:BROWSE-HANDLE:WIDTH-PIXELS = ihWindow:WIDTH-PIXELS - 5.
  FRAME frmSelectorPanel:WIDTH-PIXELS = ihWindow:WIDTH-PIXELS - 2.
  oBrwFlatFile:BROWSE-HANDLE:MOVE-TO-TOP().
  DYNAMIC-FUNCTION("reDrawGridFilter",oBrwFlatFile:BROWSE-HANDLE).
  ASSIGN fiMaxImportRows:Y = oBrwFlatFile:BROWSE-HANDLE:Y + oBrwFlatFile:BROWSE-HANDLE:HEIGHT-PIXELS + 7
         fiMaxImportRows:SIDE-LABEL-HANDLE:Y = fiMaxImportRows:Y
         fiTableName:Y = fiMaxImportRows:Y
         fiTableName:SIDE-LABEL-HANDLE:Y = fiMaxImportRows:Y
         cmbCodePage:Y = fiMaxImportRows:Y
         cmbCodePage:SIDE-LABEL-HANDLE:Y = fiMaxImportRows:Y 
         .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseObject C-Win 
FUNCTION getBrowseObject RETURNS JBoxBrowse
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN oBrwFlatFile.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFrameHandle C-Win 
FUNCTION getFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN FRAME {&FRAME-NAME}:HANDLE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

