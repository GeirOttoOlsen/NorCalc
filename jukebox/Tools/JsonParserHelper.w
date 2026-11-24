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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR oJboxParser AS JBoxJsonParser NO-UNDO.
DEF VAR cSchemaName AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnfiJsonFile fiJsonFile fiParserMsg ~
fiPrefix btnGenerateDS btnGenerateABL 
&Scoped-Define DISPLAYED-OBJECTS fiJsonFile fiParserMsg fiPrefix 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CheckXML C-Win 
FUNCTION CheckXML RETURNS LONGCHAR
  ( INPUT ilcFile AS LONGCHAR, INPUT icFilename AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setButtons C-Win 
FUNCTION setButtons RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_Set_parser_logfile LABEL "Set parser logfile"
       MENU-ITEM m_View_parser_logfile LABEL "View parser logfile"
       MENU-ITEM m_Rename_array LABEL "Rename array"  .

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_File         LABEL "File"          .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnfiJsonFile  NO-FOCUS
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON btnGenerateABL 
     LABEL "Generate 4GL code" 
     SIZE 36 BY 1.14 TOOLTIP "Generate 4GL code to consume json".

DEFINE BUTTON btnGenerateDS 
     LABEL "Generate Dataset definition" 
     SIZE 36 BY 1.14.

DEFINE VARIABLE fiJsonFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Json or XML file" 
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE fiParserMsg AS CHARACTER FORMAT "X(256)":U 
     LABEL "Parser msg" 
     VIEW-AS FILL-IN 
     SIZE 58 BY 1 NO-UNDO.

DEFINE VARIABLE fiPrefix AS CHARACTER FORMAT "X(8)":U 
     LABEL "Table name prefix" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "Useful for api-definitions where tables might be part of different datasets" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnfiJsonFile AT ROW 2.19 COL 76.2 WIDGET-ID 4 NO-TAB-STOP 
     fiJsonFile AT ROW 2.19 COL 16 COLON-ALIGNED
     fiParserMsg AT ROW 3.38 COL 16 COLON-ALIGNED
     fiPrefix AT ROW 4.62 COL 34.6 COLON-ALIGNED WIDGET-ID 10
     btnGenerateDS AT ROW 5.95 COL 25 WIDGET-ID 6
     btnGenerateABL AT ROW 7.29 COL 25.2 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 80 BY 7.62 WIDGET-ID 100.


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
         TITLE              = "JukeBox Json and XML parser helper"
         HEIGHT             = 7.62
         WIDTH              = 80
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.
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
ON END-ERROR OF C-Win /* JukeBox Json and XML parser helper */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* JukeBox Json and XML parser helper */
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

  SYSTEM-DIALOG GET-FILE cUseFileName USE-FILENAME UPDATE bOk.
  IF bOk THEN DO:
    fiJsonFile:SCREEN-VALUE = cUseFileName.
    RUN ParseFile (cUseFileName).
  END.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGenerateABL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGenerateABL C-Win
ON CHOOSE OF btnGenerateABL IN FRAME DEFAULT-FRAME /* Generate 4GL code */
DO:
  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  cUseFileName = cSchemaName + ".p".

  SYSTEM-DIALOG GET-FILE cUseFileName 
         FILTERS "Source Files (*.p)"   "*.p"
         USE-FILENAME UPDATE bOk.

  IF bOk THEN DO:
    OUTPUT TO VALUE(cUseFileName).
         
    PUT UNFORMATTED "/******** Paste DS definition here: */" SKIP(3).
    
    PUT UNFORMATTED "/******** start code: */" SKIP(3).

    PUT UNFORMATTED "DEF VAR oJboxParser AS JBoxJsonParser NO-UNDO." SKIP.
    PUT UNFORMATTED "DEF VAR httView     AS HANDLE NO-UNDO." SKIP.
    PUT UNFORMATTED "DEF VAR hQuery      AS HANDLE NO-UNDO." SKIP(1).

    IF fiJsonFile:SCREEN-VALUE MATCHES "*.xml" THEN DO:
      PUT UNFORMATTED "DEF VAR cXmlFile    AS CHAR NO-UNDO." SKIP.
      PUT UNFORMATTED "DEF VAR lcXML       AS LONGCHAR NO-UNDO." SKIP(1).
      
      PUT UNFORMATTED 'FIX-CODEPAGE(lcXML) = "UTF-8".' SKIP(1).
      
      PUT UNFORMATTED "oJboxParser = NEW JBoxJsonParser()." SKIP(1).
      
      PUT UNFORMATTED "oJboxParser:LoadPredefinedDS(DATASET " + fiPrefix:SCREEN-VALUE + oJBoxParser:hdsResult:GET-BUFFER-HANDLE(1):NAME + ":HANDLE)." SKIP(1).

      PUT UNFORMATTED "/******** View template - create: (add primary index to table def to control FIRST/LAST) " SKIP(1).
      PUT UNFORMATTED "httView = oJBoxParser:createView('<table>'" SKIP.
      PUT UNFORMATTED "                                + ';<field>'" SKIP.
      PUT UNFORMATTED "                                + ';<field>'" SKIP.
      PUT UNFORMATTED "                                + ';+MyExtraField|CHARACTER|x(30)" + "'" SKIP.
      PUT UNFORMATTED "                              + ',[FIRST | LAST] <child table> [OUTER-JOIN]'" SKIP.
      PUT UNFORMATTED "                                + ';<field>'" SKIP.
      PUT UNFORMATTED "                                )." SKIP(1).
      PUT UNFORMATTED "********/" SKIP(1).
      
      PUT UNFORMATTED "cXMLFile = '" + fiJsonFile:SCREEN-VALUE + "'." SKIP.
      PUT UNFORMATTED "COPY-LOB FROM FILE cXMLFile TO lcXML." SKIP(1).
      PUT UNFORMATTED "/** For unformatted XML you might need to something like this:" SKIP(1).
      PUT UNFORMATTED "DEF VAR doc AS System.Xml.XmlDocument NO-UNDO." SKIP.
      PUT UNFORMATTED "doc = new System.Xml.XmlDocument()." SKIP.
      PUT UNFORMATTED "DO ON ERROR UNDO, LEAVE:" SKIP.
      PUT UNFORMATTED "  doc:LoadXml(lcXml)." SKIP.
      PUT UNFORMATTED "  CATCH ex AS System.Xml.XmlException:" SKIP.
      PUT UNFORMATTED "    doc:Load('" + fiJsonFile:SCREEN-VALUE + "')." SKIP.
      PUT UNFORMATTED "  END CATCH." SKIP. 
      PUT UNFORMATTED "END." SKIP.
      PUT UNFORMATTED "lcXml = System.Xml.Linq.XElement:Parse(doc:OuterXml):ToString()." SKIP(1).
      PUT UNFORMATTED "********/" SKIP(1).
      PUT UNFORMATTED "oJboxParser:appendXMLData(lcXML)." SKIP(1).
    END.
    ELSE DO:  
      PUT UNFORMATTED "DEF VAR cJsonFile   AS CHAR NO-UNDO." SKIP.
      PUT UNFORMATTED "DEF VAR lcJson      AS LONGCHAR NO-UNDO." SKIP(1).
      
      PUT UNFORMATTED 'FIX-CODEPAGE(lcJson) = "UTF-8".' SKIP(1).
      
      PUT UNFORMATTED "oJboxParser = NEW JBoxJsonParser()." SKIP(1).
      
      PUT UNFORMATTED "oJboxParser:LoadPredefinedDS(DATASET " + fiPrefix:SCREEN-VALUE + oJBoxParser:hdsResult:GET-BUFFER-HANDLE(1):NAME + ":HANDLE)." SKIP(1).

      PUT UNFORMATTED "/******** View template - create: (add primary index to table def to control FIRST/LAST) " SKIP(1).
      PUT UNFORMATTED "httView = oJBoxParser:createView('<table>'" SKIP.
      PUT UNFORMATTED "                                + ';<field>'" SKIP.
      PUT UNFORMATTED "                                + ';<field>'" SKIP.
      PUT UNFORMATTED "                                + ';+MyExtraField|CHARACTER|x(30)" + "'" SKIP.
      PUT UNFORMATTED "                              + ',[FIRST | LAST] <child table> [OUTER-JOIN]'" SKIP.
      PUT UNFORMATTED "                                + ';<field>'" SKIP.
      PUT UNFORMATTED "                                )." SKIP(1).
      PUT UNFORMATTED "********/" SKIP(1).
      
      PUT UNFORMATTED "cJsonFile = '" + fiJsonFile:SCREEN-VALUE + "'." SKIP.
      PUT UNFORMATTED "COPY-LOB FROM FILE cJsonFile TO lcJson." SKIP(1).
      PUT UNFORMATTED "oJboxParser:appendData(lcJson)." SKIP(1).
    END.
    
    PUT UNFORMATTED "/******** View template - fill: " SKIP(1).
    PUT UNFORMATTED "IF NOT oJboxParser:fillView(httView,NO) THEN // httView could also be the buffer handle. NO: Replace data" SKIP.
    PUT UNFORMATTED "  MESSAGE oJboxParser:statusMessage VIEW-AS ALERT-BOX." SKIP.
    PUT UNFORMATTED "CREATE QUERY hQuery." SKIP.
    PUT UNFORMATTED "hQuery:SET-BUFFERS(httView:DEFAULT-BUFFER-HANDLE)." SKIP.
    PUT UNFORMATTED "hQuery:QUERY-PREPARE('FOR EACH ' + httView:DEFAULT-BUFFER-HANDLE:NAME)." SKIP.
    PUT UNFORMATTED "hQuery:QUERY-OPEN()." SKIP.
    PUT UNFORMATTED "REPEAT WHILE hQuery:GET-NEXT():" SKIP.
    PUT UNFORMATTED "  MESSAGE httView:DEFAULT-BUFFER-HANDLE::<field> VIEW-AS ALERT-BOX." SKIP.
    PUT UNFORMATTED "END." SKIP.
    PUT UNFORMATTED "DELETE OBJECT hQuery." SKIP.
    PUT UNFORMATTED "********/" SKIP(1).
    
    PUT UNFORMATTED "/******** FOR EACH template: */" SKIP(1).
    PUT UNFORMATTED oJBoxParser:getForEach(fiPrefix:SCREEN-VALUE) SKIP.
    OUTPUT CLOSE.
    OS-COMMAND NO-WAIT VALUE("notepad " + cUseFileName).    
  END.    
           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGenerateDS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGenerateDS C-Win
ON CHOOSE OF btnGenerateDS IN FRAME DEFAULT-FRAME /* Generate Dataset definition */
DO:
  oJBoxParser:saveSchemaAs4GL("",YES,fiPrefix:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiJsonFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiJsonFile C-Win
ON RETURN OF fiJsonFile IN FRAME DEFAULT-FRAME /* Json or XML file */
DO:
  RUN ParseFile (fiJsonFile:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Rename_array
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Rename_array C-Win
ON CHOOSE OF MENU-ITEM m_Rename_array /* Rename array */
DO:
/*  DEF VAR cFrom AS CHAR NO-UNDO.   */
/*  DEF VAR cTo   AS CHAR NO-UNDO.*/
/*                                                  */
/*  oJboxParser:renameArray(cFrom,cTo).             */
  MESSAGE "not implemented.."
  VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Set_parser_logfile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Set_parser_logfile C-Win
ON CHOOSE OF MENU-ITEM m_Set_parser_logfile /* Set parser logfile */
DO:
  DEF VAR cFileName AS CHAR     NO-UNDO.
  DEF VAR bOk       AS LOG      NO-UNDO.
  
  cFileName = oJboxParser:logFile. 
  
  SYSTEM-DIALOG GET-FILE cFileName
                FILTERS "Log files" "*.log", "Text files" "*.txt" 
                INITIAL-FILTER 1 
                INITIAL-DIR "c:\temp"
                UPDATE bOk.
  IF bOk THEN 
    oJboxParser:logFile = cFileName. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_View_parser_logfile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_View_parser_logfile C-Win
ON CHOOSE OF MENU-ITEM m_View_parser_logfile /* View parser logfile */
DO:
  oJboxParser:viewLogFile(). 
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
  setButtons().
  oJboxParser = NEW JBoxJsonParser().
  
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
  DISPLAY fiJsonFile fiParserMsg fiPrefix 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btnfiJsonFile fiJsonFile fiParserMsg fiPrefix btnGenerateDS 
         btnGenerateABL 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
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

DEF VAR lcJson  AS LONGCHAR NO-UNDO.
DEF VAR bOk     AS LOG      NO-UNDO.

FIX-CODEPAGE(lcJson) = "UTF-8".

cSchemaName = REPLACE(ENTRY(1,ENTRY(NUM-ENTRIES(icFileName,"\/"),icFileName,"\/"),".")," ","").

COPY-LOB FROM FILE icFileName TO lcJson.

IF icFileName MATCHES "*.xml" THEN
  bOk = oJboxParser:createXMLSchema(CheckXml(lcJson,icFileName),cSchemaName). 
ELSE
  bOk = oJboxParser:createSchema(lcJson,cSchemaName).
  
IF bOk THEN
  fiParserMsg:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "OK!".
ELSE DO:
  fiParserMsg:SCREEN-VALUE = oJboxParser:statusMessage.
  IF oJboxParser:logFile NE "" THEN oJboxParser:viewLogFile().
END.  

setButtons().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CheckXML C-Win 
FUNCTION CheckXML RETURNS LONGCHAR
  ( INPUT ilcFile AS LONGCHAR, INPUT icFilename AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF VAR hDoc             AS HANDLE NO-UNDO.
  DEF VAR hRoot            AS HANDLE NO-UNDO.
  DEF VAR doc              AS System.Xml.XmlDocument NO-UNDO.
  DEF VAR lcFile           AS LONGCHAR NO-UNDO.

  CREATE X-DOCUMENT hDoc.
  CREATE X-NODEREF hRoot.
    
  hDoc:LOAD("longchar",ilcFile,NO).
    
  hDoc:GET-DOCUMENT-ELEMENT(hRoot).
  
  IF hRoot:NUM-CHILDREN = 1 THEN DO:
    doc = new System.Xml.XmlDocument().
    DO ON ERROR UNDO, LEAVE:
      doc:LoadXml(ilcFile).
      CATCH ex AS System.Xml.XmlException :
        doc:Load(icFilename).
      END CATCH.
    END.
    lcFile = System.Xml.Linq.XElement:Parse(doc:OuterXml):ToString().
  END.
  ELSE lcFile = ilcFile.

  FINALLY:
    DELETE OBJECT hDoc.
    DELETE OBJECT hRoot.
    RETURN lcFile.
  END FINALLY.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setButtons C-Win 
FUNCTION setButtons RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN btnGenerateDS:SENSITIVE = fiParserMsg:SCREEN-VALUE = "OK!"
         btnGenerateABL:SENSITIVE = btnGenerateDS:SENSITIVE
         .
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

