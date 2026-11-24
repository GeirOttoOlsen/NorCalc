&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

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
&IF "{1}" = "Developer_Studio_is_Running" &THEN
  &SCOPED-DEFINE UIB_is_Running 1 
&ENDIF   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{tt_schema.i}
hdsSchema = DATASET dsSchema:HANDLE.

DEF TEMP-TABLE ttFields 
    FIELD hField     AS HANDLE
    FIELD hTbEncrypt AS HANDLE
    .

DEF VAR httDataSrc AS HANDLE NO-UNDO.

DEF VAR oToolbox AS oo.Toolbox NO-UNDO.
def var oEncryption as class JBoxCrypto no-undo.
DEF VAR lcFile       AS LONGCHAR NO-UNDO.

FIX-CODEPAGE(lcFile) = "utf-8".

{incl/devmode.i}
{incl/custdevmode.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnfiJsonFile btnSave fiJsonFile btnSaveAs ~
btnTestConnect 
&Scoped-Define DISPLAYED-OBJECTS fiJsonFile 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnfiJsonFile 
     IMAGE-UP FILE "bmp/folderopen.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON btnSave 
     LABEL "Save" 
     SIZE 15 BY 1.14 TOOLTIP "Save connection file".

DEFINE BUTTON btnSaveAs 
     LABEL "Save as" 
     SIZE 15 BY 1.14 TOOLTIP "Save as connection file".

DEFINE BUTTON btnTestConnect 
     LABEL "Test Connect" 
     SIZE 43 BY 1.14.

DEFINE VARIABLE fiJsonFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Connection file" 
     VIEW-AS FILL-IN 
     SIZE 87 BY 1 TOOLTIP "Template or existing connection file" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnfiJsonFile AT ROW 2.19 COL 108 WIDGET-ID 4 NO-TAB-STOP 
     btnSave AT ROW 2.1 COL 113.4 WIDGET-ID 10
     fiJsonFile AT ROW 2.19 COL 19 COLON-ALIGNED
     btnSaveAs AT ROW 3.29 COL 113.4 WIDGET-ID 12
     btnTestConnect AT ROW 17.19 COL 44 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 129.8 BY 19.62 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Data source definition"
         HEIGHT             = 19.62
         WIDTH              = 130
         MAX-HEIGHT         = 19.62
         MAX-WIDTH          = 142
         VIRTUAL-HEIGHT     = 19.62
         VIRTUAL-WIDTH      = 142
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Data source definition */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Data source definition */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnfiJsonFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnfiJsonFile C-Win
ON CHOOSE OF btnfiJsonFile IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  cUseFileName = fiJsonFile:SCREEN-VALUE.

  SYSTEM-DIALOG GET-FILE cUseFileName FILTERS "json" "*.json", "All files" "*.*" USE-FILENAME UPDATE bOk.
  IF bOk THEN DO:
    fiJsonFile:SCREEN-VALUE = cUseFileName.
    RUN ParseFile(cUseFileName).
  END.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSave C-Win
ON CHOOSE OF btnSave IN FRAME DEFAULT-FRAME /* Save */
DO:
  /*
  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR cUseDir      AS CHAR NO-UNDO.
  DEF VAR bReplace     AS LOG  NO-UNDO.
  DEF VAR bOK          AS LOG  NO-UNDO.

  FOR EACH ttFields:
    IF ttFields.hField:NAME = "SourceName" THEN
      cUseFileName = ttFields.hField:SCREEN-VALUE.
  END.
  IF cUseFileName NE "" THEN DO:
    SYSTEM-DIALOG GET-DIR cUseDir UPDATE bOk.
    IF bOk THEN
      cUseFileName = cUseDir + "\" + cUseFileName + ".json".
    ELSE RETURN NO-APPLY.
  END.   
  ELSE DO:
    MESSAGE "Replace" fiJsonFile:SCREEN-VALUE
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE bReplace.
    IF NOT bReplace THEN DO:
      SYSTEM-DIALOG GET-FILE  cUseFileName FILTERS "json" "*.json" USE-FILENAME UPDATE bOk.
      IF bOk THEN 
        fiJsonFile:SCREEN-VALUE = cUseFileName.
      ELSE RETURN NO-APPLY.    
    END.
  END.
  */
  RUN SaveFile(fiJsonFile:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSaveAs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSaveAs C-Win
ON CHOOSE OF btnSaveAs IN FRAME DEFAULT-FRAME /* Save as */
DO:
  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR cUseDir      AS CHAR NO-UNDO.
  DEF VAR bReplace     AS LOG  NO-UNDO.
  DEF VAR bOK          AS LOG  NO-UNDO.

  IF SEARCH(fiJsonFile:SCREEN-VALUE) = ? THEN 
    RUN SaveFile(fiJsonFile:SCREEN-VALUE).
  ELSE DO: 
    cUseFileName = fiJsonFile:SCREEN-VALUE. 
    SYSTEM-DIALOG GET-FILE cUseFileName FILTERS "json" "*.json" USE-FILENAME UPDATE bOk.
    IF bOk THEN DO: 
       fiJsonFile:SCREEN-VALUE = cUseFileName.
       RUN SaveFile(cUseFileName).
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnTestConnect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnTestConnect C-Win
ON CHOOSE OF btnTestConnect IN FRAME DEFAULT-FRAME /* Test Connect */
DO:
  DEF VAR hSourceName  AS HANDLE NO-UNDO.
  DEF VAR hSourceType  AS HANDLE NO-UNDO.
  DEF VAR hSourceDb    AS HANDLE NO-UNDO.
  
  FOR EACH ttFields:
    IF ttFields.hField:NAME = "SourceName" THEN 
      hSourceName = ttFields.hField.
    IF ttFields.hField:NAME = "SourceType" THEN 
      hSourceType = ttFields.hField.
    IF ttFields.hField:NAME = "SourceDb" THEN 
      hSourceDb = ttFields.hField.
  END.
  IF hSourceName = ? THEN DO:
    MESSAGE "Missing field SourceName"
            VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.     
  IF hSourceType = ? THEN DO:
    MESSAGE "Missing field SourceType"
            VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.     
  IF hSourceDb = ? THEN DO:
    MESSAGE "Missing field SourceDb"
            VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.     
    
  RUN SaveFile ("").
  
  IF JBoxSchemaCache:Instance:getIsDbConnected(hSourceName:SCREEN-VALUE,hSourceType:SCREEN-VALUE,hSourceDb:SCREEN-VALUE) THEN 
    MESSAGE "Datasource already connected"
    VIEW-AS ALERT-BOX.
  
  ELSE IF JBoxSchemaCache:Instance:getDbSchema(hdsSchema, STRING(lcFile)) THEN 
    MESSAGE "Connect OK and schema is cached and ready!" VIEW-AS ALERT-BOX.                                                                              
  ELSE
    MESSAGE "Failed to connect " hSourceName:SCREEN-VALUE
    VIEW-AS ALERT-BOX.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define SELF-NAME fiJsonFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiJsonFile C-Win
ON RETURN OF fiJsonFile IN FRAME DEFAULT-FRAME /* Connection file */
DO:
  IF SEARCH(fiJsonFile:SCREEN-VALUE) = ? THEN DO:
    MESSAGE "Not found: " + fiJsonFile:SCREEN-VALUE
    VIEW-AS ALERT-BOX.
    RETURN NO-APPLY.
  END.  
  RUN ParseFile (fiJsonFile:SCREEN-VALUE).  
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
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  oToolbox = NEW oo.Toolbox().
  oEncryption = new JBoxCrypto().
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
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
  DISPLAY fiJsonFile 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btnfiJsonFile btnSave fiJsonFile btnSaveAs btnTestConnect 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveOfFld C-Win 
PROCEDURE LeaveOfFld :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihFld AS HANDLE NO-UNDO.

DEF VAR cFile AS CHAR NO-UNDO.
DEF VAR cSrcName AS CHAR NO-UNDO.

IF ihFld:NAME = "SourceName" AND ihFld:MODIFIED THEN DO WITH FRAME {&FRAME-NAME}:
  cFile = fiJsonFile:SCREEN-VALUE.
  cSrcName = ENTRY(NUM-ENTRIES(cFile,"\/"),cFile,"\/").
  ENTRY(1,cSrcName,".") = ihFld:SCREEN-VALUE.
  ENTRY(NUM-ENTRIES(cFile,"\/"),cFile,"\/") = cSrcName.
  fiJsonFile:SCREEN-VALUE = cFile.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ParseFile C-Win 
PROCEDURE ParseFile :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icFileName AS CHAR NO-UNDO.

DEF VAR lcJson      AS LONGCHAR NO-UNDO.
DEF VAR oJboxParser AS JBoxJsonParser NO-UNDO.
DEF VAR ix          AS INT     NO-UNDO.
DEF VAR bOk         AS LOG     NO-UNDO.
DEF VAR hBuffer     AS HANDLE  NO-UNDO.
DEF VAR hLabel      AS HANDLE  NO-UNDO.
DEF VAR cFld        AS CHAR    NO-UNDO.
DEF VAR cScreenVal  AS CHAR    NO-UNDO.
DEF VAR mpEncrypt   AS MEMPTR NO-UNDO.
DEF VAR lcEncrypt   AS LONGCHAR NO-UNDO.
DEF VAR hFld        AS HANDLE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  
  FOR EACH ttFields:
    IF VALID-HANDLE(ttFields.hField) THEN DELETE OBJECT ttFields.hField.
    IF VALID-HANDLE(ttFields.hTbEncrypt) THEN DELETE OBJECT ttFields.hTbEncrypt.
    DELETE ttFields.
  END.  
    
  oJBoxParser = NEW JBoxJsonParser().

  FIX-CODEPAGE(lcJson) = "utf-8".
  
  COPY-LOB FROM FILE icFileName TO lcJson.
    
  oJboxParser:createSchema(lcJson, "jsonfields").

  IF oJboxParser:statusMessage NE "" THEN DO:
    MESSAGE oJboxParser:statusMessage
    VIEW-AS ALERT-BOX.
    RETURN.
  END.
  
  hBuffer = oJboxParser:hdsResult:GET-BUFFER-HANDLE (2).
  bOk = hBuffer:FIND-FIRST() NO-ERROR.
  IF bOk THEN DO:
    DO ix = 1 TO hBuffer:NUM-FIELDS.
      cFld = hBuffer:BUFFER-FIELD(ix):NAME.
      
      IF cFld MATCHES "*_encrypt" THEN DO:
        assign 
          cScreenVal = oEncryption:decryptString(hBuffer:BUFFER-FIELD(ix):BUFFER-VALUE)
          cFld = SUBSTR(cFld,1,R-INDEX(cFld,"_") - 1)
          .
  
      END.         
      ELSE cScreenVal = hBuffer:BUFFER-FIELD(ix):BUFFER-VALUE.
       
      IF hBuffer:BUFFER-FIELD(ix):NAME MATCHES "JBox*RowIdent" THEN NEXT.
      CREATE TEXT hLabel
      ASSIGN FRAME            = FRAME {&FRAME-NAME}:HANDLE
             FORMAT           = "x(30)"
             SCREEN-VALUE     = cFld + ":"
             X                = 10
             Y                = 20 + ix * 22
             WIDTH-PIXELS     = 130
             HEIGHT-PIXELS    = 20
             VISIBLE          = YES
             .
      CREATE ttFields.
      IF hBuffer:BUFFER-FIELD(ix):NAME = "SourceType" THEN DO:   
        CREATE COMBO-BOX hFld 
        ASSIGN DELIMITER        = "|"
               NAME             = cFld
               DATA-TYPE        = "CHARACTER"
               SUBTYPE          = "DROP-DOWN-LIST"
               INNER-LINES      = 50
               LIST-ITEM-PAIRS  = "MariaDb|MySql|MsSql|MsSql|MySql|MySql|ProgressApsv|ProgressApsv|ProgressDb|ProgressDb|ProgressSql|ProgressSql|Sql Explorer|SqlExp"
               FRAME            = FRAME {&FRAME-NAME}:HANDLE
               FORMAT           = "x(256)"
               X                = 100
               Y                = 20 + ix * 22
               WIDTH-PIXELS     = 450
               VISIBLE          = YES
               SENSITIVE        = TRUE
               TAB-STOP         = TRUE
               SIDE-LABEL-HANDLE = hLabel
/*               TRIGGERS:                                                                         */
/*                 ON "VALUE-CHANGED" PERSISTENT RUN setPwdFld IN THIS-PROCEDURE (ttFields.hField).*/
/*               END TRIGGERS.                                                                     */
               .
        hFld:SCREEN-VALUE = cScreenVal NO-ERROR.
      END.         
      ELSE
        CREATE FILL-IN hFld 
        ASSIGN FRAME            = FRAME {&FRAME-NAME}:HANDLE
               NAME             = cFld
               DATA-TYPE        = "CHARACTER"
               FORMAT           = "x(256)"
               X                = 100
               Y                = 20 + ix * 22
               WIDTH-PIXELS     = 450
               HEIGHT-PIXELS    = 20
               VISIBLE          = YES
               SENSITIVE        = TRUE
               TAB-STOP         = TRUE
               SIDE-LABEL-HANDLE = hLabel
               SCREEN-VALUE     = cScreenVal
               TRIGGERS:
                 ON "LEAVE" PERSISTENT RUN LeaveOfFld IN THIS-PROCEDURE (hFld).
               END TRIGGERS.
               .
               
      ttFields.hField = hFld.        
             
      IF hBuffer:BUFFER-FIELD(ix):BUFFER-VALUE = "<encrypt>" THEN 
        ttFields.hField:SCREEN-VALUE = "".
      IF NOT CAN-DO("SourceName,SourceType",hBuffer:BUFFER-FIELD(ix):NAME) THEN DO:  
        CREATE TOGGLE-BOX ttFields.hTbEncrypt 
        ASSIGN FRAME            = FRAME {&FRAME-NAME}:HANDLE
               NAME             = cFld + "_tgl"
               FORMAT           = "YES/NO"
               X                = 560
               Y                = 20 + ix * 22
               WIDTH-PIXELS     = 60
               HEIGHT-PIXELS    = 20
               VISIBLE          = YES
               SENSITIVE        = TRUE
               TAB-STOP         = NO
               LABEL            = "Encrypt"
               CHECKED          = hBuffer:BUFFER-FIELD(ix):BUFFER-VALUE = "<encrypt>" OR hBuffer:BUFFER-FIELD(ix):NAME MATCHES "*_encrypt"
               TRIGGERS:
                 ON "VALUE-CHANGED" PERSISTENT RUN setPwdFld IN THIS-PROCEDURE (ttFields.hField).
               END TRIGGERS.
               .
        ttFields.hField:PASSWORD-FIELD = ttFields.hTbEncrypt:CHECKED.
      END.            
    END.
  END.
/*  CREATE QUERY hQfields.                                                                */
/*  hQfields:SET-BUFFERS (oJboxParser:hdsResult:GET-BUFFER-HANDLE(1)).                    */
/*  hQfields:QUERY-PREPARE("FOR EACH " + oJboxParser:hdsResult:GET-BUFFER-HANDLE(1):NAME).*/
/*  hQfields:QUERY-OPEN ().                                                               */
/*  REPEAT WHILE hQfields:GET-NEXT():                                                     */
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveFile C-Win 
PROCEDURE SaveFile :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icFileName AS CHAR NO-UNDO.
DEF VAR mpEncrypt AS MEMPTR NO-UNDO.
DEF VAR lcEncrypt AS LONGCHAR NO-UNDO.

IF VALID-HANDLE(httDataSrc) THEN
  DELETE OBJECT httDataSrc.

CREATE TEMP-TABLE httDataSrc.

FIX-CODEPAGE(lcEncrypt) = "utf-8".

FOR EACH ttFields:
  IF NOT ttFields.hField:NAME MATCHES "*_encrypt" AND VALID-HANDLE(ttFields.hTbEncrypt) AND ttFields.hTbEncrypt:CHECKED THEN  
    httDataSrc:ADD-NEW-FIELD (ttFields.hField:NAME + "_encrypt","character").
  ELSE IF ttFields.hField:NAME MATCHES "*_encrypt" AND VALID-HANDLE(ttFields.hTbEncrypt) AND NOT ttFields.hTbEncrypt:CHECKED THEN  
    httDataSrc:ADD-NEW-FIELD (SUBSTR(ttFields.hField:NAME,1,R-INDEX(ttFields.hField:NAME,"_") - 1),"CHARACTER").
  ELSE  
    httDataSrc:ADD-NEW-FIELD (ttFields.hField:NAME,"CHARACTER").
END.
httDataSrc:TEMP-TABLE-PREPARE ("JBoxDataSource").

httDataSrc:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE ().
FOR EACH ttFields:
  IF VALID-HANDLE(ttFields.hTbEncrypt) AND ttFields.hTbEncrypt:CHECKED THEN DO:    
    httDataSrc:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ttFields.hField:NAME + "_encrypt"):BUFFER-VALUE = oEncryption:encryptString(ttFields.hField:SCREEN-VALUE).
  END.    
  ELSE DO: 
    httDataSrc:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ttFields.hField:NAME):BUFFER-VALUE = ttFields.hField:SCREEN-VALUE.
    IF ttFields.hField:NAME = "SourcePwd" AND ttFields.hField:SCREEN-VALUE = "" THEN httDataSrc:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ttFields.hField:NAME):BUFFER-VALUE = "<blank>". 
  END.  
END.

IF icFileName NE "" THEN
  httDataSrc:WRITE-JSON ("file",icFileName,YES).
ELSE  
  httDataSrc:WRITE-JSON ("longchar",lcFile,YES).

//OS-COMMAND NO-WAIT VALUE("notepad " + icFileName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPwdFld C-Win 
PROCEDURE setPwdFld :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihFld AS HANDLE NO-UNDO.

DEF VAR bClear AS LOG NO-UNDO INIT YES.

IF NOT SELF:CHECKED AND ihFld:SCREEN-VALUE NE "" THEN DO:
  MESSAGE "Clear field..?"
  VIEW-AS ALERT-BOX BUTTONS YES-NO-CANCEL UPDATE bClear.
  IF bClear THEN ihFld:SCREEN-VALUE = "".
  ELSE IF bClear = ? THEN DO:
    SELF:CHECKED = YES.
    RETURN.
  END.  
END.

ihFld:PASSWORD-FIELD = SELF:CHECKED.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

