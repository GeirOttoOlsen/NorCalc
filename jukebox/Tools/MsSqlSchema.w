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
DEF VAR cDfFile     AS CHAR NO-UNDO.

DEF TEMP-TabLE ttMsSqlSchema
  FIELD Table_Type       AS CHAR FORMAT "x(12)"
  FIELD Table_Name       AS CHAR FORMAT "x(40)"
  FIELD Ordinal_Position AS INT  
  FIELD Column_Name      AS CHAR FORMAT "x(32)"
  FIELD Data_Type        AS CHAR FORMAT "x(20)"
  FIELD Column_Default   AS CHAR FORMAT "x(40)"
  FIELD Character_Maximum_Length AS INT64 FORMAT "->>>,>>>,>>9"
//  FIELD CHARACTER_MAXIMUM_LENGTH AS INT64 FORMAT ">>>,>>>,>>9"
  FIELD Table_Catalog    AS CHAR FORMAT "x(40)"
  FIELD Table_Schema     AS CHAR FORMAT "x(40)"
  FIELD RowCount         AS INT
  FIELD ColNameLength    AS INT
  FIELD OEFieldName      AS CHAR FORMAT "x(32)"
  FIELD OEdataType       AS CHAR FORMAT "x(10)"
  FIELD OEformat         AS CHAR FORMAT "x(25)"
  FIELD OElabel          AS CHAR FORMAT "x(32)"
  FIELD OEvalmsg         AS CHAR FORMAT "x(50)"
  . 
  
DEF VAR oBrwMsSqlSchema AS JBoxBrowse NO-UNDO.


DEF VAR otbMsSqlSchema AS JBoxToolbar NO-UNDO.


DEF VAR opopup_MsSqlSchema AS JBoxPopupMenu NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnfiDatabase brwMsSqlSchema tbMsSqlSchema ~
searchMsSqlSchema filter_tbMsSqlSchema delete_tbMsSqlSchema ~
excel_tbMsSqlSchema flatview_tbMsSqlSchema CreateDF_tbMsSqlSchema ~
fiDatabase 
&Scoped-Define DISPLAYED-OBJECTS fiDatabase 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setProgressProp C-Win 
FUNCTION setProgressProp RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnfiDatabase 
     IMAGE-UP FILE "bmp/folderopen.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON CreateDF_tbMsSqlSchema 
     LABEL "Create DF-file" 
     SIZE 15 BY 1.52 TOOLTIP "Create DF".

DEFINE BUTTON delete_tbMsSqlSchema 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 6 BY 1.52 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON excel_tbMsSqlSchema 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 6 BY 1.52 TOOLTIP "Excel Export".

DEFINE BUTTON filter_tbMsSqlSchema 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON flatview_tbMsSqlSchema 
     IMAGE-UP FILE "gif/sdogen16.gif":U
     LABEL "Drill-down view" 
     SIZE 6 BY 1.52 TOOLTIP "Drill-down view (ALT-D)".

DEFINE VARIABLE fiDatabase AS CHARACTER FORMAT "X(256)":U INITIAL "j:~\test~\kompisconnect.ini" 
     LABEL "Database" 
     VIEW-AS FILL-IN 
     SIZE 61 BY 1 TOOLTIP "Database-name or name of ini-file containing connect-info" NO-UNDO.

DEFINE RECTANGLE brwMsSqlSchema
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 14.29.

DEFINE RECTANGLE searchMsSqlSchema
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22 BY .91.

DEFINE RECTANGLE tbMsSqlSchema
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 114 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnfiDatabase AT ROW 3.14 COL 107 WIDGET-ID 14 NO-TAB-STOP 
     filter_tbMsSqlSchema AT ROW 1.33 COL 2.2 WIDGET-ID 6
     delete_tbMsSqlSchema AT ROW 1.33 COL 8.4 WIDGET-ID 16
     excel_tbMsSqlSchema AT ROW 1.33 COL 14.4 WIDGET-ID 8
     flatview_tbMsSqlSchema AT ROW 1.33 COL 20.4 WIDGET-ID 10
     CreateDF_tbMsSqlSchema AT ROW 1.33 COL 26.4 WIDGET-ID 12
     fiDatabase AT ROW 3.14 COL 44 COLON-ALIGNED
     brwMsSqlSchema AT ROW 4.57 COL 2 WIDGET-ID 2
     tbMsSqlSchema AT ROW 1.24 COL 2 WIDGET-ID 4
     searchMsSqlSchema AT ROW 3.19 COL 2.6 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 115.6 BY 18 WIDGET-ID 100.


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
         HEIGHT             = 18
         WIDTH              = 115.6
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 115.6
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 115.6
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
       FRAME DEFAULT-FRAME:HEIGHT           = 18
       FRAME DEFAULT-FRAME:WIDTH            = 115.6.

ASSIGN 
       fiDatabase:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "j:\test\kompisconnect.ini".

ASSIGN 
       tbMsSqlSchema:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "filter;Filter,delete;Slett,excel;Eksporter til E&xcel,flatview;Drill-down view,CreateDF;Create DF-filemaxborder".

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


&Scoped-define SELF-NAME btnfiDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnfiDatabase C-Win
ON CHOOSE OF btnfiDatabase IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  cUseFileName = fiDatabase:SCREEN-VALUE.

  SYSTEM-DIALOG GET-FILE cUseFileName USE-FILENAME UPDATE bOk.
  IF bOk THEN 
    fiDatabase:SCREEN-VALUE = cUseFileName.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDatabase C-Win
ON RETURN OF fiDatabase IN FRAME DEFAULT-FRAME /* Database */
DO:
    IF JBoxServerAPI:Instance:GetMyTempTable("jbserv_get_sql_data.p",fiDatabase:SCREEN-VALUE + "|SELECT * FROM INFORMATION_SCHEMA.COLUMNS JOIN INFORMATION_SCHEMA.TABLES ON INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME",oBrwMsSqlSchema:BUFFER-HANDLE) THEN DO:
      setProgressProp(). 
      oBrwMsSqlSchema:openQuery().
    END.  
    ELSE
      JBoxServerAPI:Instance:viewCallMessage().   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseContentRecord C-Win 
PROCEDURE BrowseContentRecord :
RUN SUPER.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateDFRecord C-Win 
PROCEDURE CreateDFRecord :
DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  cUseFileName = cDfFile.

  SYSTEM-DIALOG GET-FILE cUseFileName USE-FILENAME UPDATE bOk.
  IF bOk THEN DO:
    cDfFile = cUseFileName.
    
    OUTPUT TO VALUE(cDfFile).
    FOR EACH ttMsSqlSchema
        WHERE ttMsSqlSchema.OEFieldName NE ""
        BREAK BY ttMsSqlSchema.Table_Name
              BY ttMsSqlSchema.Ordinal_Position
        :
      IF FIRST-OF(ttMsSqlSchema.Table_Name) THEN
        PUT UNFORMATTED 'ADD TABLE "' ttMsSqlSchema.Table_Name '"' SKIP(1).
      
       
      PUT UNFORMATTED 'ADD FIELD "' ttMsSqlSchema.OEFieldName '" OF "' ttMsSqlSchema.Table_Name '" AS ' ttMsSqlSchema.OEdataType SKIP.
      PUT UNFORMATTED '  FORMAT "' ttMsSqlSchema.OEformat '"' SKIP.
      PUT UNFORMATTED '  LABEL "' ttMsSqlSchema.OElabel '"' SKIP.
      IF ttMsSqlSchema.OEvalmsg NE "" THEN
        PUT UNFORMATTED '  VALMSG "' ttMsSqlSchema.OEvalmsg '"' SKIP(1).
      ELSE PUT SKIP(1).
    END.
    
    OUTPUT CLOSE.     
    OS-COMMAND NO-WAIT VALUE("notepad " + cDfFile).          
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
  DISPLAY fiDatabase 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btnfiDatabase brwMsSqlSchema tbMsSqlSchema searchMsSqlSchema 
         filter_tbMsSqlSchema delete_tbMsSqlSchema excel_tbMsSqlSchema 
         flatview_tbMsSqlSchema CreateDF_tbMsSqlSchema fiDatabase 
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
DEF VAR oBrwFillInOElabel AS JBoxBrowseFillIn NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  oBrwMsSqlSchema = NEW JBoxBrowse(brwMsSqlSchema:HANDLE,YES,"",NO,BUFFER ttMsSqlSchema:HANDLE).
  oBrwMsSqlSchema:buffersAndFields = "ttMsSqlSchema"
           + ";Table_Name"
           + ";Table_Type"
           + ";Column_Name"
           + ";Data_Type"
           + ";ColNameLength"
           + ";Character_Maximum_Length"
           + ";Table_Schema"
           + ";Table_Catalog"
           + ";OEFieldName"
           + ";OEdataType"
           + ";OEformat"
           + ";OElabel"
           + ";OEvalmsg"
            .

  oBrwMsSqlSchema:setQuerySort("Table_Name,Ordinal_Position").
  oBrwMsSqlSchema:setFilter("Table_Type","=","base table").
  oBrwMsSqlSchema:setSearchField(searchMsSqlSchema:HANDLE,"Table_Name").

//  oBrwFillInOElabel = NEW JBoxBrowseFillIn(oBrwMsSqlSchema,"OElabel").
  oBrwMsSqlSchema:enabledColumns = "OEformat,OElabel".
  oBrwMsSqlSchema:enableOnDblClick = YES.
  
  otbMsSqlSchema = NEW JBoxToolbar(tbMsSqlSchema:HANDLE).

  oBrwMsSqlSchema:TOOLBAR-OBJECT = otbMsSqlSchema.
  
  opopup_MsSqlSchema = NEW JBoxPopupMenu().
  opopup_MsSqlSchema:AddToolGroup('multiSortBrowse;Sorter på flere kolonner,BrowseContent;Browse data').

  oBrwMsSqlSchema:POPUP-MENU-OBJECT = opopup_MsSqlSchema.

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setProgressProp C-Win 
FUNCTION setProgressProp RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR bOk          AS LOG  NO-UNDO.
DEF VAR cFldName     AS CHAR NO-UNDO.
DEF VAR cFldType     AS CHAR NO-UNDO.
DEF VAR cFldFormat   AS CHAR NO-UNDO.
DEF VAR cLabel       AS CHAR NO-UNDO.
DEF VAR cValMsg      AS CHAR NO-UNDO.

FOR EACH ttMsSqlSchema
    WHERE ttMsSqlSchema.Table_Type = "BASE TABLE"
      AND ttMsSqlSchema.Table_Name NE "sysdiagrams"
    :
  
  CASE ttMsSqlSchema.Data_Type:  
    WHEN "nvarchar" OR WHEN "varchar" OR WHEN "char" OR WHEN "varbinary" OR WHEN "binary" OR WHEN "text" THEN 
      ASSIGN cFldType = "CHARACTER"
             cFldFormat = 'x(' + STRING(MAX(1,MIN(ttMsSqlSchema.Character_Maximum_Length,100))) + ')'.       
    WHEN "bit" THEN 
      ASSIGN cFldType = "LOGICAL"
             cFldFormat = 'True/False'.       
    WHEN "int" OR WHEN "smallint" THEN 
      ASSIGN cFldType = "INTEGER"
             cFldFormat = '->>>>>>>>9'.       
    WHEN "tinyint" THEN 
      ASSIGN cFldType = "INTEGER"
             cFldFormat = '->>9'.       
    WHEN "bigint" THEN 
      ASSIGN cFldType = "INT64"
             cFldFormat = '->>>>>>>>>>9'.       
    WHEN "uniqueidentifier" THEN 
      ASSIGN cFldType = "CHARACTER"
             cFldFormat = 'x(50)'.       
    WHEN "datetime" THEN
      ASSIGN cFldType = "DATETIME"
             cFldFormat = '99.99.9999 HH:MM:SS'.
    WHEN "smalldatetime" THEN
      ASSIGN cFldType = "DATE"
             cFldFormat = '99.99.9999'.
    WHEN "float" OR WHEN "numeric" OR WHEN "decimal" OR WHEN "real" THEN
      ASSIGN cFldType = "DECIMAL"
             cFldFormat = '->>>,>>>,>>9.99'.
    WHEN "smallmoney" OR WHEN "money" THEN
      ASSIGN cFldType = "DECIMAL"
             cFldFormat = '->>,>>>,>>9.9999'.
    OTHERWISE NEXT.         
/*        WHEN "text" THEN                          */
/*          ASSIGN cFldType = "CLOB"                */
/*                 cFldFormat = '  FORMAT "x(255)"'.*/
/*        WHEN "image" THEN                         */
/*          ASSIGN cFldType = "BLOB"                */
/*                 cFldFormat = '  FORMAT "x(8)"'.  */
  END CASE.     
  
  ttMsSqlSchema.Table_Name = REPLACE(ttMsSqlSchema.Table_Name,"æ","a_e_").
  ttMsSqlSchema.Table_Name = REPLACE(ttMsSqlSchema.Table_Name,"ø","o_e_").
  ttMsSqlSchema.Table_Name = REPLACE(ttMsSqlSchema.Table_Name,"å","a_a_").
  ttMsSqlSchema.Table_Name = REPLACE(ttMsSqlSchema.Table_Name," ","__").
  IF LENGTH(ttMsSqlSchema.Table_Name) > 32 THEN
    ttMsSqlSchema.Table_Name = SUBSTR(ttMsSqlSchema.Table_Name,1,30) + "__".
    
  cFldName = ttMsSqlSchema.Column_Name.    
  ttMsSqlSchema.ColNameLength = LENGTH(ttMsSqlSchema.Column_Name).
  cValMsg  = "".
  cLabel   = CAPS(SUBSTR(cFldName,1,1)) + SUBSTR(cFldName,2).
  cFldName = REPLACE(cFldName,"æ","a_e_").  
  cFldName = REPLACE(cFldName,"ø","o_e_").  
  cFldName = REPLACE(cFldName,"å","a_a_").  
  cFldName = REPLACE(cFldName," ","__").
  cFldName = REPLACE(cFldName,"(","#_#_").
  cFldName = REPLACE(cFldName,")","_#_#").
  IF CAN-DO("value,status,alias,message,locked,text,userid,label,format,available,color,ascending",cFldName) THEN
    cFldName = cFldName + "_".
  
  IF LENGTH(cFldName) > 32 THEN
    ASSIGN cValMsg  = cFldName
           cFldName = SUBSTR(cFldName,1,32).

  ASSIGN ttMsSqlSchema.OEdataType  = cFldType
         ttMsSqlSchema.OEFieldName = cFldName
         ttMsSqlSchema.OEformat    = cFldFormat
         ttMsSqlSchema.OElabel     = cLabel
         ttMsSqlSchema.OEvalmsg    = cValMsg
         .
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

