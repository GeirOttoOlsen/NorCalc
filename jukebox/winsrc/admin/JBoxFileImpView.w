&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          sports12         PROGRESS
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
/* &SCOPED-DEFINE AdvGuiWin */ 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO. /* placeholder */
DEF VAR oContainer  AS JBoxContainer NO-UNDO.

DEF VAR cMenuCatParam AS CHAR NO-UNDO.
DEF VAR cTargetDb     AS CHAR NO-UNDO.

/* Code for Definitions: */

/*** Start instance property definitions for JBoxQuery object oQryJBoxFileImportHeader ***/
DEF VAR oQryJBoxFileImportHeader AS JBoxQuery NO-UNDO.

DEF TEMP-TABLE JBoxFileImportHeader
    FIELD bAllowRecordDeleteFromImportLog AS logical
    FIELD bIgnoreDuplicates AS logical
    FIELD bLogFilesInDB AS logical
    FIELD cComment AS character
    FIELD cCreatedBy AS character
    FIELD cDataSourceCatalog AS character
    FIELD cDelimiter AS character
    FIELD cDescription AS character
    FIELD cImportProg AS character
    FIELD cImportType AS character
    FIELD cMenuCategory AS character
    FIELD cModifiedBy AS character
    FIELD cMoveImportedFilesTo AS character
    FIELD cRunTimeParameterList AS character
    FIELD cTargetDBtable AS character
    FIELD dCreated AS date
    FIELD dModified AS date
    FIELD iHeaderLines AS integer
    FIELD iJBoxCompanyId AS integer
    FIELD iJBoxFileImportHeaderId AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    INDEX idxRowids  RowIdent1
    .
DEFINE BUFFER v_JBoxFileImportHeader FOR TEMP-TABLE JBoxFileImportHeader.

FUNCTION getTableHandleQryJBoxFileImportHeader RETURNS HANDLE().
  RETURN BUFFER JBoxFileImportHeader:HANDLE:TABLE-HANDLE.
END FUNCTION.
FUNCTION getBuffersAndFieldsQryJBoxFileImportHeader RETURNS CHARACTER().
  RETURN 
      'JBoxFileImportHeader'.
END FUNCTION.
FUNCTION getQueryJoinQryJBoxFileImportHeader RETURNS CHARACTER().
  RETURN ''.
END FUNCTION.
/*** End instance property settings for JBoxQuery object oQryJBoxFileImportHeader ***/

DEF VAR oFmFileImpHeader AS JBoxFieldMap NO-UNDO.
DEF VAR otbFileImpHeadere AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define QUERY-NAME QUERY-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES JBoxFileImportHeader

/* Definitions for QUERY QUERY-2                                        */
&Scoped-define QUERY-STRING-QUERY-2 FOR EACH JBoxFileImportHeader NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-QUERY-2 OPEN QUERY QUERY-2 FOR EACH JBoxFileImportHeader NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-QUERY-2 JBoxFileImportHeader
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-2 JBoxFileImportHeader


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btncDataSourceCatalog tbFileImpHeadere ~
btncMoveImportedFilesTo new_tbFileImpHeadere edit_tbFileImpHeadere ~
undo_tbFileImpHeadere save_tbFileImpHeadere delete_tbFileImpHeadere ~
activate_tbFileImpHeadere cDescription cImportType cDelimiter iHeaderLines ~
cImportProg cRunTimeParameterList cTargetDBtable bIgnoreDuplicates ~
cDataSourceCatalog cMoveImportedFilesTo bLogFilesInDB ~
bAllowRecordDeleteFromImportLog cComment fiCommentLabel 
&Scoped-Define DISPLAYED-OBJECTS cDescription cImportType cDelimiter ~
iHeaderLines cImportProg cRunTimeParameterList cTargetDBtable ~
bIgnoreDuplicates cDataSourceCatalog cMoveImportedFilesTo bLogFilesInDB ~
bAllowRecordDeleteFromImportLog cComment fiCommentLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD DoMyPublish C-Win 
FUNCTION DoMyPublish RETURNS LOGICAL()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON activate_tbFileImpHeadere 
     IMAGE-UP FILE "gif/active.gif":U
     LABEL "Activate" 
     SIZE 4.6 BY 1.1 TOOLTIP "Activate (ALT-A)".

DEFINE BUTTON btncDataSourceCatalog 
     IMAGE-UP FILE "bmp/folderopen.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON btncMoveImportedFilesTo 
     IMAGE-UP FILE "bmp/folderopen.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON delete_tbFileImpHeadere 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 4.6 BY 1.1 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON edit_tbFileImpHeadere 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 4.6 BY 1.1 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON new_tbFileImpHeadere 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 4.6 BY 1.1 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON save_tbFileImpHeadere 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 4.6 BY 1.1 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbFileImpHeadere 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Angre" 
     SIZE 4.6 BY 1.1 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE cImportType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Import type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "FLAT FILE","JSON" 
     DROP-DOWN-LIST
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE cTargetDBtable AS CHARACTER FORMAT "X(256)":U 
     LABEL "Import to db-table" 
     VIEW-AS COMBO-BOX INNER-LINES 50
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 43.2 BY 1 NO-UNDO.

DEFINE VARIABLE cComment AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 54.8 BY 2.24.

DEFINE VARIABLE cDataSourceCatalog AS CHARACTER FORMAT "x(256)" 
     LABEL "Data source catalog" 
     VIEW-AS FILL-IN 
     SIZE 50.2 BY 1.

DEFINE VARIABLE cDelimiter AS CHARACTER FORMAT "x(6)" 
     LABEL "Delimiter" 
     VIEW-AS FILL-IN 
     SIZE 11.6 BY 1.

DEFINE VARIABLE cDescription AS CHARACTER FORMAT "x(50)" 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1.

DEFINE VARIABLE cImportProg AS CHARACTER FORMAT "x(40)" 
     LABEL "Import program" 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1.

DEFINE VARIABLE cMoveImportedFilesTo AS CHARACTER FORMAT "x(256)" 
     LABEL "Move files to" 
     VIEW-AS FILL-IN 
     SIZE 50.2 BY 1.

DEFINE VARIABLE cRunTimeParameterList AS CHARACTER FORMAT "x(60)" 
     LABEL "Runtime parameters" 
     VIEW-AS FILL-IN 
     SIZE 43.2 BY 1.

DEFINE VARIABLE fiCommentLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Comment:" 
      VIEW-AS TEXT 
     SIZE 10 BY .62 NO-UNDO.

DEFINE VARIABLE iHeaderLines AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Header lines" 
     VIEW-AS FILL-IN 
     SIZE 6.2 BY 1.

DEFINE RECTANGLE tbFileImpHeadere
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 78.4 BY 1.29.

DEFINE VARIABLE bAllowRecordDeleteFromImportLog AS LOGICAL INITIAL no 
     LABEL "Allow record delete when deleting import log row" 
     VIEW-AS TOGGLE-BOX
     SIZE 50.4 BY 1 TOOLTIP "Allow record delete when deleting import log row".

DEFINE VARIABLE bIgnoreDuplicates AS LOGICAL INITIAL no 
     LABEL "Ignore duplicates" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .81 NO-UNDO.

DEFINE VARIABLE bLogFilesInDB AS LOGICAL INITIAL no 
     LABEL "Log source files in database" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.4 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY QUERY-2 FOR 
      JBoxFileImportHeader SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btncDataSourceCatalog AT ROW 10.1 COL 73 WIDGET-ID 90 NO-TAB-STOP 
     btncMoveImportedFilesTo AT ROW 11.19 COL 72.8 WIDGET-ID 92 NO-TAB-STOP 
     new_tbFileImpHeadere AT ROW 1.29 COL 1.8 WIDGET-ID 78
     edit_tbFileImpHeadere AT ROW 1.29 COL 6.4 WIDGET-ID 80
     undo_tbFileImpHeadere AT ROW 1.29 COL 11.2 WIDGET-ID 82
     save_tbFileImpHeadere AT ROW 1.29 COL 15.8 WIDGET-ID 84
     delete_tbFileImpHeadere AT ROW 1.29 COL 20.6 WIDGET-ID 86
     activate_tbFileImpHeadere AT ROW 1.29 COL 25.2 WIDGET-ID 88
     cDescription AT ROW 2.71 COL 20.8 COLON-ALIGNED
     cImportType AT ROW 3.76 COL 20.8 COLON-ALIGNED WIDGET-ID 62
     cDelimiter AT ROW 4.81 COL 20.6 COLON-ALIGNED
     iHeaderLines AT ROW 4.81 COL 57.6 COLON-ALIGNED
     cImportProg AT ROW 5.86 COL 20.6 COLON-ALIGNED
     cRunTimeParameterList AT ROW 6.91 COL 2.6 HELP
          "Comma-sep. list of params for runtime selection or program-name"
     cTargetDBtable AT ROW 8 COL 20.6 COLON-ALIGNED WIDGET-ID 68
     bIgnoreDuplicates AT ROW 9.14 COL 22.6 WIDGET-ID 44
     cDataSourceCatalog AT ROW 10.1 COL 2.2
     cMoveImportedFilesTo AT ROW 11.19 COL 9.4
     bLogFilesInDB AT ROW 12.43 COL 22.4 WIDGET-ID 46
     bAllowRecordDeleteFromImportLog AT ROW 13.24 COL 22.4 WIDGET-ID 42
     cComment AT ROW 14.24 COL 22.4 NO-LABEL WIDGET-ID 52
     fiCommentLabel AT ROW 14.33 COL 10 COLON-ALIGNED NO-LABEL
     tbFileImpHeadere AT ROW 1.19 COL 1.6 WIDGET-ID 76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 15.67 WIDGET-ID 100.


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
         HEIGHT             = 15.71
         WIDTH              = 80
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
/* SETTINGS FOR FILL-IN cDataSourceCatalog IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cMoveImportedFilesTo IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN cRunTimeParameterList IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       tbFileImpHeadere:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,edit;Edit,undo;Angre,save;Lagre,delete;Slett,activate;Activatemaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-2
/* Query rebuild information for QUERY QUERY-2
     _TblList          = "Sports12.JBoxFileImportHeader"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is FRAME DEFAULT-FRAME @ ( 3.71 , 73.8 )
*/  /* QUERY QUERY-2 */
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


&Scoped-define SELF-NAME btncDataSourceCatalog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btncDataSourceCatalog C-Win
ON CHOOSE OF btncDataSourceCatalog IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEF VAR cOutputCat    AS CHAR NO-UNDO.
  SYSTEM-DIALOG GET-DIR cOutputCat RETURN-TO-START-DIR.
  IF cOutputCat NE "" THEN DO:
    cDataSourceCatalog:SCREEN-VALUE = cOutputCat.
    APPLY "any-printable" TO cDataSourceCatalog.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btncMoveImportedFilesTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btncMoveImportedFilesTo C-Win
ON CHOOSE OF btncMoveImportedFilesTo IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEF VAR cOutputCat    AS CHAR NO-UNDO.
  SYSTEM-DIALOG GET-DIR cOutputCat RETURN-TO-START-DIR.
  IF cOutputCat NE "" THEN DO:
    cMoveImportedFilesTo:SCREEN-VALUE = cOutputCat.
    APPLY "any-printable" TO cMoveImportedFilesTo.
  END.
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
DEF VAR cFileNames      AS CHAR NO-UNDO.
DEF VAR cTmpFileName    AS CHAR NO-UNDO.
DEF VAR ocReturn        AS CHAR NO-UNDO.
DEF VAR cImportFiles    AS CHAR NO-UNDO.
DEF VAR cConvFile       AS CHAR NO-UNDO.
DEF VAR cParam          AS CHAR NO-UNDO.
DEF VAR cTmp            AS CHAR NO-UNDO.
DEF VAR cParamField     AS CHAR NO-UNDO.
DEF VAR cParamProg      AS CHAR NO-UNDO.
DEF VAR cParamTargetFld AS CHAR NO-UNDO. 
DEF VAR bTest           AS LOG  NO-UNDO.
DEF VAR ix              AS INT  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  IF cDataSourceCatalog:SCREEN-VALUE = "" THEN DO:
    cFileNames = DYNAMIC-FUNCTION("SelectFileNames","Alle filer|*.*",?,"Velg fil(er) for opplasting").
    IF cFileNames = "" THEN RETURN.
    DO ix = 1 TO NUM-ENTRIES(cFileNames,";"):
      cTmpFileName = ENTRY(ix,cFileNames,";").
      IF cTmpFileName MATCHES "*.xls*" THEN
         cConvFile = DYNAMIC-FUNCTION("ConvXlsToCsv",cTmpFileName).
      ELSE cConvFile = cTmpFileName.
      cImportFiles = cImportFiles + cConvFile + ";".
    END.
  END.
  ELSE DO:
    INPUT FROM OS-DIR(cDataSourceCatalog:SCREEN-VALUE) NO-ECHO.
    REPEAT:
      IMPORT cTmpFileName. 
      FILE-INFO:FILE-NAME = RIGHT-TRIM(cDataSourceCatalog:SCREEN-VALUE,"\") + "\" + cTmpFileName.
      IF FILE-INFO:FILE-TYPE NE "FRW" THEN NEXT.

      IF cTmpFileName MATCHES "*.xls*" THEN
         cConvFile = DYNAMIC-FUNCTION("ConvXlsToCsv",FILE-INFO:FULL-PATHNAME).
      ELSE cConvFile = FILE-INFO:FULL-PATHNAME.

      ASSIGN cFileNames   = cFileNames + FILE-INFO:FULL-PATHNAME + ";"
             cImportFiles = cImportFiles + cConvFile + ";".
    END.
    INPUT CLOSE.
  END.
  IF JBoxFileImportHeader.cRunTimeParameterList NE "" THEN DO:
    ASSIGN cParamField = JBoxFileImportHeader.cRunTimeParameterList
           cParamProg  = ENTRY(1,cParamField).
    IF SEARCH(cParamProg) NE ? OR
       SEARCH(SUBSTR(cParamProg,1,LENGTH(cParamProg) - 2) + ".r") NE ?  THEN DO:
      IF NUM-ENTRIES(cParamField) > 1 THEN
        cParamField = SUBSTR(cParamField,INDEX(cParamField,",") + 1).
      ELSE cParamField = "".
      RUN VALUE(cParamProg) (cParamField,OUTPUT cParam).     
    END.
    ELSE DO:
      IF NUM-ENTRIES(cParamField,";") > 1 THEN
        ASSIGN cParamTargetFld = ENTRY(1,cParamField,";")
               cParamField     = ENTRY(2,cParamField,";")
               .
      DO ix = 1 TO NUM-ENTRIES(cParamField):
        cTmp = cTmp + (IF cTmp NE "" THEN "|" ELSE "") 
             + ENTRY(ix,cParamField) + "|"
             + ENTRY(ix,cParamField).
      END.
      RUN JBoxDSimpleSelectList.w (cTmp,?,OUTPUT cParam).
    END.  
    IF cParam = ? THEN RETURN.
  END.
  IF cParamTargetFld NE "" THEN
    cParam = cParamTargetFld + ";" + cParam.

  IF DYNAMIC-FUNCTION("DoMessage",0,4,"Run as test (no database update)","","") = 6 THEN DO:
    bTest = YES.  
    DYNAMIC-FUNCTION("setDocLoadParam",cParam + "|test").
  END.
  ELSE IF cParam NE "" THEN
    DYNAMIC-FUNCTION("setDocLoadParam",cParam).

  ASSIGN cFileNames = TRIM(cFileNames,";")
         cImportFiles = TRIM(cImportFiles,";").
  DYNAMIC-FUNCTION("setFileCompression",NO).
  IF NOT DYNAMIC-FUNCTION("LoadDocs"
                   ,cImportFiles
                   ,"JBoxFileImportHeader"
                   ,STRING(JBoxFileImportHeader.iJBoxFileImportHeaderId)
                   ,"") THEN
    DYNAMIC-FUNCTION("DoMessage",0,0,DYNAMIC-FUNCTION("getOutParam"),"","").
  ELSE IF cMoveImportedFilesTo:SCREEN-VALUE NE "" AND NOT bTest THEN DO:
    RUN jbutil_movefiles.p (cFileNames,cMoveImportedFilesTo:SCREEN-VALUE,OUTPUT ocReturn).
    IF ocReturn NE "" THEN
      DYNAMIC-FUNCTION("DoMessage",0,0,ocReturn,"","").
  END.
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
  DISPLAY cDescription cImportType cDelimiter iHeaderLines cImportProg 
          cRunTimeParameterList cTargetDBtable bIgnoreDuplicates 
          cDataSourceCatalog cMoveImportedFilesTo bLogFilesInDB 
          bAllowRecordDeleteFromImportLog cComment fiCommentLabel 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btncDataSourceCatalog tbFileImpHeadere btncMoveImportedFilesTo 
         new_tbFileImpHeadere edit_tbFileImpHeadere undo_tbFileImpHeadere 
         save_tbFileImpHeadere delete_tbFileImpHeadere 
         activate_tbFileImpHeadere cDescription cImportType cDelimiter 
         iHeaderLines cImportProg cRunTimeParameterList cTargetDBtable 
         bIgnoreDuplicates cDataSourceCatalog cMoveImportedFilesTo 
         bLogFilesInDB bAllowRecordDeleteFromImportLog cComment fiCommentLabel 
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
  cMenuCatParam = DYNAMIC-FUNCTION("getMenuCatParameter" IN oContainer:PARENT-CONTAINER-OBJECT:CONTAINER-HANDLE) NO-ERROR.

  cTargetDb = (IF cMenuCatParam BEGINS "db_" THEN SUBSTR(cMenuCatParam,4) + "." ELSE "").

  ASSIGN cTargetDBtable:DELIMITER = "|"
         cTargetDBtable:LIST-ITEM-PAIRS = "||" + DYNAMIC-FUNCTION("getFieldList",cTargetDb
                                                                 + "_file;_file-name;_file-name",
                                                                  "WHERE NOT _file-name BEGINS 'JBox' AND _tbl-type = 'T'")
         .

  oQryJBoxFileImportHeader = NEW JBoxQuery('JBoxFileImportHeader').

  oFmFileImpHeader = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmFileImpHeader:updateFields = 'cDescription,bAllowRecordDeleteFromImportLog,bIgnoreDuplicates,bLogFilesInDB,cComment,cDataSourceCatalog,cDelimiter,cImportProg,cImportType,cMoveImportedFilesTo,cRunTimeParameterList,cTargetDBtable,iHeaderLines'.
//  oFmFileImpHeader:primaryKeyFields = 'iJBoxFileImportHeaderId'.

//,iJBoxCompanyId,iJBoxFileImportHeaderId

  oFmFileImpHeader:QUERY-OBJECT = oQryJBoxFileImportHeader.
  otbFileImpHeadere = NEW JBoxToolbar(tbFileImpHeadere:HANDLE).

  oQryJBoxFileImportHeader:TOOLBAR-OBJECT = otbFileImpHeadere.
  oFmFileImpHeader:TOOLBAR-OBJECT = otbFileImpHeadere.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN
//  oContainer:setNoResizeX("cComment").  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
DO WITH FRAME {&FRAME-NAME}:
    IF otbFileImpHeadere:isCurrent THEN DO:
      IF otbFileImpHeadere:objectState = "new" THEN
        ASSIGN oFmFileImpHeader:bufferExtraFields = "iJBoxCompanyId,cMenuCategory"
               oFmFileImpHeader:bufferExtraValues = STRING(JBoxSession:Instance:CompanyId) + "|" + cMenuCatParam
               .
      ELSE
        ASSIGN oFmFileImpHeader:bufferExtraFields = "cMenuCategory"
               oFmFileImpHeader:bufferExtraValues = cMenuCatParam
               .
    END.
  END.
  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION DoMyPublish C-Win 
FUNCTION DoMyPublish RETURNS LOGICAL() :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  PUBLISH "FileImportToTable" (cTargetDb,cTargetDBtable:HANDLE:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

