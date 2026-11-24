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
DEF VAR oContainer  AS JBoxContainer NO-UNDO.

{incl/tt_viewds.i}
hdsViewDs = DATASET dsViewDs:HANDLE.

DEF VAR hDs         AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttGrid NO-UNDO
    FIELD iGridNum           AS INT
    FIELD hGridFrame         AS HANDLE
    FIELD hGridQueryOnDemand AS HANDLE
    FIELD hGridRowsToBatch   AS HANDLE
    FIELD hGridBrowseRect    AS HANDLE
    FIELD hGridToolbarRect   AS HANDLE
    FIELD cDbName            AS CHAR
    FIELD cBufferName        AS CHAR
    FIELD hBrowse            AS HANDLE
    FIELD hParentBuffer      AS HANDLE
    .
    
DEF VAR oBrwGrid    AS JBoxBrowse   EXTENT.
DEF VAR oTbGrid     AS JBoxToolbar  EXTENT.

DEF VAR cResizeList AS CHAR NO-UNDO.

DEF VAR iCurrWidth    AS INT NO-UNDO.
DEF VAR iCurrHeight   AS INT NO-UNDO.

DEF VAR hLblRowsToBatch AS HANDLE NO-UNDO.

DEF VAR oJboxBE    AS JBoxBE     NO-UNDO.

DEF VAR oJboxParser AS JBoxJsonParser NO-UNDO.
DEF VAR hViewTable AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD BuildViewDef C-Win 
FUNCTION BuildViewDef RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD realTable C-Win 
FUNCTION realTable RETURNS CHARACTER
  ( INPUT icTableName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 235 BY 40.05 WIDGET-ID 100.


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
         HEIGHT             = 40.05
         WIDTH              = 235
         MAX-HEIGHT         = 40.05
         MAX-WIDTH          = 235
         VIRTUAL-HEIGHT     = 40.05
         VIRTUAL-WIDTH      = 235
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
       FRAME DEFAULT-FRAME:HEIGHT           = 40.05
       FRAME DEFAULT-FRAME:WIDTH            = 235.

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
    DELETE OBJECT oContainer NO-ERROR.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE activateRecord C-Win 
PROCEDURE activateRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
/*oItemBE:getRecordCountMainQuery = fiRowsToBatch:INPUT-VALUE IN FRAME {&FRAME-NAME} NE 0                       */
/*                                OR JBoxSession:Instance:ViewQuestionYesNo("Do record count (for main query)").*/
oJBoxBE:get(oBrwGrid[1]:gridFilterFieldsInUse,oBrwGrid[1]:gridFilterOperatorsInUse,oBrwGrid[1]:gridFilterValuesInUse).

oBrwGrid[1]:openQuery().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AnalyzeDs C-Win 
PROCEDURE AnalyzeDs :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihRelation AS HANDLE NO-UNDO.

DEF VAR iNumX AS INT NO-UNDO.

DEF BUFFER ttGrid FOR ttGrid.
DEF BUFFER bttViewDsTable FOR ttViewDsTable.

FIND FIRST ttViewDsTable
     WHERE ttViewDsTable.ViewDsDb    = ihRelation:PARENT-BUFFER:TABLE-HANDLE:PRIVATE-DATA
       AND ttViewDsTable.ViewDsTable = ihRelation:PARENT-BUFFER:NAME
     NO-ERROR.         

FOR EACH ttGrid
    WHERE ttGrid.hParentBuffer = ihRelation:PARENT-BUFFER:
  iNumX = iNumX + 1.
END.      


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BuildGrid C-Win 
PROCEDURE BuildGrid :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM iiBuffer  AS INT NO-UNDO.

DEF VAR hFrame     AS HANDLE NO-UNDO.
DEF VAR cRealTable AS CHAR NO-UNDO.
DEF VAR cRealDb    AS CHAR NO-UNDO.

CREATE FRAME hFrame
       TRIGGERS:
         ON "start-resize" PERSISTENT RUN "StartResizeFrm" IN THIS-PROCEDURE (hFrame).
         ON "end-resize"   PERSISTENT RUN "EndResizeFrm" IN THIS-PROCEDURE (hFrame).
       END TRIGGERS.
       
IF hDs:GET-BUFFER-HANDLE (iiBuffer):TABLE-HANDLE:ADM-DATA NE ? AND hDs:GET-BUFFER-HANDLE (iiBuffer):TABLE-HANDLE:ADM-DATA NE "" THEN
  cRealTable = hDs:GET-BUFFER-HANDLE (iiBuffer):TABLE-HANDLE:ADM-DATA.
ELSE
  cRealTable = hDs:GET-BUFFER-HANDLE (iiBuffer):NAME.       
       
IF hDs:GET-BUFFER-HANDLE (iiBuffer):TABLE-HANDLE:PRIVATE-DATA NE ? AND hDs:GET-BUFFER-HANDLE (iiBuffer):TABLE-HANDLE:PRIVATE-DATA NE "" THEN
  cRealDb = hDs:GET-BUFFER-HANDLE (iiBuffer):TABLE-HANDLE:PRIVATE-DATA.
ELSE
  cRealDb = hDs:GET-BUFFER-HANDLE (iiBuffer):NAME.       
       
FIND FIRST ttViewDsTable
     WHERE ttViewDsTable.ViewDsDb = cRealDb
       AND ttViewDsTable.ViewDsTable = cRealTable
     NO-ERROR.        
            
CREATE ttGrid.
ASSIGN ttGrid.iGridNum = iiBuffer
       ttGrid.hGridFrame = hFrame
       ttGrid.hGridFrame:FRAME = FRAME {&FRAME-NAME}:HANDLE
       ttGrid.hGridFrame:FGCOLOR = ?
       ttGrid.hGridFrame:BGCOLOR = ?
       ttGrid.hGridFrame:WIDTH-PIXELS = 700
       ttGrid.hGridFrame:HEIGHT-PIXELS = 175
       ttGrid.hGridFrame:NAME = "Frame" + hDs:GET-BUFFER-HANDLE (iiBuffer):NAME
       ttGrid.hGridFrame:X = 10 + (iiBuffer - 1) * 20
       ttGrid.hGridFrame:Y = (IF iiBuffer = 1 THEN 5 ELSE 5 + (iiBuffer - 1) * 175)
       ttGrid.hGridFrame:MOVABLE = YES
       ttGrid.hGridFrame:SELECTABLE = YES
       ttGrid.hGridFrame:RESIZABLE = YES
       ttGrid.hGridFrame:TITLE = cRealDb + "." + cRealTable
       ttGrid.hGridFrame:VISIBLE = YES
       ttGrid.cBufferName = cRealTable
       ttGrid.cDbName = cRealDb
       .
       
IF iiBuffer > 1 THEN
  CREATE TOGGLE-BOX ttGrid.hGridQueryOnDemand
  ASSIGN FRAME = ttGrid.hGridFrame
         DATA-TYPE = "LOGICAL"
         FORMAT = "Yes/No"
         LABEL = "Query on demand"
         TOOLTIP = "Query on row-change of parent"
         X = 150
         Y = 8
         WIDTH-PIXELS = 100
         HEIGHT-PIXELS = 18
//         SCREEN-VALUE = "yes"
         SENSITIVE = YES
         VISIBLE = YES
         .
            
       
CREATE TEXT hLblRowsToBatch
  ASSIGN FORMAT = "x(15)"
         SCREEN-VALUE = "Rows to batch:"
         FRAME = ttGrid.hGridFrame
         WIDTH-PIXELS = 75
         X = 275
         Y = 10
         . 
       
CREATE FILL-IN ttGrid.hGridRowsToBatch
  ASSIGN FRAME = ttGrid.hGridFrame
         DATA-TYPE = "INTEGER"
         FORMAT = ">>>>9"
         SIDE-LABEL-HANDLE = hLblRowsToBatch
         X = 352
         Y = 8
         WIDTH-PIXELS = 40
         HEIGHT-PIXELS = 18
         SCREEN-VALUE = "10"
         SENSITIVE = YES
         VISIBLE = YES
         .
       
CREATE RECTANGLE ttGrid.hGridBrowseRect
  ASSIGN FRAME = ttGrid.hGridFrame
         NAME = "Brw" + hDs:GET-BUFFER-HANDLE (iiBuffer):NAME
         X = 2
         Y = 36
         WIDTH-PIXELS = ttGrid.hGridFrame:WIDTH-PIXELS - 6
         HEIGHT-PIXELS = ttGrid.hGridFrame:HEIGHT-PIXELS - 60
         VISIBLE = NO
         .

CREATE RECTANGLE ttGrid.hGridToolbarRect
  ASSIGN FRAME = ttGrid.hGridFrame
         NAME = "tb" + hDs:GET-BUFFER-HANDLE (iiBuffer):NAME
         X = 2
         Y = 4
         WIDTH-PIXELS = ttGrid.hGridFrame:WIDTH-PIXELS - 6
         HEIGHT-PIXELS = 27
         VISIBLE = YES
         .
         
oBrwGrid[iiBuffer] = NEW JBoxBrowse(ttGrid.hGridBrowseRect,NO,"",NO,hDs:GET-BUFFER-HANDLE(iiBuffer):TABLE-HANDLE).
oBrwGrid[iiBuffer]:createGridFilter("").

ttGrid.hBrowse = oBrwGrid[iiBuffer]:BROWSE-HANDLE.

oTbGrid[iiBuffer] = NEW JBoxToolbar(ttGrid.hGridToolbarRect).
IF iiBuffer = 1 THEN
  oTbGrid[iiBuffer]:addTool("Activate","Get",YES).

oTbGrid[iiBuffer]:addToolGroup("first,prev,next,last").

//oTbGrid[iiBuffer]:addToolGroup("firstPage;First page;icons/resultset_first.png,prevPage;Prev page;icons/resultset_previous.png").
  
//oTbGrid[iiBuffer]:addTool("FirstPage","First page","icons\resultset_first.png"). 
/*oTbGrid[iiBuffer]:addTool("PrevPage","Prev page","icons/resultset_previous.png").*/
/*oTbGrid[iiBuffer]:addTool("NextPage","Next page","icons/resultset_next.png").    */
/*oTbGrid[iiBuffer]:addTool("LastPage","Last page","icons/resultset_last.png").    */

IF iiBuffer = 1 THEN
  oTbGrid[iiBuffer]:addTool("Flatview").
  
ttGrid.hGridToolbarRect:WIDTH-PIXELS = ttGrid.hGridFrame:WIDTH-PIXELS - 6.

oBrwGrid[iiBuffer]:TOOLBAR-OBJECT = oTbGrid[iiBuffer].

cResizeList = /* cResizeList + (IF cResizeList NE "" THEN "," ELSE "")
            + */ ttGrid.hGridFrame:NAME + "," + ttGrid.hGridBrowseRect:NAME + "," + oBrwGrid[iiBuffer]:BROWSE-HANDLE:NAME + "," + ttGrid.hGridToolbarRect:NAME.


oContainer:setNoResizeX(ttGrid.hGridFrame,cResizeList).
oContainer:setNoResizeY(ttGrid.hGridFrame,cResizeList).

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DynFilterDefined C-Win
PROCEDURE DynFilterDefined:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihQryOrBrwHandle AS HANDLE NO-UNDO.

/* Remember to subscribe to this event: SUBSCRIBE TO "DynFilterDefined" ANYWHERE. */
FIND FIRST ttGrid
     WHERE ttGrid.hBrowse = ihQryOrBrwHandle
     NO-ERROR.
IF AVAIL ttGrid THEN DO:
  IF ttGrid.iGridNum = 1 THEN RUN activateRecord.
  ELSE DO:
    oJboxBE:setBufferQueryFilter(ttGrid.cDbName,ttGrid.cBufferName
                                ,oBrwGrid[ttGrid.iGridNum]:gridFilterFieldsInUse
                                ,oBrwGrid[ttGrid.iGridNum]:gridFilterOperatorsInUse
                                ,oBrwGrid[ttGrid.iGridNum]:gridFilterValuesInUse).
  END.  
END.       

/*

IF ihQryOrBrwHandle = oBrwOrderLine:BROWSE-HANDLE AND oItemBE:getFillBufferOnDemand("orderline") THEN DO:
  oItemBE:setBufferQueryFilter("orderline",
          oBrwOrderLine:gridFilterFieldsInUse,oBrwOrderLine:gridFilterOperatorsInUse,oBrwOrderLine:gridFilterValuesInUse).
  oItemBE:getChild("orderline").
  ASSIGN fiNumPagesOrderLine:SCREEN-VALUE IN FRAME frmOrder = STRING(oItemBE:getNumPages("orderline"))
         fiCurrPageOrderLine:SCREEN-VALUE = STRING(oItemBE:getCurrentPage("orderline")). 
END.
ELSE IF ihQryOrBrwHandle = oBrwPOline:BROWSE-HANDLE AND oItemBE:getFillBufferOnDemand("POline") THEN DO:
  /* can re-use queryWhere here since there are no joined buffers in the db query */
  oItemBE:setBufferQueryWhere("POline",oBrwPOline:queryWhere).
  oItemBE:getChild("POline").
END.
ELSE IF ihQryOrBrwHandle = oBrwItem:BROWSE-HANDLE THEN
  RUN getRecord.
*/

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
  VIEW FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EndResizeFrm C-Win 
PROCEDURE EndResizeFrm :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihFrame AS HANDLE NO-UNDO.

DEF VAR iDeltaWidth  AS INT NO-UNDO.
DEF VAR iDeltaHeight AS INT NO-UNDO.
DEF VAR iBufferNum   AS INT NO-UNDO.

FIND FIRST ttGrid
     WHERE ttGrid.hGridFrame = ihFrame.

ASSIGN iDeltaWidth = ihFrame:WIDTH-PIXELS - iCurrWidth
       iDeltaHeight = ihFrame:HEIGHT-PIXELS - iCurrHeight
       ihFrame:VIRTUAL-WIDTH-PIXELS = ihFrame:WIDTH-PIXELS
       ihFrame:VIRTUAL-HEIGHT-PIXELS = ihFrame:HEIGHT-PIXELS
       oBrwGrid[ttGrid.iGridNum]:BROWSE-HANDLE:WIDTH-PIXELS = oBrwGrid[ttGrid.iGridNum]:BROWSE-HANDLE:WIDTH-PIXELS + iDeltaWidth
       oBrwGrid[ttGrid.iGridNum]:BROWSE-HANDLE:VIRTUAL-WIDTH-PIXELS = oBrwGrid[ttGrid.iGridNum]:BROWSE-HANDLE:WIDTH-PIXELS + iDeltaWidth
       oBrwGrid[ttGrid.iGridNum]:BROWSE-HANDLE:HEIGHT-PIXELS = oBrwGrid[ttGrid.iGridNum]:BROWSE-HANDLE:HEIGHT-PIXELS + iDeltaHeight
       oBrwGrid[ttGrid.iGridNum]:BROWSE-HANDLE:VIRTUAL-HEIGHT-PIXELS = oBrwGrid[ttGrid.iGridNum]:BROWSE-HANDLE:HEIGHT-PIXELS + iDeltaHeight
       ttGrid.hGridToolbarRect:WIDTH-PIXELS = ttGrid.hGridToolbarRect:WIDTH-PIXELS + iDeltaWidth
       ttGrid.hGridToolbarRect:VIRTUAL-WIDTH-PIXELS = ttGrid.hGridToolbarRect:WIDTH-PIXELS + iDeltaWidth
       ttGrid.hGridRowsToBatch:SIDE-LABEL-HANDLE:X = ttGrid.hGridRowsToBatch:SIDE-LABEL-HANDLE:X + iDeltaWidth
       ttGrid.hGridRowsToBatch:X = ttGrid.hGridRowsToBatch:X + iDeltaWidth
       .
  DYNAMIC-FUNCTION("reDrawGridFilter",oBrwGrid[ttGrid.iGridNum]:BROWSE-HANDLE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FlatViewRecord C-Win 
PROCEDURE FlatViewRecord :
  oJboxParser:hdsResult = hDs.
  hViewTable = oJBoxParser:createView(BuildViewDef()).
  oContainer:StartChildWindow("JboxDataBrw.w",ttViewDs.ViewDsName,YES). // -> myDataBrowseObject 

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

  oJboxParser = NEW JBoxJsonParser().

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
&ENDIF

SUBSCRIBE TO "DynFilterDefined" ANYWHERE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE myDatabrowseObject C-Win 
PROCEDURE myDatabrowseObject :
DEF INPUT PARAM ioDatabrowse AS JBoxDynDataBrowse NO-UNDO.

ioDatabrowse:InitializeQuery(hViewTable).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartResizeFrm C-Win 
PROCEDURE StartResizeFrm :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihFrame AS HANDLE NO-UNDO.

ASSIGN iCurrWidth = ihFrame:WIDTH-PIXELS
       iCurrHeight = ihFrame:HEIGHT-PIXELS
       .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewDataset C-Win 
PROCEDURE ViewDataset :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihDs        AS HANDLE NO-UNDO.
DEF INPUT PARAM ihSchemaDs  AS HANDLE NO-UNDO.
DEF INPUT PARAM ihViewDs    AS HANDLE NO-UNDO.
DEF INPUT PARAM icViewDsId  AS CHAR   NO-UNDO.

DEF VAR ix AS INT NO-UNDO.
DEF VAR iy AS INT NO-UNDO.
DEF VAR hq AS HANDLE NO-UNDO.
DEF VAR cRel AS CHAR NO-UNDO.
DEF VAR cJBoxRel AS CHAR NO-UNDO. // Different format when linking.. 
DEF VAR cJboxPrescan      AS CHAR NO-UNDO.
DEF VAR cPrescanTableList AS CHAR NO-UNDO.

DEF BUFFER bttGrid FOR ttGrid.

hDs = ihDs.

hdsViewDs:EMPTY-DATASET().
hdsViewDs:COPY-DATASET (ihViewDs).

EXTENT(oBrwGrid) = hDs:NUM-BUFFERS.
EXTENT(oTbGrid) = hDs:NUM-BUFFERS.

oContainer:freezeContainer().
FRAME {&FRAME-NAME}:WIDTH-PIXELS = MAX(FRAME {&FRAME-NAME}:WIDTH-PIXELS,20 * (hDs:NUM-RELATIONS + 1) + 710). 
FRAME {&FRAME-NAME}:HEIGHT-PIXELS = MAX(FRAME {&FRAME-NAME}:HEIGHT-PIXELS,175 * (hDs:NUM-RELATIONS + 1) + 10). 
DO ix = 1 TO hDs:NUM-RELATIONS + 1:
  RUN BuildGrid(ix).
END.  

oContainer:initResize().

FOR EACH ttGrid:
  RUN StartResizeFrm(ttGrid.hGridFrame).
  RUN EndResizeFrm(ttGrid.hGridFrame).
END.

ihViewDs:GET-BUFFER-HANDLE (1):FIND-FIRST("WHERE ViewDsId = '" + icViewDsId + "'").

oJboxBE = NEW JBoxBE(hDs,
          IF ihViewDs:GET-BUFFER-HANDLE(1)::SourceType MATCHES "*sql*" THEN ihViewDs:GET-BUFFER-HANDLE (1)::SourceName ELSE "").

FIND FIRST ttGrid
     WHERE ttGrid.iGridNum = 1
     .

FIND FIRST ttViewDs.

IF VALID-HANDLE(ttViewDs.hTempTable) THEN
  oJBoxBE:mainQueryTTBuffer = ttViewDs.hTempTable:DEFAULT-BUFFER-HANDLE.
ELSE
  oJBoxBE:rowsToBatch = INT(ttGrid.hGridRowsToBatch:SCREEN-VALUE).

oJBoxBE:setBufferQueryJoin(ttViewDs.BaseDb,ttViewDs.BaseTable,ttViewDs.queryJoin,
                           TRIM(ttViewDs.buffersAndFields + "," + ttViewDs.joinBuffersAndFields,",")).
                           
FOR EACH ttViewDsTable:

  FIND FIRST ttGrid
       WHERE ttGrid.cDbName     = ttViewDsTable.ViewDsDb
         AND ttGrid.cBufferName = ttViewDsTable.ViewDsTable
       NO-ERROR.

  IF NOT AVAIL ttGrid THEN NEXT.
       
  IF ttViewDsTable.hTempTable NE ? THEN 
    oJBoxBE:setChildBufferDataSource(ttViewDsTable.hTempTable).
  ELSE     
    oJBoxBE:setChildBufferDataSource(ttGrid.cBufferName,ttViewDsTable.ViewDsTable,ttGrid.cDbName,
            IF ttViewDsTable.SourceType MATCHES "*sql*" OR ttViewDsTable.SourceType = "TT" THEN ttViewDsTable.SourceName
            ELSE "").

  oJBoxBE:setBufferQueryJoin(ttGrid.cDbName,ttGrid.cBufferName,ttViewDsTable.queryJoin,
                             TRIM(ttViewDsTable.buffersAndFields + "," + ttViewDsTable.joinBuffersAndFields,",")).

  oJBoxBE:setBufferPreScanBaseQuery(ttGrid.cDbName,ttGrid.cBufferName,ttViewDsTable.preScanBaseQuery).
END.  

DO ix = 1 TO hDs:NUM-RELATIONS:
  FIND FIRST ttGrid
       WHERE ttGrid.cBufferName = hDs:GET-RELATION (ix):PARENT-BUFFER:TABLE-HANDLE:ADM-DATA
         AND ttGrid.cDbName     = hDs:GET-RELATION(ix):PARENT-BUFFER:TABLE-HANDLE:PRIVATE-DATA
       NO-ERROR.
  FIND FIRST bttGrid
       WHERE bttGrid.cBufferName = hDs:GET-RELATION (ix):CHILD-BUFFER:TABLE-HANDLE:ADM-DATA
         AND bttGrid.cDbName     = hDs:GET-RELATION(ix):CHILD-BUFFER:TABLE-HANDLE:PRIVATE-DATA
       NO-ERROR.
  IF AVAIL ttGrid AND AVAIL bttGrid THEN DO:
    cRel = hDs:GET-RELATION(ix):RELATION-FIELDS.
    cJboxRel = "".      
    DO iy = 1 TO NUM-ENTRIES(cRel) BY 2:
      cJBoxRel = cJboxRel 
               + (IF cJBoxRel NE "" THEN "," ELSE "") 
               + (IF ENTRY(iy,cRel) NE ENTRY(iy + 1,cRel) THEN ENTRY(iy + 1,cRel) + ";" + ENTRY(iy,cRel) ELSE ENTRY(iy,cRel))
               .
    END.  
    oBrwGrid[bttGrid.iGridNum]:setParentBrowseObject(oBrwGrid[ttGrid.iGridNum],cJBoxRel).
  END.             
END.  

oJBoxBE:createMainQuery().

IF NOT ttViewDs.SourceType MATCHES "*sql*" THEN DO:
  DYNAMIC-FUNCTION("setActiveASconnection",ttViewDs.SourceName).
  cJboxPrescan = ttViewDs.preScanQueries.
  IF cJboxPrescan NE "" THEN DO:
    ASSIGN cPrescanTableList = ENTRY(1,cJboxPrescan,"¤")
           cJboxPrescan = ENTRY(2,cJboxPrescan,"¤"). 
    DO ix = 1 TO NUM-ENTRIES(cPrescanTableList):
      oJboxBE:mainQuery:setPreScanQuery(ENTRY(ix,cPrescanTableList),ENTRY(ix,cJboxPrescan,"|")).
    END.
    oJboxBE:mainQuery:altPrimaryBufferList = ttViewDs.altPrimaryBufferList.
  END.  
  oJboxBE:mainQuery:queryStopAfter = 30.
//  oJBoxBE:mainQuery:setJBoxAttribute("viewqueryfilter","yes").
END.    
ELSE DO:
  oJboxBE:mainQuery:queryStopAfter = 10.
  oJboxBE:mainQuery:preScanBaseQuery = ttViewDs.preScanBaseQuery.
END.  

oJBoxBE:mainQuery:baseQuery = ttViewDs.BaseQuery.

CATCH eErr AS Progress.Lang.Error :
  MESSAGE eErr:GetMessage(1)
  VIEW-AS ALERT-BOX.  
END CATCH.
FINALLY:
  oContainer:unFreezeContainer().
  RUN MoveToTop.
END FINALLY.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION BuildViewDef C-Win 
FUNCTION BuildViewDef RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR ix       AS INT  NO-UNDO.
DEF VAR iy       AS INT  NO-UNDO.
DEF VAR cViewDef AS CHAR NO-UNDO.

cViewDef = hDs:GET-BUFFER-HANDLE (1):NAME.

DO ix = 1 TO hDs:NUM-RELATIONS:
  cViewDef = cViewDef + ","
           + hDs:GET-RELATION(ix):CHILD-BUFFER:NAME
           + "|".
  DO iy = 1 TO NUM-ENTRIES(hDs:GET-RELATION(ix):RELATION-FIELDS) BY 2:
    cViewDef = cViewDef + hDs:GET-RELATION(ix):CHILD-BUFFER:NAME 
             + "." + ENTRY(iy + 1,hDs:GET-RELATION(ix):RELATION-FIELDS)
             + " = " + hDs:GET-RELATION(ix):PARENT-BUFFER:NAME
             + "." + ENTRY(iy,hDs:GET-RELATION(ix):RELATION-FIELDS)
             + " OUTER-JOIN"
             .
  END.           
END.  

cViewDef = cViewDef + ";+jbCountDistinct|INTEGER|>>>>>>>>9;+jbAverage|DECIMAL|->>>>>>>>9.99".    

RETURN cViewDef.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION realTable C-Win 
FUNCTION realTable RETURNS CHARACTER
  ( INPUT icTableName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

RETURN IF LENGTH(icTableName) > 5 AND icTableName MATCHES "buf*_*" AND CAN-DO("1_,2_,3_,4_,5_,6_,7_,8_,9_",SUBSTR(icTableName,4,2)) THEN 
         SUBSTR(icTableName,INDEX(icTableName,"_") + 1)
       ELSE icTableName.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

