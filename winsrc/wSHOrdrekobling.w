&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
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
DEF VAR ix          AS INT    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR hToolbar    AS HANDLE NO-UNDO.
DEF VAR hFieldMap   AS HANDLE NO-UNDO.
DEF VAR oContainer  AS JBoxContainer NO-UNDO.

DEFINE TEMP-TABLE ttDoc NO-UNDO
  FIELD iFileNum        AS INTEGER
  FIELD cFileName       AS CHARACTER
  FIELD cFullPathName   AS CHARACTER
  FIELD cFileType       AS CHARACTER
  FIELD cDescription    AS CHARACTER
  FIELD iDocSize        AS INTEGER
  FIELD blDocument      AS BLOB
  FIELD dFileCreateDate AS DATE
  FIELD iFileCreateTime AS INTEGER
  FIELD dFileModDate    AS DATE
  FIELD iFileModTime    AS INTEGER
  FIELD cCreatedBy      AS CHARACTER
  FIELD dCreated        AS DATE
  FIELD cContext        AS CHARACTER
  FIELD cEntityId       AS CHARACTER
  FIELD iSeq            AS INTEGER
  INDEX iFileNum IS PRIMARY UNIQUE iFileNum 
  .


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHOrdrekobling ***/
DEF VAR oBrwNPSHOrdrekobling AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHOrdrekobling
    FIELD iNPSHOrdreId AS integer
    FIELD iNPSHOrdrekoblingId AS integer
    FIELD anleggsnr AS integer
    FIELD id AS integer
    FIELD ordreid AS integer
    FIELD tilbudsid AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_NPSHOrdrekobling FOR TEMP-TABLE NPSHOrdrekobling.


FUNCTION getBuffersAndFieldsBrwNPSHOrdrekobling RETURNS CHARACTER():
  RETURN
    'NPSHOrdrekobling'
     + ';iNPSHOrdreId'
     + ';iNPSHOrdrekoblingId'
  + ',NPSHORD'
     + ';anleggsnr'
     + ';id'
     + ';ordreid'
     + ';tilbudsid'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHOrdrekobling RETURNS CHARACTER():
  RETURN 'EACH NPSHORD  WHERE NPSHORD.ordreid = NPSHOrdrekobling.iNPSHOrdreId NO-LOCK'.
END FUNCTION.
DEF VAR otbNPVarekobling AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHOrdrekobling

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHOrdrekobling

/* Definitions for BROWSE BrwNPSHOrdrekobling                           */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHOrdrekobling ~
NPSHOrdrekobling.iNPSHOrdreId NPSHOrdrekobling.iNPSHOrdrekoblingId ~
NPSHOrdrekobling.anleggsnr NPSHOrdrekobling.id NPSHOrdrekobling.ordreid ~
NPSHOrdrekobling.tilbudsid 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHOrdrekobling ~
NPSHOrdrekobling.iNPSHOrdreId 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSHOrdrekobling NPSHOrdrekobling
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSHOrdrekobling NPSHOrdrekobling
&Scoped-define QUERY-STRING-BrwNPSHOrdrekobling FOR EACH NPSHOrdrekobling NO-LOCK, ~
    EACH NPSHORD WHERE NPSHORD.ordreid = NPSHOrdrekobling.iNPSHOrdreId NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHOrdrekobling OPEN QUERY BrwNPSHOrdrekobling FOR EACH NPSHOrdrekobling NO-LOCK, ~
    EACH NPSHORD WHERE NPSHORD.ordreid = NPSHOrdrekobling.iNPSHOrdreId NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHOrdrekobling NPSHOrdrekobling
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHOrdrekobling NPSHOrdrekobling


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPVarekobling refresh_tbNPVarekobling ~
filter_tbNPVarekobling browseconfig_tbNPVarekobling excel_tbNPVarekobling ~
BrwNPSHOrdrekobling 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPVarekobling 
     IMAGE-UP FILE "img/ico/table.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/table_disabled.gif":U
     LABEL "Column setup" 
     SIZE 7.8 BY 1.95 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON excel_tbNPVarekobling 
     IMAGE-UP FILE "img/ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/excel_disabled.gif":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPVarekobling 
     IMAGE-UP FILE "img/ico/document_find.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_find_disabled.gif":U
     LABEL "Filter" 
     SIZE 7.8 BY 1.95 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON refresh_tbNPVarekobling 
     IMAGE-UP FILE "img/ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbNPVarekobling
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 116.4 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHOrdrekobling FOR 
      NPSHOrdrekobling SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHOrdrekobling
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHOrdrekobling C-Win _STRUCTURED
  QUERY BrwNPSHOrdrekobling NO-LOCK DISPLAY
      NPSHOrdrekobling.iNPSHOrdreId COLUMN-LABEL "Id" FORMAT ">>>>>>>>9":U
      NPSHOrdrekobling.iNPSHOrdrekoblingId COLUMN-LABEL "OrdrekoblingId" FORMAT ">>>>>>>9":U
      NPSHOrdrekobling.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSHOrdrekobling.id COLUMN-LABEL "Tilbudsid" FORMAT ">>>>>>":U
      NPSHOrdrekobling.ordreid COLUMN-LABEL "ordreid" FORMAT ">>>>>>>9":U
      NPSHOrdrekobling.tilbudsid COLUMN-LABEL "Tilbudsid" FORMAT ">>>>>>":U
  ENABLE
      NPSHOrdrekobling.iNPSHOrdreId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS DROP-TARGET SIZE 117.4 BY 14.71 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPVarekobling AT ROW 1.1 COL 1.2 WIDGET-ID 4
     filter_tbNPVarekobling AT ROW 1.1 COL 9.2 WIDGET-ID 6
     browseconfig_tbNPVarekobling AT ROW 1.1 COL 17 WIDGET-ID 8
     excel_tbNPVarekobling AT ROW 1.1 COL 24.8 WIDGET-ID 10
     BrwNPSHOrdrekobling AT ROW 3.38 COL 1 WIDGET-ID 200
     tbNPVarekobling AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 117.4 BY 17.1 WIDGET-ID 100.


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
         HEIGHT             = 17.1
         WIDTH              = 117.4
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 117.4
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 117.4
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
/* BROWSE-TAB BrwNPSHOrdrekobling excel_tbNPVarekobling DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 17.1
       FRAME DEFAULT-FRAME:WIDTH            = 117.4.

ASSIGN 
       tbNPVarekobling:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHOrdrekobling
/* Query rebuild information for BROWSE BrwNPSHOrdrekobling
     _TblList          = "norcalc.NPSHOrdrekobling"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSHOrdrekobling.iNPSHOrdreId
"NPSHOrdrekobling.iNPSHOrdreId" "Id" ">>>>>>>>9" "integer" ? ? ? ? ? ? yes "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSHOrdrekobling.iNPSHOrdrekoblingId
"NPSHOrdrekobling.iNPSHOrdrekoblingId" "OrdrekoblingId" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSHOrdrekobling.anleggsnr
"NPSHOrdrekobling.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSHOrdrekobling.id
"NPSHOrdrekobling.id" "Tilbudsid" ">>>>>>" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSHOrdrekobling.ordreid
"NPSHOrdrekobling.ordreid" "ordreid" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSHOrdrekobling.tilbudsid
"NPSHOrdrekobling.tilbudsid" "Tilbudsid" ">>>>>>" "integer" ? ? ? ? ? ? no "" no no "56.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHOrdrekobling */
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


&Scoped-define BROWSE-NAME BrwNPSHOrdrekobling
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
  RUN disable_UI.
END.

{incl/wintrigg.i}
{incl/conttrigg.i oBrwNPSHOrdrekobling:BROWSE-HANDLE}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DropFileNotifyBrowse C-Win 
PROCEDURE DropFileNotifyBrowse :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
def var i as int no-undo.
def var cFilename as char no-undo.
do i = 1 to oBrwNPSHOrdrekobling:BROWSE-HANDLE:Num-dropped-files:
   cFilename           = oBrwNPSHOrdrekobling:BROWSE-HANDLE:get-dropped-file(i).
   file-info:file-name = cFilename.
   create ttDoc.
   Assign 
     ix              = ix + 1
     ttDoc.iSeq      = ix
     ttDoc.iFileNum  = ix
     ttDoc.cContext  = oBrwNPSHOrdrekobling:PARENT-BUFFER-HANDLE:name
     ttDoc.cEntityId = oBrwNPSHOrdrekobling:PARENT-BUFFER-HANDLE::OrdreId
     ttDoc.cFileName = substring(cFilename,r-index(cFilename,'\') + 1)
     ttDoc.cFileType = entry(2,ttDoc.cFilename,'.')
     ttDoc.iDocSize  = file-info:FILE-SIZE
     ttDoc.cFullPathName = cFilename
     
   .
   MESSAGE ttDoc.cContext ttDoc.cEntityId
   VIEW-AS ALERT-BOX.
/*   copy-lob file cFilename to object ttDoc.blDocument.*/
end.
/*if not JBoxServerAPI:Instance:CallServerProc('add_document.p','validsession',buffer ttDoc:handle) then JBoxServerAPI:Instance:viewCallMessage().*/
empty temp-table ttDoc.
oBrwNPSHOrdrekobling:refresh().
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
  ENABLE tbNPVarekobling refresh_tbNPVarekobling filter_tbNPVarekobling 
         browseconfig_tbNPVarekobling excel_tbNPVarekobling BrwNPSHOrdrekobling 
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

  oBrwNPSHOrdrekobling = NEW JBoxBrowse(brwNPSHOrdrekobling:HANDLE).

  otbNPVarekobling = NEW JBoxToolbar(tbNPVarekobling:HANDLE).

  oBrwNPSHOrdrekobling:TOOLBAR-OBJECT = otbNPVarekobling.
END.
oBrwNPSHOrdrekobling:OpenQuery().


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

