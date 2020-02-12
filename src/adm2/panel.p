&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : panel.p
    Purpose     : Super procedure for PDO SmartPanel objects

    Syntax      : adm2/panel.p

    Modified    : August 4, 1999
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell viewattr.i that this is the Super procedure. */
   &SCOP ADMSuper panel.p
   
   {src/adm2/custom/panelexclcustom.i}

/* Used in resizeObject to avoid changing the order of NO-FOCUS buttons. */                        
DEFINE TEMP-TABLE tButton
  FIELD hdl     AS HANDLE
  FIELD btnY    AS INT
  FIELD btnX    AS INT
  INDEX order btnY btnX.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getBoxRectangle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBoxRectangle Procedure 
FUNCTION getBoxRectangle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getButtonCount) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getButtonCount Procedure 
FUNCTION getButtonCount RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEdgePixels Procedure 
FUNCTION getEdgePixels RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMarginPixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMarginPixels Procedure 
FUNCTION getMarginPixels RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPanelFrame Procedure 
FUNCTION getPanelFrame RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPanelLabel Procedure 
FUNCTION getPanelLabel RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPanelState Procedure 
FUNCTION getPanelState RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPanelType Procedure 
FUNCTION getPanelType RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEdgePixels Procedure 
FUNCTION setEdgePixels RETURNS LOGICAL
  (piPixels AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPanelState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPanelState Procedure 
FUNCTION setPanelState RETURNS LOGICAL
  ( pcPanelState AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPanelType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPanelType Procedure 
FUNCTION setPanelType RETURNS LOGICAL
  ( pcPanelType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 9.38
         WIDTH              = 39.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/panlprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-countButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE countButtons Procedure 
PROCEDURE countButtons :
/*------------------------------------------------------------------------------
  Purpose:   Walk the widget tree of the frame and count all the buttons.  
  Parameters:  <none>
  Notes:     This sets the Panel property ButtonCount.   Used only internally.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iButtonCount AS INTEGER NO-UNDO.
  
  /* Loop through all the button children and count them. */
  {get PanelFrame hFrame}.
  ASSIGN hFrame  = hFrame:CURRENT-ITERATION
         hFrame  = hFrame:FIRST-CHILD
         iButtonCount = 0.
  DO WHILE VALID-HANDLE (hFrame):
    /* Get all the statically defined buttons in the frame. (We don't want
       the little UIB-generated button in the upper-left corner). */
    IF hFrame:DYNAMIC eq no AND hFrame:TYPE eq "BUTTON":U THEN DO:
       iButtonCount = iButtonCount + 1.
    END.
    /* Get the next child. */
    hFrame = hFrame:NEXT-SIBLING.
  END.
  {set ButtonCount iButtonCount}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableObject Procedure 
PROCEDURE enableObject :
/*------------------------------------------------------------------------------
  Purpose:  Reset the panel buttons to the correct state anytime the panel
            is re-enabled.
   Params:  <none>
    Notes:  The "correct" state is the state that the buttons were in
            before the SmartPanel was disabled. This may not be the "initial"
            state. If a SmartPanel has been disabled because the page it is
            on was hidden, its previous state must be restored when the page
            is viewed again.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cState AS CHARACTER NO-UNDO.

  RUN SUPER.      /* Get all objects enabled to start. */
  {get PanelState cState}.
  RUN setButtons IN TARGET-PROCEDURE(cState).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:  SmartPanel-specific initialization
   Params:  <none>
    Notes:  A SmartPanel is set to the appropriate state
            depending on its Navigation- or Update-Target. A Navigation
            SmartPanel retrieves the QueryPosition property of its 
            Navigation-Target to determine which buttons to enable.
            These QueryPosition values map to the value of the PanelState
            property which is set in the SmartPanel:
            'FirstRecord'       -> 'first'.
            'LastRecord'        -> 'last'.
            'NotFirstOrLast'    -> 'enable-all'.
            'NoRecordAvailable' -> 'disable-all'.
            Likewise, an Update Panel retrieves the RecordState property
            of its Update-Target to do the same thing. 
            'NoRecordAvailable' -> 'add-only'.
            'NoRecordAvailableExt' -> 'disable-all'.
            'RecordAvailable'      -> 'initial'.
            These changes to the PanelState property are interpreted by 
            the setButtons procedure in the SmartPanels.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTarget     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hTarget     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lHidden     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iTarget     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cQueryPos   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPanelState AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPanelType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode    AS CHARACTER NO-UNDO.
  
  {get UIBMode cUIBMode}.
  IF NOT cUIBMode BEGINS 'DESIGN':U THEN DO:
   {get PanelType cPanelType}.
   IF cPanelType BEGINS 'Nav':U OR cPanelType BEGINS 'Save':U OR
     cPanelType BEGINS 'Update':U THEN
   DO:
     IF cPanelType BEGINS 'Nav':U THEN
       {get NavigationTarget cTarget}.
     ELSE {get TableIOTarget cTarget}.     
     /* There may be more than one Target. Find the one which is not hidden.*/
     hTarget = ?.
     DO iTarget = 1 TO NUM-ENTRIES(cTarget) WHILE hTarget = ?:
       hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTarget)).
       {get ObjectHidden lHidden hTarget} NO-ERROR.
       IF NOT lHidden = no THEN
         hTarget = ?.            /* keep looking for one not hidden. */
     END. /* END DO iTarget */
   END.   /* END DO IF Nav/Save/Update */
   
   IF cPanelType BEGINS 'Nav':U THEN
   DO:
     IF hTarget = ? THEN
       /* we have no active navigation target, so disable all the buttons. */ 
       cPanelState = 'disable-all':U.
     ELSE DO:                            
       /* Determine whether the Nav-Target is on the first record or not. */
       {get QueryPosition cQueryPos hTarget} NO-ERROR.
       CASE cQueryPos:
         WHEN 'FirstRecord':U       THEN cPanelState = 'first':U.
         WHEN 'LastRecord':U        THEN cPanelState = 'last':U.
         WHEN 'NotFirstOrLast':U    THEN cPanelState = 'enable-all':U.
         WHEN 'NoRecordAvailable':U THEN cPanelState = 'disable-all':U.
         OTHERWISE /* if no response. */ cPanelState = 'first':U.   
       END CASE.
     END.     /* END ELSE DO */
     {set PanelState cPanelState}.
   END.       /* END DO IF 'Nav' */
   ELSE IF cPanelType BEGINS "Save":U OR cPanelType BEGINS "Update":U THEN
   DO:     
     /* Update Panels  */
     IF VALID-HANDLE(hTarget) THEN
     DO:
       {get RecordState cQueryPos hTarget}.
       IF cQueryPos = 'NoRecordAvailable':U THEN
         cPanelState = 'add-only':U.
       ELSE IF cQueryPos = 'NoRecordAvailableExt':U THEN
         cPanelState = 'disable-all':U.
       ELSE cPanelState = 'initial':U.
     END.   /* END DO IF VALID-HANDLE */
     ELSE cPanelState = 'disable-all':U.
     {set PanelState cPanelState}.            
   END.   /* END Update Panel code */ 
   ELSE IF cPanelType BEGINS "Commit":U THEN
       /* Commit Panel is always disabled initially. */
       {set PanelState 'disable-all':U}.
  END.    /* END UIBMode NE design */
  
  /* The PanelState is set before invoking the standard behavior, which will
     do an 'enable' based on that setting. */
  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U  THEN 
    RETURN "ADM-ERROR":U.
  ELSE RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkState Procedure 
PROCEDURE linkState :
/*------------------------------------------------------------------------------
  Purpose:     Receives messages when an object linked to this one becomes
               "active" (normally when it's viewed) or "inactive" (Hidden).
               resets panel buttons accordingly.
  Parameters:  pcState AS CHARACTER -- 'active'/'inactive'
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cPanelState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryPos      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPanelType     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTarget        AS CHARACTER NO-UNDO.
 
    {get PanelType cPanelType}.
    
    CASE pcState:
    WHEN 'active':U THEN
    DO:
      IF cPanelType BEGINS 'Nav':U THEN
      DO:
        {get QueryPosition cQueryPos SOURCE-PROCEDURE}.
        CASE cQueryPos:
          WHEN 'FirstRecord':U       THEN cPanelState = 'first':U.
          WHEN 'LastRecord':U        THEN cPanelState = 'last':U.
          WHEN 'OnlyRecord':U        THEN cPanelState = 'disable-all':U.
          WHEN 'NotFirstOrLast':U    THEN cPanelState = 'enable-all':U.
          WHEN 'NoRecordAvailable':U THEN cPanelState = 'disable-all':U.
        END CASE.
        RUN setButtons IN TARGET-PROCEDURE(cPanelState).
      END.   /* END Nav Panel code */
      ELSE IF cPanelType BEGINS 'Save':U OR cPanelType BEGINS 'Update':U THEN
      DO:                             
        {get PanelState cPanelState}.
        IF cPanelState = "":U OR cPanelState = 'disable-all':U THEN
        DO:
          /* If the Panel's state hasn't been initialized yet, or simply
             disabled because its Target wasn't there before, then set it
             to the appropriate value. Otherwise, if the Target is being viewed
             again after being hidden, just reset the state to what it was
             before the Target was hidden. */
          {get RecordState cQueryPos SOURCE-PROCEDURE}.
          CASE cQueryPos:
            WHEN 'NoRecordAvailable':U      THEN cPanelState = 'add-only':U.
            WHEN 'NoRecordAvailableExt':U   THEN cPanelState = 'disable-all':U.
            WHEN 'RecordAvailable':U        THEN cPanelState = 'initial':U.
          END CASE.
        END.  /* END DO IF PanelState "" */
        RUN setButtons IN TARGET-PROCEDURE(cPanelState).
      END.   /* END Save Panel code. */
    END.     /* END 'active' CASE */
    WHEN 'inactive':U THEN         
      /* When a Panel's Target is hidden, it must be disabled. Note that
         the PanelState is not actually set to disable-all because we need
         to restore the panel state when it becomes active again. 
         Also, don't do this for Save/Update panels if the TableIO-Target
         has GroupAssign-Targets, because that means that some other page
         of the GroupAssign is presumably active. */
    DO:
      IF cPanelType BEGINS 'Save':U OR cPanelType BEGINS 'Update':U THEN
      DO:
        {get GroupAssignTarget cTarget SOURCE-PROCEDURE}.
        IF cTarget NE "":U THEN
          RETURN.
      END.  /* END DO IF Save/Update */
      RUN setButtons In TARGET-PROCEDURE ('disable-all':U).
    END.   /* END 'inactive' CASE */
      
    OTHERWISE RETURN "ADM-ERROR":U.
  END CASE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-queryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryPosition Procedure 
PROCEDURE queryPosition :
/*------------------------------------------------------------------------------
  Purpose:     Captures "state" events for the associated Query in the Panel's
               NavigationTarget. Invokes the setPanelState function which stores
               the new state in the object's PanelState property and then 
               invokes the setButtons procedure to change the Panel.
  Parameters:  pcState AS CHARACTER -- Panel State
  Notes:       For an Update panel, first/last/notfirstorlast/only are all 
               forms of recordAvailable. This event will be ignored if the
               source of the event is hidden.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cPanelState    AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cPanelType     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lDataModified  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lHidden        AS LOGICAL   NO-UNDO.
  
  /* Ignore events from a hidden Navigation or TableIO-Target */
  {get ObjectHidden lHidden SOURCE-PROCEDURE} NO-ERROR.
  IF lHidden THEN                    
    RETURN.
    
  {get PanelType cPanelType}.
  IF cPanelType BEGINS 'Nav':U THEN
  DO:
    CASE pcState:
      WHEN 'FirstRecord':U THEN
        cPanelState = 'first':U.
      WHEN 'LastRecord':U THEN
        cPanelState = 'last':U.
      WHEN 'NotFirstOrLast':U THEN
        cPanelState = 'enable-all':U.
      WHEN 'OnlyRecord':U OR 
      WHEN 'NoRecordAvailable':U OR
      WHEN 'NoRecordAvailableExt':U THEN
        cPanelState = 'disable-all':U.
    END CASE.
  END.  /* Nav Panel code */
  ELSE IF cPanelType BEGINS 'Save':U OR cPanelType BEGINS 'Update':U THEN
  DO:
    {get DataModified lDataModified SOURCE-PROCEDURE}.
    IF NOT lDataModified THEN
    CASE pcState:
      WHEN 'FirstRecord':U OR  /* All these amount to RecordAvailable */
      WHEN 'LastRecord':U OR
      WHEN 'NotFirstOrLast':U OR
      WHEN 'OnlyRecord':U THEN
        cPanelState = 'initial':U.
      WHEN 'NoRecordAvailable':U THEN
        cPanelState = 'add-only':U.
      WHEN 'NoRecordAvailableExt':U THEN
        cPanelState = 'disable-all':U.
    END CASE.
  END.    /* END Save/Update panel code. */          
  IF cPanelState NE "":U THEN  /* If we found a case for the state, reset it. */
    {set PanelState cPanelState}.  /* This fn will do setButtons etc. */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Changes the size and shape of the panel.  This routine
           spaces the buttons to fill the available space.  
  Parameters: 
           pd_height AS DECIMAL - the desired height (in rows)
           pd_width  AS DECIMAL - the desired width (in columns)
    Notes: Used internally. Calls to resizeObject are generated by the
           AppBuilder in adm-create-objects for objects which implement it.
           Having a resizeObject procedure is also the signal to the AppBuilder
           to allow the object to be resized at design time.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pd_height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pd_width  AS DECIMAL NO-UNDO.
    
  DEFINE VARIABLE hFrame   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hLabel   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRect    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iButtons AS INTEGER NO-UNDO.
  DEFINE VAR btn-height-p  AS INTEGER NO-UNDO.
  DEFINE VAR btn-width-p   AS INTEGER NO-UNDO.  
  DEFINE VAR btn-X         AS INTEGER NO-UNDO.
  DEFINE VAR btn-Y         AS INTEGER NO-UNDO.
  DEFINE VAR h             AS WIDGET  NO-UNDO.
  DEFINE VAR i_margin      AS INTEGER NO-UNDO. /* Margin from frame to buttons */
  DEFINE VAR i_border-h    AS INTEGER NO-UNDO. /* Horizontal frame border      */
  DEFINE VAR i_border-v    AS INTEGER NO-UNDO. /* Vertical frame border        */
  DEFINE VAR i_box-y       AS INTEGER NO-UNDO. /* Start of BOX-RECTANGLE       */
  DEFINE VAR i_lbl-hgt-p   AS INTEGER NO-UNDO. /* Height of (label) Font       */
  DEFINE VAR i_test        AS INTEGER NO-UNDO.    
  DEFINE VAR i_height-p    AS INTEGER NO-UNDO. /* Desired frame height, pixels */
  DEFINE VAR i_width-p     AS INTEGER NO-UNDO. /* Desired frame width, pixels  */
  DEFINE VAR ic            AS INTEGER NO-UNDO.
  DEFINE VAR ir            AS INTEGER NO-UNDO.    
  DEFINE VAR l_hidden      AS LOGICAL NO-UNDO.
  DEFINE VAR l_box-hidden  AS LOGICAL NO-UNDO.
  DEFINE VAR l_selected    AS LOGICAL NO-UNDO.
  DEFINE VAR min-height    AS DECIMAL NO-UNDO. /* Minumum frame height, chars */
  DEFINE VAR min-width     AS DECIMAL NO-UNDO. /* Minumum frame width, chars  */
  DEFINE VAR num-rows      AS INTEGER NO-UNDO.
  DEFINE VAR num-cols      AS INTEGER NO-UNDO.
  DEFINE VAR p-width-p     AS INTEGER NO-UNDO. /* Width of all panel buttons  */
  DEFINE VAR p-height-p    AS INTEGER NO-UNDO. /* Height of all panel buttons */
  
  {get PanelFrame hFrame}.
  
    /* The margin is based on the standard column width, unless specified
       as an attribute. The margin is 0 for character mode SmartObjects. */
    &IF "{&WINDOW-SYSTEM}" eq "TTY" &THEN
      i_margin = 0.
    &ELSE
      {get MarginPixels i_margin}. /* Some panels set a specific margin.*/
      IF i_margin eq 0 THEN
        i_margin = SESSION:PIXELS-PER-COLUMN.
    &ENDIF
    /* If there is a label, then this will move the top margin. */      
    {get BoxRectangle hRect}.
    {get PanelLabel hLabel}.
    IF VALID-HANDLE(hLabel) THEN
    DO:
      IF hLabel:SCREEN-VALUE ne "":U THEN 
      DO:
       i_lbl-hgt-p = FONT-TABLE:GET-TEXT-HEIGHT-P (hFrame:FONT).
       IF VALID-HANDLE(hRect) THEN
         i_box-Y = MAX(0, i_lbl-hgt-p - hRect:EDGE-PIXELS) / 2.
       ELSE i_box-Y = i_lbl-hgt-p.       
      END.
    END.
    ELSE ASSIGN i_lbl-hgt-p = 0
                i_box-Y     = 0.
    
    /* How many rows should there be? We assume rows should be about one ROW
       high, though this might be fudged later. */
    {get ButtonCount iButtons}.
    IF iButtons = 0 THEN    /* Deal with degenerate case to prevent a loop. */
       ASSIGN num-rows = 1
              num-cols = 1.    
    ELSE DO:
      ASSIGN num-rows = 
               TRUNCATE( pd_height - 2 * (i_margin / SESSION:PIXELS-PER-ROW),0)
             num-rows = MAX (1, MIN (iButtons, num-rows))
             num-cols = iButtons / num-rows.  
      /* Do we have enough rows and columns to hold all the buttons? If not add
         another row or column. (We add the smaller of the two so there will be a minimun
         of wasted spaces.)  */
      DO WHILE num-cols * num-rows < iButtons:
        IF num-cols > num-rows
        THEN num-cols = num-cols + 1.
        ELSE num-rows = num-rows + 1. 
      END. 
    
      /* Check that the last row is not empty. */
      DO WHILE num-cols * (num-rows - 1) >= iButtons:
        num-rows = num-rows - 1.
      END.
    END.  /* End code when iButtons is not 0. */     
    /* Don't allow a size that won't hold the margins, the frame borders, the 
       label and the UIB "affordance" menu (about 16 pixels square, located at 
       (4,4)) [Add in an extra 2 pixels for a fudge factor].
       Note that if we need to increase the size based on a minumum, 
       then we will need to verify that the frame will still fit in its parent.  One final check
       is to guarantee that each row and column is at least one pixel (this is only
       a problem if you have more than about 16 buttons). This minimum only applies
       on MS-Windows, because that is where the object will be used inside the UIB */
     &IF "{&WINDOW-SYSTEM}" eq "TTY" &THEN
       &Scoped-define min-p 0
     &ELSE
       &Scoped-define min-p 22
     &ENDIF
     ASSIGN 
         min-height = (MAX ({&min-p}, num-rows + 
           (2 * i_margin) + i_box-Y, i_lbl-hgt-p) / SESSION:PIXELS-PER-ROW) +
                       hFrame:BORDER-TOP + hFrame:BORDER-BOTTOM  
         min-width  = (MAX ({&min-p}, num-cols + 2 * i_margin) / 
                         SESSION:PIXELS-PER-COLUMN) + 
                       hFrame:BORDER-LEFT + hFrame:BORDER-RIGHT.   
    
    /* Hide the frame to reduce "flashing". Remember if it was already
       hidden, so we don't view it unnecessarily at the end of this
       procedure. (Note: Hiding a SELECTED frame turns off the Selection, 
       so we save the value to use when we make the Frame visible again.) */
    ASSIGN l_selected = hFrame:SELECTED 
           l_hidden   = hFrame:HIDDEN 
           hFrame:HIDDEN = yes
           NO-ERROR.
           
    /* Do we need to adjust the size (and position). */
    IF min-height > pd_height OR min-width > pd_width THEN DO:
      /* Get the parent to insure that the frame will still fit inside it. */ 
      h = hFrame:PARENT.
      IF h:TYPE ne "WINDOW":U THEN h = hFrame:FRAME.
      /* Test width. */  
      IF min-width > pd_width THEN DO:
        ASSIGN pd_width  = min-width
               i_width-p = 1 + (pd_width * SESSION:PIXELS-PER-COLUMN)
               i_test    = IF h:TYPE eq "WINDOW":U OR h:SCROLLABLE
                           THEN h:VIRTUAL-WIDTH-P
                           ELSE h:WIDTH-P - h:BORDER-LEFT-P - h:BORDER-RIGHT-P.
        IF i_test < hFrame:X + i_width-p 
        THEN ASSIGN hFrame:X = MAX(0, i_test - i_width-p) NO-ERROR.
      END.
      /* Test height. */
      IF min-height > pd_height THEN DO:
        ASSIGN pd_height  = min-height 
               i_height-p = 1 + (pd_height * SESSION:PIXELS-PER-ROW)
               i_test     = IF h:TYPE eq "WINDOW":U OR h:SCROLLABLE
                            THEN h:VIRTUAL-HEIGHT-P
                            ELSE h:HEIGHT-P - h:BORDER-TOP-P - h:BORDER-BOTTOM-P.
        IF i_test < hFrame:Y + i_height-p 
        THEN ASSIGN hFrame:Y = MAX(0, i_test - i_height-p) NO-ERROR.
      END.
    END.
 
    /* Resize the frame and determine values based on the desired size. */
    ASSIGN 
        hFrame:SCROLLABLE = yes
        hFrame:WIDTH      = pd_width
        hFrame:HEIGHT     = pd_height
        /* Convert from Decimal width and height be reading from the 
           FRAME itself. */
        i_width-p    = hFrame:WIDTH-P
        i_height-p   = hFrame:HEIGHT-P
        /* Save the calculation of frame borders. */
        i_border-v   = hFrame:BORDER-TOP-P +
                       hFrame:BORDER-BOTTOM-P
        i_border-h   = hFrame:BORDER-LEFT-P +
                       hFrame:BORDER-RIGHT-P
        /* Compute the total width/height of the buttons in the panel. 
           That is, subtract all the margins, decoration, and borders 
           from the frame size. */
        p-width-p    = i_width-p - i_border-h - (2 * i_margin)
        p-height-p   = i_height-p - i_border-v - i_box-Y - (2 * i_margin)
      NO-ERROR.
       
    /* Loop through all the button children and move them. */
    ASSIGN h     = hFrame:CURRENT-ITERATION
           h     = h:FIRST-CHILD
           ic    = 0
           ir    = 1
           btn-X = i_margin 
           btn-Y = i_margin + i_box-Y
           btn-height-p = p-height-p / num-rows
           .

    /* NO-FOCUS buttons appear in the widget tree in the order they were 
       realized. We cannot reposition the buttons in this order instead 
       we walk the widget tree and populate a temp-table that are indexed
       on the buttons Y and X and uses the temp-table to ensure correct 
       order when the buttons are repositioned */

    EMPTY TEMP-TABLE tButton NO-ERROR.
    
    DO WHILE VALID-HANDLE (h):
      IF h:DYNAMIC eq no AND h:TYPE eq "BUTTON":U THEN DO:
         CREATE tButton.
         ASSIGN 
            tButton.hdl  = h
            tButton.btnY = h:Y
            tButton.btnX = h:X.
      END.
      /* Get the next child. */
      h = h:NEXT-SIBLING.
    END. /* do while valid-handle*/
    
    /* Now loop through the buttons in the Y X order (default index) */
    FOR EACH tButton:
      /* Get all the statically defined buttons in the frame. (We don't want
         the little UIB-generated button in the upper-left corner). */
      h = tButton.hdl.
          /* We compute the button width and height for every row and column 
           independently. This is because we want the total size of the buttons
           to be the desired size. But each button must be an integer number of
           pixels. The round-off error can accumulate for a large panel.
           (e.g. 7 buttons in 40 pixels would mean either buttons 5 or 6 pixels
           wide. Unless we mix the sizing, then there will be only 35 pixels
           total (35 = 7 * 5). The algorithm below will have 5 buttons 6 pixels
           high and two buttons only 5 pixels high. */
      ASSIGN ic = ic + 1.
      IF ic > num-cols 
      THEN ASSIGN 
               ic    = 1
               ir    = ir + 1
               btn-X = i_margin
               btn-Y = (p-height-p * (ir - 1) / num-rows) + i_margin + i_box-Y
               btn-height-p = (p-height-p * ir / num-rows) + i_margin + i_box-Y -
                               btn-Y.
        /* Hide the button before resizing (in case we are setting the width
           and height to be larger than the frame will accomodate). */
      ASSIGN h:HIDDEN   = yes 
             h:WIDTH-P  = ((p-width-p * ic / num-cols) + i_margin) - btn-X
             h:HEIGHT-P = btn-height-p
             h:X        = btn-X
             h:Y        = btn-Y
             btn-X      = h:X + h:WIDTH-P
             h:HIDDEN   = NO
             NO-ERROR.
    END. /* for each tButton */
    
    /* If defined, set the Bounding Rectangle size. */
    IF VALID-HANDLE(hRect) THEN
      ASSIGN l_box-hidden   = hRect:HIDDEN
             hRect:HIDDEN   = yes
             hRect:X        = 0
             hRect:Y        = i_box-Y
             hRect:WIDTH-P  = i_width-p - i_border-h
             hRect:HEIGHT-P = i_height-p - i_border-v - i_box-Y
             hRect:HIDDEN   = l_box-hidden             
            NO-ERROR.

    /* If defined, set the LABEL width. */
    IF VALID-HANDLE(hLabel) THEN
      ASSIGN hLabel:HIDDEN   = yes
             hLabel:X        = i_margin
             hLabel:Y        = 0 
             hLabel:WIDTH-P  = MIN(FONT-TABLE:GET-TEXT-WIDTH-P 
                                     (hLabel:SCREEN-VALUE, hFrame:FONT),
                                    i_width-p - hLabel:X - i_border-h) 
             hLabel:HEIGHT-P = MIN(i_lbl-hgt-p, i_height-p - i_border-v)
             hLabel:HIDDEN   = (hLabel:SCREEN-VALUE eq "":U)                                
            NO-ERROR.


    /* Show the frame. Turn off SCROLLABLE to force virtual size to match
       viewport size.  We will turn SCROLLABLE back on so that the SmartPanel
       can be resized smaller. */
    ASSIGN hFrame:SCROLLABLE       = NO
           hFrame:WIDTH-P          = i_width-p
           hFrame:HEIGHT-P         = i_height-p
           NO-ERROR .  
    /* Frame must be SCROLLABLE if it is to be resized smaller than its
       contained buttons and rectangles. */    
    ASSIGN hFrame:SCROLLABLE = YES.
            
    /* View, and select, the frame, if necessary. */
    IF NOT l_hidden THEN hFrame:HIDDEN   = no NO-ERROR.
    IF l_selected   THEN hFrame:SELECTED = yes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Receives state message events related to record updates.
  Parameters:  pcState AS CHARACTER -- upstate state, can be 'Update' or
               'UpdateComplete'
    Notes:     For 'Update', a Navigation Panel will set its PanelState
               property to disable-all, to prevent navigation during an 
               update operation. A Save or Update panel will set its
               state to 'action-chosen', meaning that a button has been 
               pressed that puts the panel in the middle of an Update or
               Add or Copy operation that must be explicitly Saved to be
               completed.
               For 'UpdateComplete', a Navigation Panel will restore the
               prior PanelState (having been disabled when the update began).
               A Save or Update panel will set its state to 'add-only' if
               no rows are available in the current dataset, to 'disable-all'
               if no rows are available and there is also no available
               parent row for this dataset (meaning that not even an Add
               could be done), or to 'initial' if the RecordState is
               RecordAvailable, meaning that all operations are allowed
               (Update/Add/Copy/Delete).
               In addition, for an Update panel, which explicitly enables
               fields when an Update begins and disables when them the
               operation is Saved, the updateMode event is published
               with a value of 'UpdateEnd', to tell visualizations to 
               disable their fields.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cPanelType     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPanelState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryPos      AS CHARACTER NO-UNDO.
  
  {get PanelType cPanelType}.
  CASE pcState:
    WHEN 'Update':U THEN 
    DO:
      IF cPanelType BEGINS 'Nav':U THEN  
      DO:
        /* Note: We don't actually reset the state because we want to restore it
           after the update is complete (to FirstRecord or whatever). */
        RUN setButtons IN TARGET-PROCEDURE('disable-all':U).
      END.
      ELSE IF cPanelType BEGINS 'Save':U OR cPanelType BEGINS 'Update':U THEN
        {set PanelState 'action-chosen':U}.
    END.
    WHEN 'UpdateComplete':U THEN
    DO:
      IF cPanelType BEGINS 'Nav':U THEN
      DO:
        /* Restore whatever the queryPosition state was before the update. */
        {get PanelState cPanelState}.
        RUN setButtons IN TARGET-PROCEDURE (cPanelState).
      END.  /* END Nav code */
      ELSE IF cPanelType BEGINS 'Save':U OR cPanelType BEGINS 'Update':U THEN   
      DO: 
        /* NOTE: "Multiple-Add" case not yet supported in V9 */
        {get RecordState cQueryPos SOURCE-PROCEDURE}.
        CASE cQueryPos:
          WHEN 'NoRecordAvailable':U      THEN cPanelState = 'add-only':U.
          WHEN 'NoRecordAvailableExt':U   THEN cPanelState = 'disable-all':U.
          WHEN 'RecordAvailable':U        THEN cPanelState = 'initial':U.
        END CASE.
        {set PanelState cPanelState}.
        IF cPanelType BEGINS 'Update':U THEN
        DO:
          RUN applyEntry IN TARGET-PROCEDURE (?).  /* get focus into the panel. */
          PUBLISH 'updateMode':U FROM TARGET-PROCEDURE ('updateEnd':U).
        END.
      END.  /* END Save/Update code */
    END.
  END CASE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getBoxRectangle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBoxRectangle Procedure 
FUNCTION getBoxRectangle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle to the rectangle, if any, which draws a 
            "box" around the buttons in the Panel -- used by resizeObject.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBox AS HANDLE NO-UNDO.
  {get BoxRectangle hBox}.
  RETURN hBox.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getButtonCount) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getButtonCount Procedure 
FUNCTION getButtonCount RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the number of buttons in a SmartPanel, for resizeObject
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
  {get ButtonCount iCount}.
  RETURN iCount.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEdgePixels Procedure 
FUNCTION getEdgePixels RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the number of pixels that should be used to draw the
            rectangle around the buttons on a SmartPanel.
   Params:  <none>
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE hRect AS HANDLE NO-UNDO.
  
  {get BoxRectangle hRect}.
  IF VALID-HANDLE(hRect) THEN
    RETURN hRect:EDGE-PIXELS.
  ELSE RETURN ?.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMarginPixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMarginPixels Procedure 
FUNCTION getMarginPixels RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the number of pixels to reserve for the Panel margin --
            used by resizeObject.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iPixels AS INTEGER NO-UNDO.
  {get MarginPixels iPixels}.
  RETURN iPixels.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPanelFrame Procedure 
FUNCTION getPanelFrame RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Frame handle of the SmartPanel, for resizeObject
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hFrame AS HANDLE NO-UNDO.
  {get PanelFrame hFrame}.
  RETURN hFrame.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPanelLabel Procedure 
FUNCTION getPanelLabel RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the Panel's Label, if any 
   Params:  <none>
    Notes:  used by resizeObject.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hLabel AS HANDLE NO-UNDO.
  {get PanelLabel hLabel}.
  RETURN hLabel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPanelState Procedure 
FUNCTION getPanelState RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current state of the SmartPanel.
   Params:  <none>
------------------------------------------------------------------------------*/

    /* We don't use {get} here because there is no preprocessor for this
       property, to prevent direct access
       to the value for the "set" function, which must also run a procedure,
       so the "get" function must also access that value. */

  DEFINE VARIABLE cState AS CHARACTER NO-UNDO.
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('PanelState':U)
         cState = ghProp:BUFFER-VALUE.
  RETURN cState.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPanelType Procedure 
FUNCTION getPanelType RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the type of SmartPanel ('Update', 'Navigation')
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cType AS CHARACTER NO-UNDO.
  {get PanelType cType}.
  RETURN cType.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEdgePixels Procedure 
FUNCTION setEdgePixels RETURNS LOGICAL
  (piPixels AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the number of edge-pixels in the enclosing rectangle for
            the Panel's buttons.
   Params:  piPixels AS INTEGER 
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE hRect   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iPixels AS INTEGER NO-UNDO.
  
  {get BoxRectangle hRect}.
  IF VALID-HANDLE(hRect) THEN
  DO:
    &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN 
       iPixels = 0.     /* No border rectangle for TTY. */
    &ELSE
       iPixels = piPixels.
    &ENDIF    
    IF piPixels NE hRect:EDGE-PIXELS THEN
      hRect:EDGE-PIXELS = iPixels.
    RETURN TRUE.
  END.
  ELSE RETURN FALSE.   /* No Rectangle to set.  */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPanelState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPanelState Procedure 
FUNCTION setPanelState RETURNS LOGICAL
  ( pcPanelState AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the state of the Panel's buttons.
   Params:  pcPanelState AS CHARACTER
    Notes:  Also runs the panel procedure setButtons, which changes which 
            buttons are enabled and disabled based on the state.
------------------------------------------------------------------------------*/
  
    /* The state name does not have a property preprocessor for it 
       to prevent it from being set directly, because setButtons is always
       run as a side-effect, to make the new state take effect;
       so we don't use the {set} syntax to set it. */

  RUN setButtons IN TARGET-PROCEDURE (pcPanelState).
  IF RETURN-VALUE NE "ADM-ERROR":U THEN
  DO:
    ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
           ghProp = ghProp:BUFFER-FIELD('PanelState':U)
           ghProp:BUFFER-VALUE = pcPanelState.   
    RETURN TRUE.
  END.
  ELSE RETURN FALSE.   /* new state was invalid somehow. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPanelType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPanelType Procedure 
FUNCTION setPanelType RETURNS LOGICAL
  ( pcPanelType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the type of Panel: Navigation, Save, Update
   Params:  pcPanelType AS CHARACTER
------------------------------------------------------------------------------*/

  {set PanelType pcPanelType}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

