&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Attribute-Dlg 
/*------------------------------------------------------------------------

  File: dynbrowserd.w 

  Description: Instance Properties Dialog for Dynamic SmartDataBrowser.

  Input Parameters:
     p_hSMO -- Procedure Handle of calling SmartObject.

  Output Parameters:
      <none>

  Modified: July 1, 1999, Version 9.1A
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&GLOBAL-DEFINE WIN95-BTN YES

/* Parameters Definitions ---                                           */
  DEFINE INPUT PARAMETER p_hSMO AS HANDLE NO-UNDO.

/* Local Variable Definitions ---                                       */
  DEFINE VARIABLE attr-list        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE orig-layout      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDisplayedFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cEnabledFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSDO             AS HANDLE    NO-UNDO.

/* Define the value of the "No Layout Options" supplied. */
&Scoped-define no-layout [default]

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Attribute-Dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Displayed-Btn Enabled-Btn c_SearchField ~
l_Enable i_numdown l_View l_calcWidth 
&Scoped-Define DISPLAYED-OBJECTS c_SearchField l_Enable c_Layout i_numdown ~
l_View i_maxWidth l_calcWidth 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD populateSearchField Attribute-Dlg 
FUNCTION populateSearchField RETURNS LOGICAL
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Displayed-Btn 
     LABEL "Edit &Displayed field list" 
     SIZE 25 BY 1.14.

DEFINE BUTTON Enabled-Btn 
     LABEL "Edit E&nabled field list" 
     SIZE 25 BY 1.14.

DEFINE VARIABLE c_Layout AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Layout" 
     VIEW-AS COMBO-BOX 
     DROP-DOWN-LIST
     SIZE 28 BY 1 NO-UNDO.

DEFINE VARIABLE c_SearchField AS CHARACTER FORMAT "X(256)":U 
     LABEL "Search Field" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE i_maxWidth AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "&Max Width" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1 NO-UNDO.

DEFINE VARIABLE i_numdown AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Do&wn" 
     VIEW-AS FILL-IN 
     SIZE 7.2 BY 1 NO-UNDO.

DEFINE VARIABLE l_calcWidth AS LOGICAL INITIAL no 
     LABEL "&Calculate Width" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.2 BY .86 NO-UNDO.

DEFINE VARIABLE l_Enable AS LOGICAL INITIAL no 
     LABEL "&Enable" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .86 NO-UNDO.

DEFINE VARIABLE l_View AS LOGICAL INITIAL no 
     LABEL "&View" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.2 BY .86 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Attribute-Dlg
     Displayed-Btn AT ROW 2.19 COL 3
     Enabled-Btn AT ROW 3.62 COL 3
     c_SearchField AT ROW 6 COL 4
     l_Enable AT ROW 8.38 COL 2.8
     c_Layout AT ROW 8.38 COL 33.2 COLON-ALIGNED
     i_numdown AT ROW 9.52 COL 33.2 COLON-ALIGNED
     l_View AT ROW 9.57 COL 2.8
     i_maxWidth AT ROW 10.67 COL 33.2 COLON-ALIGNED
     l_calcWidth AT ROW 10.76 COL 2.8
     "  Behavior During 'Initialize'" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 7.43 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "  (Default is all fields)" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 2.43 COL 30
     "  (Default is all Updatable fields)" VIEW-AS TEXT
          SIZE 31 BY .62 AT ROW 3.86 COL 30
     "  SmartDataObject fields to display and enable" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 1.24 COL 2
          BGCOLOR 1 FGCOLOR 15 
     "  Allow Reposition using a Search Field" VIEW-AS TEXT
          SIZE 62 BY .62 AT ROW 5.05 COL 2
          BGCOLOR 1 FGCOLOR 15 
     SPACE(1.19) SKIP(6.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Dynamic SmartDataBrowser Properties":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Attribute-Dlg
   L-To-R                                                               */
ASSIGN 
       FRAME Attribute-Dlg:SCROLLABLE       = FALSE
       FRAME Attribute-Dlg:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX c_Layout IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX c_SearchField IN FRAME Attribute-Dlg
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN i_maxWidth IN FRAME Attribute-Dlg
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Attribute-Dlg
/* Query rebuild information for DIALOG-BOX Attribute-Dlg
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Attribute-Dlg */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Attribute-Dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON GO OF FRAME Attribute-Dlg /* Dynamic SmartDataBrowser Properties */
DO:     
  /* Reassign the attribute alues back in the SmartObject. */
  ASSIGN l_Enable l_View c_SearchField
         c_Layout = c_Layout:SCREEN-VALUE WHEN c_Layout:SENSITIVE
         i_NumDown l_CalcWidth i_MaxWidth
         .
         
  DYNAMIC-FUNC("setDisableOnInit":U IN p_hSMO, INPUT NOT l_Enable) NO-ERROR.
  DYNAMIC-FUNC("setHideOnInit":U IN p_hSMO, INPUT NOT l_View) NO-ERROR.
  DYNAMIC-FUNC("setDisplayedFields":U IN p_hSMO, INPUT cDisplayedFields) NO-ERROR.
  DYNAMIC-FUNC("setEnabledFields":U IN p_hSMO, INPUT cEnabledFields) NO-ERROR.
  
  DYNAMIC-FUNC("setSearchField":U IN p_hSMO, 
    IF c_SearchField = "<none>":U THEN "":U ELSE c_SearchField) NO-ERROR.

  /* Only set the layout if it has changed.  Remember that LAYOUT is an
     attribute whose changes must be explicitly applied. */
  IF c_Layout:SENSITIVE AND c_Layout ne orig-layout THEN DO:
    IF c_Layout eq "{&no-layout}":U THEN c_Layout = "":U.
    DYNAMIC-FUNC("setObjectLayout":U IN p_hSMO, INPUT c_Layout) NO-ERROR.
    RUN applyLayout IN p_hSMO.
  END.

  DYNAMIC-FUNC("setNumDown":U IN p_hSMO, INPUT i_NumDown) NO-ERROR.
  DYNAMIC-FUNC("setCalcWidth":U IN p_hSMO, INPUT l_CalcWidth) NO-ERROR.
  DYNAMIC-FUNC("setMaxWidth":U IN p_hSMO, INPUT i_MaxWidth) NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Attribute-Dlg Attribute-Dlg
ON WINDOW-CLOSE OF FRAME Attribute-Dlg /* Dynamic SmartDataBrowser Properties */
DO:
  /* Add Trigger to equate WINDOW-CLOSE to END-ERROR */
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Displayed-Btn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Displayed-Btn Attribute-Dlg
ON CHOOSE OF Displayed-Btn IN FRAME Attribute-Dlg /* Edit Displayed field list */
DO:
  DEFINE VARIABLE iEntry     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField     AS CHARACTER NO-UNDO.
  
  IF VALID-HANDLE(hSDO) THEN    
  DO:
    RUN adecomm/_mfldsel.p
     (INPUT "":U,     /* Use an SDO, not db tables */
      INPUT hSDO,     /* handle of the SDO */
      INPUT ?,        /* No additional temp-tables */
      INPUT "1":U,    /* No db or table name qualification of fields */
      INPUT ",":U,    /* list delimiter */
      INPUT "":U,     /* exclude field list */
      INPUT-OUTPUT cDisplayedFields).
    /* If any fields were removed from the display list, then we need to make
       sure they are no longer in the enable list. */
    IF cEnabledFields NE "":U THEN
    DO:
      cEnabledFields = ",":U + cEnabledFields + ",":U.  /* Allow removal from list. */
      DO iEntry = 1 TO NUM-ENTRIES(cEnabledFields):
        cField = ENTRY(iEntry, cEnabledFields).
        IF LOOKUP(cField, cDisplayedFields) = 0 THEN
          cEnabledFields = REPLACE(cEnabledFields, ",":U + cField + ",":U, ",":U).
      END.   /* END DO iEntry */
      cEnabledFields = SUBSTR(cEnabledFields, 2, LENGTH(cEnabledFields) - 2).
    END.     /* END DO IF cEnabledFields */
    populateSearchField().
  END.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Enabled-Btn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Enabled-Btn Attribute-Dlg
ON CHOOSE OF Enabled-Btn IN FRAME Attribute-Dlg /* Edit Enabled field list */
DO:
    DEFINE VARIABLE cUpdatable AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cExclude   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDataCols  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iEntry     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cField     AS CHARACTER NO-UNDO.
  
  IF VALID-HANDLE(hSDO) THEN    
  DO:
    {get UpdatableColumns cUpdatable hSDO}.
    {get DataColumns cDataCols hSDO}.
    
    /* We need to exclude from the permissible EnableFields list anything
       that either isn't in the UpdatableColumns of the SDO or isn't in
       the DisplayedFields list for the browser. */
    DO iEntry = 1 TO NUM-ENTRIES(cDataCols):
      cField = ENTRY(iEntry, cDataCols).
      IF LOOKUP(cField, cUpdatable) = 0 OR
        (cDisplayedFields NE "":U AND LOOKUP(cField, cDisplayedFields) = 0) 
      THEN
        cExclude = cExclude + (IF cExclude NE "":U THEN ",":U ELSE "":U) +
          cField.
    END.    /* END DO iEntry */
    
    RUN adecomm/_mfldsel.p
     (INPUT "":U,     /* Use an SDO, not db tables */
      INPUT hSDO,     /* handle of the SDO */
      INPUT ?,        /* No additional temp-tables */
      INPUT "1":U,    /* No db or table name qualification of fields */
      INPUT ",":U,    /* list delimiter */
      INPUT cExclude, /* exclude field list */
      INPUT-OUTPUT cEnabledFields).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l_calcWidth
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l_calcWidth Attribute-Dlg
ON VALUE-CHANGED OF l_calcWidth IN FRAME Attribute-Dlg /* Calculate Width */
DO:
  ASSIGN l_CalcWidth.
  i_MaxWidth:SENSITIVE = l_CalcWidth.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Attribute-Dlg 


/* **************** Standard Buttons and Help Setup ******************* */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Define Context ID's for HELP files */
{ src/adm2/support/admhlp.i }    

/* Attach the standard OK/Cancel/Help button bar. */
{ adecomm/okbar.i  &TOOL = "AB"
                   &CONTEXT = {&VisualSmartObject_Attributes_Dlg_Box} }

/* ***************************  Main Block  *************************** */

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  /* Get the values of the attributes in the SmartObject that can be 
     changed in this dialog-box. */
  RUN get-SmO-attributes.
  
  /* Enable the interface. */         
  RUN enable_UI.  
  
  /* If no Data-Source, don't attempt edits */
  IF NOT VALID-HANDLE(hSDO) THEN   
      ASSIGN Displayed-Btn:SENSITIVE = no
             Enabled-Btn:SENSITIVE = no.
             
  /* Set the cursor */
  RUN adecomm/_setcurs.p ("":U).  
 
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.  
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Attribute-Dlg  _DEFAULT-DISABLE
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
  HIDE FRAME Attribute-Dlg.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Attribute-Dlg  _DEFAULT-ENABLE
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
  DISPLAY c_SearchField l_Enable c_Layout i_numdown l_View i_maxWidth 
          l_calcWidth 
      WITH FRAME Attribute-Dlg.
  ENABLE Displayed-Btn Enabled-Btn c_SearchField l_Enable i_numdown l_View 
         l_calcWidth 
      WITH FRAME Attribute-Dlg.
  VIEW FRAME Attribute-Dlg.
  {&OPEN-BROWSERS-IN-QUERY-Attribute-Dlg}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-SmO-attributes Attribute-Dlg 
PROCEDURE get-SmO-attributes :
/*------------------------------------------------------------------------------
  Purpose:     Ask the "parent" SmartObject for the attributes that can be 
               changed in this dialog.  Save some of the initial-values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ldummy   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cContext AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSDO     AS CHARACTER NO-UNDO.
   
  DO WITH FRAME {&FRAME-NAME}:   
    /* Get the attributes used in this Instance Attribute dialog-box. */
    l_Enable = NOT DYNAMIC-FUNC("getDisableOnInit":U IN p_hSMO).
    l_View   = NOT DYNAMIC-FUNC("getHideOnInit":U IN p_hSMO).
    cDisplayedFields = DYNAMIC-FUNC("getDisplayedFields":U IN p_hSMO).
    cEnabledFields = DYNAMIC-FUNC("getEnabledFields":U IN p_hSMO).
    c_SearchField = DYNAMIC-FUNC("getSearchField":U IN p_hSMO).
    c_SearchField =  IF c_SearchField = "":U OR c_SearchField = ? THEN
       "<none>":U ELSE c_SearchField.
    i_NumDown = DYNAMIC-FUNC("getNumDown":U IN p_hSMO).
    l_CalcWidth = DYNAMIC-FUNC("getCalcWidth":U IN p_hSMO).
    i_MaxWidth = DYNAMIC-FUNC("getMaxWidth":U IN p_hSMO).
       
    /* MaxWidth needs be be enabled if CalcWidth is true */
    IF l_CalcWidth THEN i_MaxWidth:SENSITIVE = TRUE.

    /* Choose Layout. */
    /* V8: RUN get-attribute IN p_hSMO ("Layout-Options":U). */
    ASSIGN c_Layout = DYNAMIC-FUNC("getLayoutOptions":U IN p_hSMO) NO-ERROR.
    ASSIGN c_Layout = (IF c_Layout <> ? THEN c_Layout ELSE "").
    
    ASSIGN 
      c_Layout:LIST-ITEMS  = c_Layout
      ldummy               = c_Layout:ADD-FIRST ("{&no-layout}":U)
      c_Layout:SENSITIVE   = c_Layout:NUM-ITEMS > 1
      c_Layout:INNER-LINES = MIN(10,MAX(3,c_Layout:NUM-ITEMS + 1)).

    /* V8: RUN get-attribute IN p_hSMO ("Layout":U). */
    ASSIGN c_Layout = DYNAMIC-FUNC("getObjectLayout":U IN p_hSMO) NO-ERROR.
    ASSIGN c_Layout    = IF c_Layout = ? OR c_Layout = "":U OR
                            c_Layout = "?":U /* Compatibility with ADM1.0 */
                         THEN "{&no-layout}":U 
                         ELSE c_Layout
           orig-layout = c_Layout.
    
    
    /* Also get the handle of the associated SmartDataObject, if any. */
    RUN adeuib/_uibinfo (?, "HANDLE ":U + STRING(p_hSMO), "LINK DATA-SOURCE":U, 
      OUTPUT cContext).      /* Returns the Context ID of our Data-Source */
    RUN adeuib/_uibinfo (INT(cContext), ?, "PROCEDURE-HANDLE":U,
      OUTPUT cSDO).
    hSDO = WIDGET-HANDLE(cSDO).
    
    populateSearchField().   /* Build list of combo box values */
    
  END. /* DO WITH FRAME... */
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION populateSearchField Attribute-Dlg 
FUNCTION populateSearchField RETURNS LOGICAL
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  builds the list of values for the SearchField (= DisplayedFields).
    Notes:  
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE lResult AS LOGICAL NO-UNDO.
    DEFINE VARIABLE cFields AS CHARACTER NO-UNDO.
    
    IF cDisplayedFields = "":U THEN
      /* This means no explicit field list has been selected, so the fieldlist
         is in fact *all* SDO fields; so make these available as search fields. */
      cFields = dynamic-function('getDataColumns':U IN hSDO) NO-ERROR.
    ELSE cFields = cDisplayedFields.
    
    ASSIGN c_SearchField:LIST-ITEMS In FRAME {&FRAME-NAME} = cFields
           lResult = c_SearchField:ADD-FIRST ("<none>":U)
           c_SearchField:INNER-LINES = MAX(20,NUM-ENTRIES(cFields))
           c_SearchField:SCREEN-VALUE = c_SearchField NO-ERROR.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

