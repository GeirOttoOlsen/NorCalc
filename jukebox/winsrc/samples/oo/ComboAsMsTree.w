&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          sports117        PROGRESS
*/
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
&SCOPED-DEFINE AdvGuiWin 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO. /* placeholder */
DEF VAR oContainer  AS JBoxContainer NO-UNDO.
DEF VAR cFirstRep   AS CHAR NO-UNDO.

/*** Start instance property definitions for JBoxBrowse object oBrwCustomer ***/
DEF VAR oBrwCustomer AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE Customer
    FIELD CustNum AS integer SERIALIZE-NAME 'CustomerNumber'
    FIELD Name AS character SERIALIZE-NAME 'CustomerName'
    FIELD SalesRepAndName AS CHARACTER
    FIELD SalesRep AS character
    FIELD RepName AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_Customer FOR TEMP-TABLE Customer.


FUNCTION getBuffersAndFieldsBrwCustomer RETURNS CHARACTER():
  RETURN
    'Customer'
     + ';CustNum'
     + ';Name'
     + ';SalesRep'
  + ',Salesrep'
     + ';RepName'
     + ';+SalesRepAndName|CHARACTER||jb_calc(SalesRep concat / RepName)|Salesrep'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwCustomer RETURNS CHARACTER():
  RETURN 'EACH Salesrep OF Customer NO-LOCK'.
END FUNCTION.
DEF VAR oFmCustomer AS JBoxFieldMap NO-UNDO.
DEF VAR otbCustomer AS JBoxToolbar NO-UNDO.


DEF VAR oJBoxMsTreeView AS uc.JBoxMsTreeView NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwCustomer

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Customer

/* Definitions for BROWSE BrwCustomer                                   */
&Scoped-define FIELDS-IN-QUERY-BrwCustomer Customer.CustNum Customer.Name ~
Customer.SalesRepAndName Customer.SalesRep Customer.RepName 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwCustomer Customer.CustNum 
&Scoped-define QUERY-STRING-BrwCustomer FOR EACH Customer NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwCustomer OPEN QUERY BrwCustomer FOR EACH Customer NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwCustomer Customer
&Scoped-define FIRST-TABLE-IN-QUERY-BrwCustomer Customer


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbCustomer btnSplitBarY JBoxMsTreeView ~
new_tbCustomer edit_tbCustomer copy_tbCustomer undo_tbCustomer ~
save_tbCustomer delete_tbCustomer filter_tbCustomer excel_tbCustomer ~
BrwCustomer CustNum Name SalesRepAndName 
&Scoped-Define DISPLAYED-OBJECTS CustNum Name SalesRepAndName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applySelectedTreeNode C-Win 
FUNCTION applySelectedTreeNode RETURNS LOGICAL
  ( INPUT icNodeName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ViewTree C-Win 
FUNCTION ViewTree RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnSplitBarY 
     IMAGE-UP FILE "bmp/tabup.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Button 1" 
     SIZE 63.2 BY .43.

DEFINE BUTTON copy_tbCustomer 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Kopier" 
     SIZE 4.6 BY 1.1 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON delete_tbCustomer 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 4.6 BY 1.1 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON edit_tbCustomer 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 4.6 BY 1.1 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON excel_tbCustomer 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 4.6 BY 1.1 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbCustomer 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 4.6 BY 1.1 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbCustomer 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 4.6 BY 1.1 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON save_tbCustomer 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 4.6 BY 1.1 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbCustomer 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Angre" 
     SIZE 4.6 BY 1.1 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE SalesRepAndName AS CHARACTER FORMAT "x(50)" 
     LABEL "Sales Rep" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 45 BY 1 TOOLTIP "Please Enter a Sales Rep.".

DEFINE VARIABLE CustNum AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Cust Num" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1 TOOLTIP "Please enter a customer number.".

DEFINE VARIABLE Name AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35.6 BY 1 TOOLTIP "Please enter a name.".

DEFINE RECTANGLE JBoxMsTreeView
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.8 BY 3.1.

DEFINE RECTANGLE tbCustomer
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 61.4 BY 1.29.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwCustomer FOR 
      Customer SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwCustomer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwCustomer C-Win _STRUCTURED
  QUERY BrwCustomer NO-LOCK DISPLAY
      Customer.CustNum COLUMN-LABEL "Cust Num" FORMAT ">>>>9":U
      Customer.Name COLUMN-LABEL "Name" FORMAT "x(30)":U
      Customer.SalesRepAndName COLUMN-LABEL "Salesrep" FORMAT "X(50)":U
      Customer.SalesRep COLUMN-LABEL "Sales Rep" FORMAT "x(4)":U
      Customer.RepName COLUMN-LABEL "Rep Name" FORMAT "x(30)":U
            WIDTH 4
  ENABLE
      Customer.CustNum HELP "Please enter a customer number."
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 61 BY 4.52 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnSplitBarY AT ROW 7.1 COL 1 WIDGET-ID 6
     new_tbCustomer AT ROW 1.1 COL 1.8 WIDGET-ID 16
     edit_tbCustomer AT ROW 1.1 COL 6.4 WIDGET-ID 18
     copy_tbCustomer AT ROW 1.1 COL 11.2 WIDGET-ID 20
     undo_tbCustomer AT ROW 1.1 COL 15.8 WIDGET-ID 22
     save_tbCustomer AT ROW 1.1 COL 20.6 WIDGET-ID 24
     delete_tbCustomer AT ROW 1.1 COL 25.2 WIDGET-ID 26
     filter_tbCustomer AT ROW 1.1 COL 30 WIDGET-ID 28
     excel_tbCustomer AT ROW 1.1 COL 34.6 WIDGET-ID 30
     BrwCustomer AT ROW 2.43 COL 2 WIDGET-ID 200
     CustNum AT ROW 7.67 COL 13 COLON-ALIGNED
     Name AT ROW 7.67 COL 22.4 COLON-ALIGNED NO-LABEL
     SalesRepAndName AT ROW 8.76 COL 13 COLON-ALIGNED WIDGET-ID 38
     tbCustomer AT ROW 1 COL 1.6 WIDGET-ID 14
     JBoxMsTreeView AT ROW 9.76 COL 15 WIDGET-ID 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 63.2 BY 11.95 WIDGET-ID 100.


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
         HEIGHT             = 11.95
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
/* BROWSE-TAB BrwCustomer excel_tbCustomer DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 11.95
       FRAME DEFAULT-FRAME:WIDTH            = 63.2.

ASSIGN 
       Customer.SalesRep:VISIBLE IN BROWSE BrwCustomer = FALSE
       Customer.RepName:VISIBLE IN BROWSE BrwCustomer = FALSE.

ASSIGN 
       btnSplitBarY:MOVABLE IN FRAME DEFAULT-FRAME          = TRUE.

ASSIGN 
       tbCustomer:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,edit;Edit,copy;Kopier,undo;Angre,save;Lagre,delete;Slett,filter;Filter,excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwCustomer
/* Query rebuild information for BROWSE BrwCustomer
     _TblList          = "sports117.Customer"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"Customer.CustNum" "Cust Num" ">>>>9" "integer" ? ? ? ? ? ? yes "Please enter a customer number." no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"Customer.Name" "Name" "x(30)" "character" ? ? ? ? ? ? no "Please enter a name." no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"Customer.SalesRepAndName" "Salesrep" "X(50)" "CHARACTER" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"Customer.SalesRep" "Sales Rep" "x(4)" "character" ? ? ? ? ? ? no "Please Enter a Sales Rep." no no "9.8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"Customer.RepName" "Rep Name" "x(30)" "character" ? ? ? ? ? ? no "Please enter the Name of the Salesperson." no no "4" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwCustomer */
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


&Scoped-define SELF-NAME btnSplitBarY
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBarY C-Win
ON END-MOVE OF btnSplitBarY IN FRAME DEFAULT-FRAME /* Button 1 */
DO:
  DYNAMIC-FUNCTION("setSplitBarY",THIS-PROCEDURE:CURRENT-WINDOW,btnSplitBarY:HANDLE IN FRAME {&FRAME-NAME},NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SalesRepAndName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SalesRepAndName C-Win
ON CURSOR-DOWN OF SalesRepAndName IN FRAME DEFAULT-FRAME /* Sales Rep */
DO:
  ViewTree().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SalesRepAndName C-Win
ON MOUSE-SELECT-DOWN OF SalesRepAndName IN FRAME DEFAULT-FRAME /* Sales Rep */
DO:
  ViewTree().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwCustomer
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
{incl/conttrigg.i oBrwCustomer:BROWSE-HANDLE}
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
RUN SUPER.
  
  IF oBrwCustomer:isCurrent THEN  DO WITH FRAME {&FRAME-NAME}:
    oFmCustomer:bufferExtraValues = (IF AVAIL Customer THEN Customer.SalesRep ELSE "").
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditRecord C-Win 
PROCEDURE EditRecord :
DO WITH FRAME {&FRAME-NAME}:
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
//    SalesRepAndName:READ-ONLY = YES.
  END.

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
  DISPLAY CustNum Name SalesRepAndName 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbCustomer btnSplitBarY JBoxMsTreeView new_tbCustomer edit_tbCustomer 
         copy_tbCustomer undo_tbCustomer save_tbCustomer delete_tbCustomer 
         filter_tbCustomer excel_tbCustomer BrwCustomer CustNum Name 
         SalesRepAndName 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeComponents C-Win 
PROCEDURE InitializeComponents :
&IF DEFINED(AdvGuiWin) &THEN
DO WITH FRAME {&FRAME-NAME}:
  DEF BUFFER bSalesRep FOR SalesRep.
  DEF VAR cSalesRepAndName AS CHAR NO-UNDO.

  oJBoxMsTreeView = NEW uc.JBoxMsTreeView(THIS-PROCEDURE,JBoxMsTreeView:HANDLE,"tvpics\Fold.bmp,tvpics\FoldOpen.bmp").
  oJBoxMsTreeView:RegisterWithJukeBox(NO).
  SalesRepAndName:DELIMITER = "|".


  FOR EACH SalesRep NO-LOCK
      BREAK BY Salesrep.Region
      :
    IF FIRST-OF(Salesrep.Region) THEN DO:
      oJBoxMsTreeView:AddNode("",SalesRep.region,salesrep.region,"region",0,1).
      FOR EACH bSalesRep NO-LOCK
          WHERE bSalesRep.Region = Salesrep.Region
          :
        cSalesRepAndName = bSalesRep.SalesRep + " / " + bSalesRep.RepName.    
        oJBoxMsTreeView:AddNode(Salesrep.Region,bSalesRep.SalesRep,cSalesRepAndName,"salesrep",0,1).    
        IF cFirstRep = "" THEN cFirstRep = bSalesRep.SalesRep.
        SalesRepAndName:ADD-LAST(cSalesRepAndName).
      END.
    END.
  END.    
  oJBoxMsTreeView:setVisible(no).
END.
&ENDIF
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

  oBrwCustomer = NEW JBoxBrowse(brwCustomer:HANDLE).

  oFmCustomer = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmCustomer:updateFields = 'CustNum,Name,SalesRepAndName'.
//  oFmCustomer:displayFields = 'SalesRepAndName'.
  oFmCustomer:primaryKeyFields = 'CustNum'.
  oFmCustomer:bufferExtraFields = "SalesRep".

  oFmCustomer:BROWSE-OBJECT = oBrwCustomer.
  otbCustomer = NEW JBoxToolbar(tbCustomer:HANDLE).

  oBrwCustomer:TOOLBAR-OBJECT = otbCustomer.
  oFmCustomer:TOOLBAR-OBJECT = otbCustomer.
  RUN InitializeComponents.
    
  oContainer:setSplitBarY(btnSplitBarY:HANDLE).
  oContainer:setSplitBarYlimits(btnSplitBarY:HANDLE,100,100). /* 200 pixels from the top, 300 pixels from the bottom */
  oContainer:setFollowSplitBarY(STRING(CustNum:HANDLE) + "," + STRING(Name:HANDLE) + "," + STRING(SalesRepAndName:HANDLE) + "," + STRING(brwCustomer:HANDLE) + "," + STRING(JBoxMsTreeView:HANDLE)).
  oContainer:setNoResizeX("JBoxMsTreeView").
  oContainer:setNoResizeY("brwCustomer").
END.
oBrwCustomer:OpenQuery().

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:initResize(400,120).
&ELSE
  DYNAMIC-FUNCTION("setASlibBehaviour",
                    "QueryLogFile|ServerQuery.log," +   
                    "TransLogFile|ServerTrans.log").
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveUserControl C-Win 
PROCEDURE LeaveUserControl :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihPlaceHolder AS HANDLE NO-UNDO.

IF ihPlaceHolder = JBoxMsTreeView:HANDLE IN FRAME {&FRAME-NAME} THEN
  oJBoxMsTreeView:setVisible(NO).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NodeDoubleClickRecord C-Win 
PROCEDURE NodeDoubleClickRecord :
/*------------------------------------------------------------------------------
  Purpose:     Invoked on double-click of Ms tree-view
  Parameters:  Node-name
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNodeName AS CHARACTER NO-UNDO.

applySelectedTreeNode(icNodeName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReturnOfTreeNode C-Win 
PROCEDURE ReturnOfTreeNode :
/*------------------------------------------------------------------------------
  Purpose:     Invoked on return of Ms tree-view
  Parameters:  Node-name
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNodeName AS CHARACTER NO-UNDO.

applySelectedTreeNode(icNodeName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applySelectedTreeNode C-Win 
FUNCTION applySelectedTreeNode RETURNS LOGICAL
  ( INPUT icNodeName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  IF LOOKUP(oJBoxMsTreeView:getNodeText(icNodeName),SalesRepAndName:LIST-ITEMS,"|") = 0 THEN RETURN NO.
  
  ASSIGN oFmCustomer:bufferExtraValues = icNodeName
         SalesRepAndName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = oJBoxMsTreeView:getNodeText(icNodeName)
         .
  APPLY "entry" TO SalesRepAndName.
  oJBoxMsTreeView:setVisible(NO).
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ViewTree C-Win 
FUNCTION ViewTree RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  oJBoxMsTreeView:setVisible(yes).
  oJBoxMsTreeView:BringToFront().
  IF SalesRepAndName:SCREEN-VALUE NE "" THEN 
    oJBoxMsTreeView:SelectNode(TRIM(ENTRY(1,SalesRepAndName:SCREEN-VALUE,"/"))).
  ELSE DO:
    oJBoxMsTreeView:ExpandNodes("").
    oJBoxMsTreeView:SelectNode(cFirstRep).
  END.  
      
  oJBoxMsTreeView:dotNetFocus().

END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

