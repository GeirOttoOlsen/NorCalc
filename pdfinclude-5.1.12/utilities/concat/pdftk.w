&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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

{pdf_inc.i "THIS-PROCEDURE"}

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE giFileId  AS INTEGER   NO-UNDO.
DEFINE VARIABLE giNbFiles AS INTEGER   NO-UNDO.

DEFINE VARIABLE ghOverlayLabel   AS HANDLE   NO-UNDO.
DEFINE VARIABLE ghWatermarkLabel AS HANDLE   NO-UNDO.

DEFINE VARIABLE giDeltaY                AS INTEGER   INIT 7 NO-UNDO.
DEFINE VARIABLE giLastBrowseColumnWidth AS INTEGER   NO-UNDO.

{utilities/concat/pdftk.i "NEW SHARED"}

DEFINE TEMP-TABLE ttPdfAdded NO-UNDO LABEL "Temp-table used to track the pdf files known to PDFInclude"
 FIELD slot  AS INTEGER
 FIELD pdfId AS INTEGER
 INDEX ix IS UNIQUE PRIMARY slot pdfId.

&GLOBAL-DEFINE xdPi 3.14159265358979323846

PROCEDURE LockWindowUpdate EXTERNAL "user32.dll":
   DEFINE INPUT  PARAMETER piWindowHwnd AS LONG NO-UNDO.
   DEFINE RETURN PARAMETER piResult     AS LONG NO-UNDO.
END PROCEDURE.

PROCEDURE SendMessageA EXTERNAL "user32.dll" :
  DEFINE INPUT  PARAMETER hwnd        AS LONG.
  DEFINE INPUT  PARAMETER umsg        AS LONG.
  DEFINE INPUT  PARAMETER wparam      AS LONG.
  DEFINE INPUT  PARAMETER lparam      AS LONG.
  DEFINE RETURN PARAMETER ReturnValue AS LONG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brPdfFiles

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttPdfFiles

/* Definitions for BROWSE brPdfFiles                                    */
&Scoped-define FIELDS-IN-QUERY-brPdfFiles ttPdfFiles.file_name ttPdfFiles.page_count ttPdfFiles.pages_to_copy ttPdfFiles.pageTitle ttPdfFiles.pageRotate /* */ ttPdfFiles.rotateInPage /* */ /*   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brPdfFiles */   /* ttPdfFiles.pages_to_copy */   /* ttPdfFiles.pageTitle */   /* ttPdfFiles.pageRotate */   /* ttPdfFiles.rotateInPage */   
&Scoped-define ENABLED-TABLES-IN-QUERY-brPdfFiles ttPdfFiles
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brPdfFiles ttPdfFiles
&Scoped-define SELF-NAME brPdfFiles
&Scoped-define QUERY-STRING-brPdfFiles FOR EACH ttPdfFiles BY ttPdfFiles.order
&Scoped-define OPEN-QUERY-brPdfFiles OPEN QUERY {&SELF-NAME} FOR EACH ttPdfFiles BY ttPdfFiles.order.
&Scoped-define TABLES-IN-QUERY-brPdfFiles ttPdfFiles
&Scoped-define FIRST-TABLE-IN-QUERY-brPdfFiles ttPdfFiles


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brPdfFiles}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rectDescription rectOptions btnAddPdf ~
brPdfFiles btnMoveUp btnMoveDown btnFileDetails btnRemovePdf fiAuthor ~
toAuthorHeader btnAbout fiTitle toTitleHeader fiSubject fiKeywords toHeader ~
toHeaderSep toCompress toFooter toFooterSep toWatermark fiPdfWatermark ~
coWMFont fiFontSize fiAngle toOverlay fiOverlay btnChooseOverlay ~
btnSaveSettings btnSaveSettings2 fiSlotName btnGenerate fiPdfFileName ~
btnChoosePdfFile btnClose fiStatusBar 
&Scoped-Define DISPLAYED-OBJECTS fiTotalPages fiAuthor toAuthorHeader ~
fiTitle toTitleHeader fiSubject fiKeywords toHeader toHeaderSep toCompress ~
toFooter toFooterSep toWatermark fiPdfWatermark coWMFont fiFontSize fiAngle ~
toOverlay fiOverlay fiSlot fiSlotName fiPdfFileName fiStatusBar ~
txBrowseTooltip txFileDescription txOptionalEnhancements 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 fiTotalPages toAuthorHeader btnAbout toTitleHeader ~
fiSlot btnSaveSettings btnSaveSettings2 fiSlotName btnChoosePdfFile ~
btnClose 
&Scoped-define List-2 rectDescription brPdfFiles fiAuthor fiTitle fiSubject ~
fiKeywords fiPdfFileName fiStatusBar 
&Scoped-define List-3 rectDescription rectOptions fiTotalPages fiAuthor ~
toAuthorHeader btnAbout fiTitle toTitleHeader fiSubject fiKeywords toHeader ~
toHeaderSep toCompress toFooter toFooterSep toWatermark fiPdfWatermark ~
coWMFont fiFontSize fiAngle toOverlay fiOverlay btnChooseOverlay fiSlot ~
btnSaveSettings btnSaveSettings2 fiSlotName btnGenerate fiPdfFileName ~
btnChoosePdfFile btnClose fiStatusBar txBrowseTooltip txFileDescription ~
txOptionalEnhancements 
&Scoped-define List-4 brPdfFiles 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getModifiedStatus C-Win 
FUNCTION getModifiedStatus RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD quitApplication C-Win 
FUNCTION quitApplication RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Load_Slot 
       MENU-ITEM m_Slot_1_Load  LABEL "Slot 1 - unnamed"
       MENU-ITEM m_Slot_2_Load  LABEL "Slot 2 - unnamed"
       MENU-ITEM m_Slot_3_Load  LABEL "Slot 3 - unnamed"
       MENU-ITEM m_Slot_4_Load  LABEL "Slot 4 - unnamed"
       MENU-ITEM m_Slot_5_Load  LABEL "Slot 5 - unnamed"
       MENU-ITEM m_Slot_6_Load  LABEL "Slot 6 - unnamed"
       MENU-ITEM m_Slot_7_Load  LABEL "Slot 7 - unnamed"
       MENU-ITEM m_Slot_8_Load  LABEL "Slot 8 - unnamed"
       MENU-ITEM m_Slot_9_Load  LABEL "Slot 9 - unnamed"
       MENU-ITEM m_Slot_10_Load LABEL "Slot 10 - unnamed"
       MENU-ITEM m_Slot_11_Load LABEL "Slot 11 - unnamed"
       MENU-ITEM m_Slot_12_Load LABEL "Slot 12 - unnamed".

DEFINE SUB-MENU m_Save_As 
       MENU-ITEM m_Slot_1       LABEL "Slot 1 - unnamed"
       MENU-ITEM m_Slot_2       LABEL "Slot 2 - unnamed"
       MENU-ITEM m_Slot_3       LABEL "Slot 3 - unnamed"
       MENU-ITEM m_Slot_4       LABEL "Slot 4 - unnamed"
       MENU-ITEM m_Slot_5       LABEL "Slot 5 - unnamed"
       MENU-ITEM m_Slot_6       LABEL "Slot 6 - unnamed"
       MENU-ITEM m_Slot_7       LABEL "Slot 7 - unnamed"
       MENU-ITEM m_Slot_8       LABEL "Slot 8 - unnamed"
       MENU-ITEM m_Slot_9       LABEL "Slot 9 - unnamed"
       MENU-ITEM m_Slot_10      LABEL "Slot 10 - unnamed"
       MENU-ITEM m_Slot_11      LABEL "Slot 11 - unnamed"
       MENU-ITEM m_Slot_12      LABEL "Slot 12 - unnamed".

DEFINE MENU POPUP-MENU-btnSaveSettings2 
       MENU-ITEM m_Load         LABEL "&Load"         
       SUB-MENU  m_Load_Slot    LABEL "Load Slot"     
       MENU-ITEM m_Save         LABEL "&Save"         
       SUB-MENU  m_Save_As      LABEL "Save &As"      
       MENU-ITEM m_Delete       LABEL "&Delete"       .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAbout 
     LABEL "About" 
     SIZE 15 BY 1.14 TOOLTIP "Save the settings && all values above for future reuse".

DEFINE BUTTON btnAddPdf 
     LABEL "&Add PDF file" 
     SIZE 15 BY 1.14 TOOLTIP "Add a source PDF file to the list".

DEFINE BUTTON btnChooseOverlay 
     LABEL "..." 
     SIZE 4 BY 1.14 TOOLTIP "Choose overlay".

DEFINE BUTTON btnChoosePdfFile 
     LABEL "..." 
     SIZE 4 BY 1.14 TOOLTIP "Choose destination file".

DEFINE BUTTON btnClose AUTO-GO 
     LABEL "&Close" 
     SIZE 15 BY 1.14 TOOLTIP "Close this window".

DEFINE BUTTON btnFileDetails 
     LABEL "D&etails..." 
     SIZE 15 BY 1.14 TOOLTIP "Show source PDF file details && edit file options".

DEFINE BUTTON btnGenerate 
     LABEL "&Generate PDF" 
     SIZE 15 BY 1.14 TOOLTIP "Generate the final PDF file, based on above selected options".

DEFINE BUTTON btnMoveDown 
     LABEL "Move &down" 
     SIZE 15 BY 1.14 TOOLTIP "Move the file down in the list".

DEFINE BUTTON btnMoveUp 
     LABEL "Move &up" 
     SIZE 15 BY 1.14 TOOLTIP "Move the file up in the list".

DEFINE BUTTON btnRemovePdf 
     LABEL "&Remove file" 
     SIZE 15 BY 1.14 TOOLTIP "Remove source PDF file".

DEFINE BUTTON btnSaveSettings 
     LABEL "&Save settings" 
     SIZE 15 BY 1.14 TOOLTIP "Save the settings && all values above for future reuse".

DEFINE BUTTON btnSaveSettings2 
     LABEL "..." 
     SIZE 3 BY 1.14 TOOLTIP "Choose destination file".

DEFINE VARIABLE coWMFont AS CHARACTER FORMAT "X(256)":U 
     LABEL "Font" 
     VIEW-AS COMBO-BOX INNER-LINES 20
     LIST-ITEMS "Helvetica","Helvetica Bold","Helvetica Oblique","Helvetica Bold Oblique","Times","Times Bold","Times Italic","Times Bold Italic","Courier","Courier Bold","Courier Oblique","Courier Bold Oblique" 
     DROP-DOWN-LIST
     SIZE 23 BY 1 TOOLTIP "Watermark font" NO-UNDO.

DEFINE VARIABLE fiAngle AS DECIMAL FORMAT "->>9.99":U INITIAL 45 
     LABEL "Angle" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 14 BY 1 TOOLTIP "Watermark text angle" NO-UNDO.

DEFINE VARIABLE fiAuthor AS CHARACTER FORMAT "X(256)":U 
     LABEL "Author" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 TOOLTIP "Author (for header && PDF file properties)" NO-UNDO.

DEFINE VARIABLE fiFontSize AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 10 
     LABEL "Font size" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 14 BY 1 TOOLTIP "Watermark font size" NO-UNDO.

DEFINE VARIABLE fiKeywords AS CHARACTER FORMAT "X(256)":U 
     LABEL "Keywords" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 TOOLTIP "Keywords of the document (for PDF file properties" NO-UNDO.

DEFINE VARIABLE fiOverlay AS CHARACTER FORMAT "X(256)":U 
     LABEL "Overlay" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 116 BY 1 TOOLTIP "Overlay PDF file name" NO-UNDO.

DEFINE VARIABLE fiPdfFileName AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 116 BY 1 TOOLTIP "Destination file" NO-UNDO.

DEFINE VARIABLE fiPdfWatermark AS CHARACTER FORMAT "X(256)":U 
     LABEL "Watermark" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 39 BY 1 TOOLTIP "Watermark text" NO-UNDO.

DEFINE VARIABLE fiSlot AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Save to slot" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 TOOLTIP "Slot in which the settings will be saved" NO-UNDO.

DEFINE VARIABLE fiSlotName AS CHARACTER FORMAT "X(30)":U INITIAL "unnamed" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "Name of the settings slot" NO-UNDO.

DEFINE VARIABLE fiStatusBar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 177.8 BY 1 NO-UNDO.

DEFINE VARIABLE fiSubject AS CHARACTER FORMAT "X(256)":U 
     LABEL "Subject" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 TOOLTIP "Subject of the document (for PDF file properties" NO-UNDO.

DEFINE VARIABLE fiTitle AS CHARACTER FORMAT "X(256)":U 
     LABEL "Title" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1 TOOLTIP "Title (for header && PDF file properties)" NO-UNDO.

DEFINE VARIABLE fiTotalPages AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Total pages" 
     VIEW-AS FILL-IN 
     SIZE 6 BY 1 TOOLTIP "Total number of pages to be generated" NO-UNDO.

DEFINE VARIABLE txBrowseTooltip AS CHARACTER FORMAT "X(256)":U INITIAL "Double click on a line to change the file properties / Drag'n drop files in the browse or use the [Add PDF File] button" 
      VIEW-AS TEXT 
     SIZE 134 BY .62
     FONT 6 NO-UNDO.

DEFINE VARIABLE txFileDescription AS CHARACTER FORMAT "X(256)":U INITIAL "File description" 
      VIEW-AS TEXT 
     SIZE 15 BY .62 NO-UNDO.

DEFINE VARIABLE txOptionalEnhancements AS CHARACTER FORMAT "X(256)":U INITIAL "Optional enhancements" 
      VIEW-AS TEXT 
     SIZE 23 BY .62 NO-UNDO.

DEFINE RECTANGLE rectDescription
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 5.95.

DEFINE RECTANGLE rectOptions
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 146 BY 5.24.

DEFINE VARIABLE toAuthorHeader AS LOGICAL INITIAL no 
     LABEL "Header?" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 TOOLTIP "Write in the header?" NO-UNDO.

DEFINE VARIABLE toCompress AS LOGICAL INITIAL yes 
     LABEL "Compress" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .81 TOOLTIP "Enable compression within the PDF file" NO-UNDO.

DEFINE VARIABLE toFooter AS LOGICAL INITIAL no 
     LABEL "Page footer" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 TOOLTIP "Enable page footer" NO-UNDO.

DEFINE VARIABLE toFooterSep AS LOGICAL INITIAL no 
     LABEL "Separator line" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 TOOLTIP "Separate footer from document with a line" NO-UNDO.

DEFINE VARIABLE toHeader AS LOGICAL INITIAL no 
     LABEL "Page header" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 TOOLTIP "Enable page header" NO-UNDO.

DEFINE VARIABLE toHeaderSep AS LOGICAL INITIAL no 
     LABEL "Separator line" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 TOOLTIP "Separate header from document with a line" NO-UNDO.

DEFINE VARIABLE toOverlay AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .81 TOOLTIP "Enable overlay" NO-UNDO.

DEFINE VARIABLE toTitleHeader AS LOGICAL INITIAL no 
     LABEL "Header?" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 TOOLTIP "Write in the header?" NO-UNDO.

DEFINE VARIABLE toWatermark AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 3 BY .81 TOOLTIP "Enable watermark" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brPdfFiles FOR 
      ttPdfFiles SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brPdfFiles
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brPdfFiles C-Win _FREEFORM
  QUERY brPdfFiles DISPLAY
      ttPdfFiles.file_name
ttPdfFiles.page_count
ttPdfFiles.pages_to_copy
ttPdfFiles.pageTitle
ttPdfFiles.pageRotate    /* VIEW-AS COMBO-BOX LIST-ITEMS "0,90,180,270" */
ttPdfFiles.rotateInPage  /* VIEW-AS COMBO-BOX LIST-ITEMS "0,90,180,270" */
/* ENABLE */
    /* ttPdfFiles.pages_to_copy */
    /* ttPdfFiles.pageTitle */
    /* ttPdfFiles.pageRotate */
    /* ttPdfFiles.rotateInPage */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS DROP-TARGET SIZE 143 BY 7.86
         TITLE "Source PDF Files" ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnAddPdf AT ROW 2.91 COL 9 WIDGET-ID 2
     brPdfFiles AT ROW 2.91 COL 32 WIDGET-ID 200
     btnMoveUp AT ROW 4.57 COL 9 WIDGET-ID 4
     btnMoveDown AT ROW 6.24 COL 9 WIDGET-ID 6
     btnFileDetails AT ROW 8.14 COL 9 WIDGET-ID 76
     btnRemovePdf AT ROW 9.57 COL 9 WIDGET-ID 20
     fiTotalPages AT ROW 12.19 COL 156.6 WIDGET-ID 66
     fiAuthor AT ROW 12.91 COL 24.6 WIDGET-ID 26
     toAuthorHeader AT ROW 13.05 COL 73 WIDGET-ID 92
     btnAbout AT ROW 13.38 COL 160 WIDGET-ID 106
     fiTitle AT ROW 14.1 COL 26.8 WIDGET-ID 28
     toTitleHeader AT ROW 14.24 COL 73 WIDGET-ID 94
     fiSubject AT ROW 15.29 COL 23.6 WIDGET-ID 32
     fiKeywords AT ROW 16.48 COL 21.6 WIDGET-ID 30
     toHeader AT ROW 18.86 COL 32 WIDGET-ID 38
     toHeaderSep AT ROW 18.86 COL 52 WIDGET-ID 70
     toCompress AT ROW 19.1 COL 134 WIDGET-ID 90
     toFooter AT ROW 19.81 COL 32 WIDGET-ID 40
     toFooterSep AT ROW 19.81 COL 52 WIDGET-ID 68
     toWatermark AT ROW 20.76 COL 16 WIDGET-ID 78
     fiPdfWatermark AT ROW 20.76 COL 20.4 WIDGET-ID 44
     coWMFont AT ROW 20.76 COL 72.6 WIDGET-ID 54
     fiFontSize AT ROW 20.76 COL 102.4 WIDGET-ID 64
     fiAngle AT ROW 20.76 COL 127.4 WIDGET-ID 62
     toOverlay AT ROW 21.95 COL 16 WIDGET-ID 80
     fiOverlay AT ROW 21.95 COL 23.6 WIDGET-ID 48
     btnChooseOverlay AT ROW 21.95 COL 149 WIDGET-ID 50
     fiSlot AT ROW 23.86 COL 127.6 WIDGET-ID 100
     btnSaveSettings AT ROW 23.86 COL 160 WIDGET-ID 72
     btnSaveSettings2 AT ROW 23.86 COL 175 WIDGET-ID 98
     fiSlotName AT ROW 23.91 COL 145 NO-LABEL WIDGET-ID 104
     btnGenerate AT ROW 25.29 COL 9 WIDGET-ID 14
     fiPdfFileName AT ROW 25.29 COL 32 NO-LABEL WIDGET-ID 16
     btnChoosePdfFile AT ROW 25.29 COL 149 WIDGET-ID 18
     btnClose AT ROW 25.29 COL 160 WIDGET-ID 12
     fiStatusBar AT ROW 26.95 COL 1 NO-LABEL WIDGET-ID 24
     txBrowseTooltip AT ROW 11 COL 30 COLON-ALIGNED NO-LABEL WIDGET-ID 88 NO-TAB-STOP 
     txFileDescription AT ROW 11.95 COL 8 COLON-ALIGNED NO-LABEL WIDGET-ID 84 NO-TAB-STOP 
     txOptionalEnhancements AT ROW 18.14 COL 8 COLON-ALIGNED NO-LABEL WIDGET-ID 86 NO-TAB-STOP 
     rectDescription AT ROW 12.19 COL 9 WIDGET-ID 34
     rectOptions AT ROW 18.38 COL 9 WIDGET-ID 56
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 178.2 BY 27.38 WIDGET-ID 100.


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
         TITLE              = "PDF Include toolkit"
         HEIGHT             = 27.05
         WIDTH              = 178.2
         MAX-HEIGHT         = 35.67
         MAX-WIDTH          = 256.8
         VIRTUAL-HEIGHT     = 35.67
         VIRTUAL-WIDTH      = 256.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = yes
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("utilities/concat/pdftk.ico":U) THEN
    MESSAGE "Unable to load icon: utilities/concat/pdftk.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB brPdfFiles btnAddPdf DEFAULT-FRAME */
/* SETTINGS FOR BROWSE brPdfFiles IN FRAME DEFAULT-FRAME
   2 4                                                                  */
ASSIGN 
       brPdfFiles:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

/* SETTINGS FOR BUTTON btnAbout IN FRAME DEFAULT-FRAME
   1 3                                                                  */
/* SETTINGS FOR BUTTON btnChooseOverlay IN FRAME DEFAULT-FRAME
   3                                                                    */
/* SETTINGS FOR BUTTON btnChoosePdfFile IN FRAME DEFAULT-FRAME
   1 3                                                                  */
/* SETTINGS FOR BUTTON btnClose IN FRAME DEFAULT-FRAME
   1 3                                                                  */
/* SETTINGS FOR BUTTON btnGenerate IN FRAME DEFAULT-FRAME
   3                                                                    */
/* SETTINGS FOR BUTTON btnSaveSettings IN FRAME DEFAULT-FRAME
   1 3                                                                  */
/* SETTINGS FOR BUTTON btnSaveSettings2 IN FRAME DEFAULT-FRAME
   1 3                                                                  */
ASSIGN 
       btnSaveSettings2:POPUP-MENU IN FRAME DEFAULT-FRAME       = MENU POPUP-MENU-btnSaveSettings2:HANDLE.

/* SETTINGS FOR COMBO-BOX coWMFont IN FRAME DEFAULT-FRAME
   ALIGN-L 3                                                            */
ASSIGN 
       coWMFont:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

/* SETTINGS FOR FILL-IN fiAngle IN FRAME DEFAULT-FRAME
   ALIGN-L 3                                                            */
/* SETTINGS FOR FILL-IN fiAuthor IN FRAME DEFAULT-FRAME
   ALIGN-L 2 3                                                          */
/* SETTINGS FOR FILL-IN fiFontSize IN FRAME DEFAULT-FRAME
   ALIGN-L 3                                                            */
/* SETTINGS FOR FILL-IN fiKeywords IN FRAME DEFAULT-FRAME
   ALIGN-L 2 3                                                          */
/* SETTINGS FOR FILL-IN fiOverlay IN FRAME DEFAULT-FRAME
   ALIGN-L 3                                                            */
/* SETTINGS FOR FILL-IN fiPdfFileName IN FRAME DEFAULT-FRAME
   ALIGN-L 2 3                                                          */
/* SETTINGS FOR FILL-IN fiPdfWatermark IN FRAME DEFAULT-FRAME
   ALIGN-L 3                                                            */
/* SETTINGS FOR FILL-IN fiSlot IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L 1 3                                                */
/* SETTINGS FOR FILL-IN fiSlotName IN FRAME DEFAULT-FRAME
   ALIGN-L 1 3                                                          */
/* SETTINGS FOR FILL-IN fiStatusBar IN FRAME DEFAULT-FRAME
   ALIGN-L 2 3                                                          */
ASSIGN 
       fiStatusBar:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN fiSubject IN FRAME DEFAULT-FRAME
   ALIGN-L 2 3                                                          */
/* SETTINGS FOR FILL-IN fiTitle IN FRAME DEFAULT-FRAME
   ALIGN-L 2 3                                                          */
/* SETTINGS FOR FILL-IN fiTotalPages IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L 1 3                                                */
/* SETTINGS FOR RECTANGLE rectDescription IN FRAME DEFAULT-FRAME
   2 3                                                                  */
/* SETTINGS FOR RECTANGLE rectOptions IN FRAME DEFAULT-FRAME
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX toAuthorHeader IN FRAME DEFAULT-FRAME
   1 3                                                                  */
/* SETTINGS FOR TOGGLE-BOX toCompress IN FRAME DEFAULT-FRAME
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX toFooter IN FRAME DEFAULT-FRAME
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX toFooterSep IN FRAME DEFAULT-FRAME
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX toHeader IN FRAME DEFAULT-FRAME
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX toHeaderSep IN FRAME DEFAULT-FRAME
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX toOverlay IN FRAME DEFAULT-FRAME
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX toTitleHeader IN FRAME DEFAULT-FRAME
   1 3                                                                  */
/* SETTINGS FOR TOGGLE-BOX toWatermark IN FRAME DEFAULT-FRAME
   3                                                                    */
/* SETTINGS FOR FILL-IN txBrowseTooltip IN FRAME DEFAULT-FRAME
   NO-ENABLE 3                                                          */
ASSIGN 
       txBrowseTooltip:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN txFileDescription IN FRAME DEFAULT-FRAME
   NO-ENABLE 3                                                          */
ASSIGN 
       txFileDescription:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN txOptionalEnhancements IN FRAME DEFAULT-FRAME
   NO-ENABLE 3                                                          */
ASSIGN 
       txOptionalEnhancements:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brPdfFiles
/* Query rebuild information for BROWSE brPdfFiles
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttPdfFiles BY ttPdfFiles.order.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brPdfFiles */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* PDF Include toolkit */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
    /* This case occurs when the user presses the "Esc" key.
       In a persistently run window, just ignore this.  If we did not, the
       application would exit. */
    /* 09-DEC-2014 jcc: we want the window to close on [Esc] */
    /* IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY. */
    IF NOT quitApplication() THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* PDF Include toolkit */
DO:
    /* This event will close the window and terminate the procedure.  */
    /* APPLY "CLOSE":U TO THIS-PROCEDURE. */
    IF NOT quitApplication() THEN
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* PDF Include toolkit */
DO:
    DEFINE VARIABLE hWidget     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE iDummy      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNewHeight  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNewWidth   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iOrigHeight AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iOrigWidth  AS INTEGER     NO-UNDO.

    /* 04-MAR-2015 jcc: the way the widgets are moved/resized is defined through Appbuilder's custom lists (checkbox at the widget level) */
    /* update X position: {&List-1} */
    /* update WIDTH: {&List-2} */
    /* update Y position: {&List-3} */
    /* update HEIGHT: {&List-4} */

    DO WITH FRAME {&FRAME-NAME}:
        iOrigWidth  = FRAME {&FRAME-NAME}:WIDTH-PIXELS.
        iOrigHeight = FRAME {&FRAME-NAME}:HEIGHT-PIXELS.
        iNewWidth   = C-Win:WIDTH-PIXELS.
        iNewHeight  = C-Win:HEIGHT-PIXELS + giDeltaY.
        giDeltaY = 0.

        RUN LockWindowUpdate (FRAME {&FRAME-NAME}:HWND, OUTPUT iDummy).

        /* Resize frame (when increasing sizes) */
        IF C-Win:WIDTH-PIXELS > iOrigWidth THEN DO:
            FRAME {&FRAME-NAME}:WIDTH-PIXELS = C-Win:WIDTH-PIXELS.
            FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS = C-Win:WIDTH-PIXELS.
        END.
        IF C-Win:HEIGHT-PIXELS > iOrigHeight THEN DO:
            FRAME {&FRAME-NAME}:HEIGHT-PIXELS = C-Win:HEIGHT-PIXELS.
            FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-PIXELS = C-Win:HEIGHT-PIXELS.
        END.

        /* move & resize widgets */
        hWidget = FRAME {&FRAME-NAME}:FIRST-CHILD:FIRST-CHILD.
        DO WHILE VALID-HANDLE(hWidget):
            IF LOOKUP(hWidget:NAME, "{&List-1}", " ") > 0 THEN DO:
                hWidget:X = iNewWidth - (iOrigWidth - hWidget:X).
                IF CAN-DO("FILL-IN,COMBO-BOX", hWidget:TYPE) AND VALID-HANDLE(hWidget:SIDE-LABEL-HANDLE) THEN
                    hWidget:SIDE-LABEL-HANDLE:X = iNewWidth - (iOrigWidth - hWidget:SIDE-LABEL-HANDLE:X).
            END.
            IF LOOKUP(hWidget:NAME, "{&List-2}", " ") > 0 THEN
                hWidget:WIDTH-PIXELS = iNewWidth - (iOrigWidth - hWidget:WIDTH-PIXELS).

            IF LOOKUP(hWidget:NAME, "{&List-3}", " ") > 0 THEN DO:
                hWidget:Y = iNewHeight - (iOrigHeight - hWidget:Y).
                IF CAN-DO("FILL-IN,COMBO-BOX", hWidget:TYPE) AND VALID-HANDLE(hWidget:SIDE-LABEL-HANDLE) THEN
                    hWidget:SIDE-LABEL-HANDLE:Y = iNewHeight - (iOrigHeight - hWidget:SIDE-LABEL-HANDLE:Y).
            END.
            IF LOOKUP(hWidget:NAME, "{&List-4}", " ") > 0 THEN
                hWidget:HEIGHT-PIXELS = iNewHeight - (iOrigHeight - brPdfFiles:HEIGHT-PIXELS).
            hWidget = hWidget:NEXT-SIBLING.
        END.

        /* Resize frame (when decreasing sizes) */
        IF C-Win:WIDTH-PIXELS < iOrigWidth THEN DO:
            FRAME {&FRAME-NAME}:WIDTH-PIXELS = C-Win:WIDTH-PIXELS.
            FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS = C-Win:WIDTH-PIXELS.
        END.
        IF C-Win:HEIGHT-PIXELS < iOrigHeight THEN DO:
            FRAME {&FRAME-NAME}:HEIGHT-PIXELS = C-Win:HEIGHT-PIXELS.
            FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-PIXELS = C-Win:HEIGHT-PIXELS.
        END.

        /* specific handling of browse columns widths */
        DEFINE VARIABLE hBrColumn     AS HANDLE    NO-UNDO.
        DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iColumnsWidth AS INTEGER   NO-UNDO.

        /* force last column size - there is a "bug" that makes it so small */
        /* not needed once "fit-last-column" is unchecked for the browse    */
        /* hBrColumn = brPdfFiles:GET-BROWSE-COLUMN(brPdfFiles:NUM-COLUMNS). */
        /* hBrColumn:WIDTH-PIXELS = giLastBrowseColumnWidth. */

        iColumnsWidth = 42. /* width of scroll bar + browses extras (?) */
        DO i = 1 TO brPdfFiles:NUM-COLUMNS:
            hBrColumn = brPdfFiles:GET-BROWSE-COLUMN(i).
            iColumnsWidth = iColumnsWidth + hBrColumn:WIDTH-PIXELS.
        END.

        IF brPdfFiles:WIDTH-PIXELS > iColumnsWidth THEN DO:
            hBrColumn = brPdfFiles:GET-BROWSE-COLUMN(4). /* page titles */
            hBrColumn:WIDTH-PIXELS = iNewWidth - (iOrigWidth - hBrColumn:WIDTH-PIXELS).
        END.
        ELSE IF iOrigWidth > C-Win:WIDTH-PIXELS AND brPdfFiles:WIDTH-PIXELS < iColumnsWidth THEN DO:
            hBrColumn = brPdfFiles:GET-BROWSE-COLUMN(4). /* page titles */
            hBrColumn:WIDTH-PIXELS = MAXIMUM(58, iNewWidth - (iOrigWidth - hBrColumn:WIDTH-PIXELS)).
        END.

        /* for some reason, I have to force the size again, else when we decrease the  */
        /* hBrColumn = brPdfFiles:GET-BROWSE-COLUMN(brPdfFiles:NUM-COLUMNS). */
        /* hBrColumn:WIDTH-PIXELS = giLastBrowseColumnWidth. */

        RUN LockWindowUpdate (0, OUTPUT iDummy).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brPdfFiles
&Scoped-define SELF-NAME brPdfFiles
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPdfFiles C-Win
ON DELETE-CHARACTER OF brPdfFiles IN FRAME DEFAULT-FRAME /* Source PDF Files */
DO:
    APPLY "CHOOSE" TO btnRemovePdf.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPdfFiles C-Win
ON DROP-FILE-NOTIFY OF brPdfFiles IN FRAME DEFAULT-FRAME /* Source PDF Files */
DO:
    DEFINE VARIABLE cFileName  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cPdfId     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iNbDropped AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iPageCount AS INTEGER     NO-UNDO.

    SESSION:SET-WAIT-STATE("GENERAL").
    DO WHILE TRUE:
        iNbDropped = iNbDropped + 1.
        cFileName = brPdfFiles:GET-DROPPED-FILE(iNbDropped) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN LEAVE.
        IF SEARCH(cFileName) = ? THEN LEAVE.
        RUN addFile (cFileName
                    ,OUTPUT iPageCount
                    ,OUTPUT cPdfId).
    END.
    brPdfFiles:END-FILE-DROP().
    SESSION:SET-WAIT-STATE("").
    RUN updateTotalPages.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPdfFiles C-Win
ON MOUSE-SELECT-DBLCLICK OF brPdfFiles IN FRAME DEFAULT-FRAME /* Source PDF Files */
DO:
    RUN openPropertiesDialog NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brPdfFiles C-Win
ON RETURN OF brPdfFiles IN FRAME DEFAULT-FRAME /* Source PDF Files */
DO:
    RUN openPropertiesDialog.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAbout C-Win
ON CHOOSE OF btnAbout IN FRAME DEFAULT-FRAME /* About */
DO:
    MESSAGE "Pdfinclude toolkit~nUsing PDFInclude~n(c) 2015 by snowwolf-software.com~n~nI recommend the use of the SumatraPDF pdf viewer (http://sumatrapdfreader.org):~nOpen the generated file, change settings and generate again:~nthe pdf viewer updates itself automatically.~nThus you can change your settings until you are satisfied!"
        VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "About PDFInclude toolkit".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnAddPdf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAddPdf C-Win
ON CHOOSE OF btnAddPdf IN FRAME DEFAULT-FRAME /* Add PDF file */
DO:
    DEFINE VARIABLE cFile      AS CHARACTER   NO-UNDO.
    /* DEFINE VARIABLE cPath      AS CHARACTER   NO-UNDO. */
    DEFINE VARIABLE cPdfId     AS CHARACTER   NO-UNDO.
    /* DEFINE VARIABLE cType      AS CHARACTER   NO-UNDO. */
    /* DEFINE VARIABLE cValue     AS CHARACTER   NO-UNDO. */
    DEFINE VARIABLE iPageCount AS INTEGER     NO-UNDO.
    DEFINE VARIABLE lOK        AS LOGICAL     NO-UNDO.

    DEFINE BUFFER bttPdfFiles FOR ttPdfFiles.

    SYSTEM-DIALOG GET-FILE cFile
        FILTERS 'PDF File (*.pdf)' '*.pdf',
                'All Files (*.*)' '*.*'
        INITIAL-FILTER 1
        MUST-EXIST
        UPDATE lOK.
    IF lOK THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL").
        RUN addFile(cFile, OUTPUT iPageCount, OUTPUT cPdfId).
        RUN updateTotalPages.
        SESSION:SET-WAIT-STATE("").
    END.
    ELSE
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnChooseOverlay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnChooseOverlay C-Win
ON CHOOSE OF btnChooseOverlay IN FRAME DEFAULT-FRAME /* ... */
DO:
    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lOK   AS LOGICAL    NO-UNDO.

    SYSTEM-DIALOG GET-FILE cFile
        FILTERS 'PDF File (*.pdf)' '*.pdf',
                'All Files (*.*)' '*.*'
        INITIAL-FILTER 1
        UPDATE lOK.
    IF lOK THEN
        fiOverlay:SCREEN-VALUE = cFile.
    ELSE
        RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnChoosePdfFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnChoosePdfFile C-Win
ON CHOOSE OF btnChoosePdfFile IN FRAME DEFAULT-FRAME /* ... */
DO:
    DEFINE VARIABLE cFile AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lOK   AS LOGICAL    NO-UNDO.

    SYSTEM-DIALOG GET-FILE cFile
        FILTERS 'PDF File (*.pdf)' '*.pdf',
                'All Files (*.*)' '*.*'
        INITIAL-FILTER 1
        ASK-OVERWRITE SAVE-AS
        UPDATE lOK.
    IF lOK THEN
        fiPdfFileName:SCREEN-VALUE = cFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnClose C-Win
ON CHOOSE OF btnClose IN FRAME DEFAULT-FRAME /* Close */
DO:
    quitApplication().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnFileDetails
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnFileDetails C-Win
ON CHOOSE OF btnFileDetails IN FRAME DEFAULT-FRAME /* Details... */
DO:
    RUN openPropertiesDialog NO-ERROR.
    IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.

    brPdfFiles:MODIFIED = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnGenerate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnGenerate C-Win
ON CHOOSE OF btnGenerate IN FRAME DEFAULT-FRAME /* Generate PDF */
DO:

    /* RUN saveSettings. */
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN {&DISPLAYED-OBJECTS}.
    END.

    IF fiPdfFileName = "" THEN DO:
        RUN statusBar ("Please enter a destination PDF file name.", "error").
        RETURN NO-APPLY.
    END.
    IF NOT CAN-FIND(FIRST ttPdfFiles) THEN DO:
        RUN statusBar ("Please choose some input PDF files.", "error").
        RETURN NO-APPLY.
    END.

    RUN generatePdf.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnMoveDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnMoveDown C-Win
ON CHOOSE OF btnMoveDown IN FRAME DEFAULT-FRAME /* Move down */
DO:
    DEFINE BUFFER bttPdfFiles FOR ttPdfFiles.

    IF NOT AVAILABLE ttPdfFiles THEN RETURN NO-APPLY.

    IF ttPdfFiles.order >= giNbFiles THEN
        RETURN NO-APPLY.

    FIND bttPdfFiles WHERE bttPdfFiles.order = ttPdfFiles.order + 1.

    ASSIGN
        bttPdfFiles.order = bttPdfFiles.order - 1
        ttPdfFiles.order  = ttPdfFiles.order + 1.

    {&OPEN-QUERY-brPdfFiles}
    FIND ttPdfFiles WHERE ttPdfFiles.order = bttPdfFiles.order + 1.
    BROWSE brPdfFiles:SELECT-ROW(bttPdfFiles.order + 1).

    brPdfFiles:MODIFIED = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnMoveUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnMoveUp C-Win
ON CHOOSE OF btnMoveUp IN FRAME DEFAULT-FRAME /* Move up */
DO:
    DEFINE BUFFER bttPdfFiles FOR ttPdfFiles.

    IF NOT AVAILABLE ttPdfFiles THEN RETURN NO-APPLY.

    IF ttPdfFiles.order <= 1 THEN
        RETURN NO-APPLY.

    FIND bttPdfFiles WHERE bttPdfFiles.order = ttPdfFiles.order - 1.

    ASSIGN
        bttPdfFiles.order = bttPdfFiles.order + 1
        ttPdfFiles.order  = ttPdfFiles.order - 1.

    {&OPEN-QUERY-brPdfFiles}
    FIND ttPdfFiles WHERE ttPdfFiles.order = bttPdfFiles.order - 1.
    BROWSE brPdfFiles:SELECT-ROW(bttPdfFiles.order - 1).

    brPdfFiles:MODIFIED = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRemovePdf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRemovePdf C-Win
ON CHOOSE OF btnRemovePdf IN FRAME DEFAULT-FRAME /* Remove file */
DO:
    DEFINE VARIABLE iOrder AS INTEGER     NO-UNDO.
    
    DEFINE BUFFER bttPdfFiles FOR ttPdfFiles.

    IF AVAILABLE ttPdfFiles THEN DO:
        DELETE ttPdfFiles.
        {&OPEN-QUERY-brPdfFiles}
    END.

    REPEAT PRESELECT EACH bttPdfFiles BY bttPdfFiles.order:
        FIND NEXT bttPdfFiles.
        iOrder = iOrder + 1.
        bttPdfFiles.order = iOrder.
    END.

    giNbFiles = iOrder.

    RUN updateTotalPages.

    brPdfFiles:MODIFIED = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSaveSettings
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSaveSettings C-Win
ON CHOOSE OF btnSaveSettings IN FRAME DEFAULT-FRAME /* Save settings */
DO:
    RUN saveSettings.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSaveSettings2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSaveSettings2 C-Win
ON CHOOSE OF btnSaveSettings2 IN FRAME DEFAULT-FRAME /* ... */
DO:
    DEFINE VARIABLE iReturn AS INTEGER     NO-UNDO.
    /* open the associated popup menu POPUP-MENU-btnSaveSettings2 */
    RUN SendMessageA (btnSaveSettings2:HWND, 517 /* WM_RBUTTONUP - 0x205 */, 0, 0, OUTPUT iReturn).
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Delete C-Win
ON CHOOSE OF MENU-ITEM m_Delete /* Delete */
DO:
    RUN deleteSlot.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Load C-Win
ON CHOOSE OF MENU-ITEM m_Load /* Load */
DO:
    RUN loadFromSlot (fiSlot).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save C-Win
ON CHOOSE OF MENU-ITEM m_Save /* Save */
DO:
    RUN saveSettings.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Save_As
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Save_As C-Win
ON CHOOSE OF MENU m_Save_As /* Save As */
DO:
    /* open a dialog box to choose the name under which to save the current setting */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_1 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_1 /* Slot 1 - unnamed */
DO:
    RUN saveToSlot (1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_10
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_10 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_10 /* Slot 10 - unnamed */
DO:
    RUN saveToSlot (10).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_10_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_10_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_10_Load /* Slot 10 - unnamed */
DO:
    RUN loadFromSlot (10).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_11
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_11 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_11 /* Slot 11 - unnamed */
DO:
    RUN saveToSlot (11).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_11_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_11_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_11_Load /* Slot 11 - unnamed */
DO:
    RUN loadFromSlot (11).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_12
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_12 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_12 /* Slot 12 - unnamed */
DO:
    RUN saveToSlot (12).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_12_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_12_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_12_Load /* Slot 12 - unnamed */
DO:
    RUN loadFromSlot (12).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_1_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_1_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_1_Load /* Slot 1 - unnamed */
DO:
    RUN loadFromSlot (1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_2 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_2 /* Slot 2 - unnamed */
DO:
    RUN saveToSlot (2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_2_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_2_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_2_Load /* Slot 2 - unnamed */
DO:
    RUN loadFromSlot (2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_3 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_3 /* Slot 3 - unnamed */
DO:
    RUN saveToSlot (3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_3_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_3_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_3_Load /* Slot 3 - unnamed */
DO:
    RUN loadFromSlot (3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_4 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_4 /* Slot 4 - unnamed */
DO:
    RUN saveToSlot (4).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_4_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_4_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_4_Load /* Slot 4 - unnamed */
DO:
    RUN loadFromSlot (4).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_5 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_5 /* Slot 5 - unnamed */
DO:
    RUN saveToSlot (5).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_5_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_5_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_5_Load /* Slot 5 - unnamed */
DO:
    RUN loadFromSlot (5).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_6 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_6 /* Slot 6 - unnamed */
DO:
    RUN saveToSlot (6).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_6_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_6_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_6_Load /* Slot 6 - unnamed */
DO:
    RUN loadFromSlot (6).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_7 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_7 /* Slot 7 - unnamed */
DO:
    RUN saveToSlot (7).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_7_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_7_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_7_Load /* Slot 7 - unnamed */
DO:
    RUN loadFromSlot (7).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_8
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_8 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_8 /* Slot 8 - unnamed */
DO:
    RUN saveToSlot (8).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_8_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_8_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_8_Load /* Slot 8 - unnamed */
DO:
    RUN loadFromSlot (8).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_9
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_9 C-Win
ON CHOOSE OF MENU-ITEM m_Slot_9 /* Slot 9 - unnamed */
DO:
    RUN saveToSlot (9).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slot_9_Load
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slot_9_Load C-Win
ON CHOOSE OF MENU-ITEM m_Slot_9_Load /* Slot 9 - unnamed */
DO:
    RUN loadFromSlot (9).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rectOptions
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rectOptions C-Win
ON MOUSE-SELECT-CLICK OF rectOptions IN FRAME DEFAULT-FRAME
DO:
    /* when the user clicks on the Watermark or Overlay labels, toggle the corresponding toggle boxes */
    IF LAST-EVENT:X > toWatermark:X + toWatermark:WIDTH-PIXELS
        AND LAST-EVENT:X <= ghWatermarkLabel:X + ghWatermarkLabel:WIDTH-PIXELS
        AND LAST-EVENT:Y >= ghWatermarkLabel:Y
        AND LAST-EVENT:Y <= ghWatermarkLabel:Y + ghWatermarkLabel:HEIGHT-PIXELS THEN DO:
            ASSIGN toWatermark.
            toWatermark:SCREEN-VALUE = STRING(NOT toWatermark).
            ASSIGN toWatermark.
            APPLY "VALUE-CHANGED" TO toWatermark.
            RETURN.
    END.
    IF LAST-EVENT:X > toOverlay:X + toOverlay:WIDTH-PIXELS
        AND LAST-EVENT:X <= ghOverlayLabel:X + ghOverlayLabel:WIDTH-PIXELS
        AND LAST-EVENT:Y >= ghOverlayLabel:Y
        AND LAST-EVENT:Y <= ghOverlayLabel:Y + ghOverlayLabel:HEIGHT-PIXELS THEN DO:
            ASSIGN toOverlay.
            toOverlay:SCREEN-VALUE = STRING(NOT toOverlay).
            ASSIGN toOverlay.
            APPLY "VALUE-CHANGED" TO toOverlay.
            RETURN.
    END.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toFooter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toFooter C-Win
ON VALUE-CHANGED OF toFooter IN FRAME DEFAULT-FRAME /* Page footer */
DO:
    toFooterSep:SENSITIVE = SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toHeader
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toHeader C-Win
ON VALUE-CHANGED OF toHeader IN FRAME DEFAULT-FRAME /* Page header */
DO:
    toHeaderSep:SENSITIVE    = SELF:CHECKED.
    toAuthorHeader:SENSITIVE = SELF:CHECKED.
    toTitleHeader:SENSITIVE  = SELF:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toOverlay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toOverlay C-Win
ON VALUE-CHANGED OF toOverlay IN FRAME DEFAULT-FRAME
DO:
    ASSIGN
     fiOverlay:SENSITIVE        = SELF:CHECKED
     btnChooseOverlay:SENSITIVE = SELF:CHECKED
     .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toWatermark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toWatermark C-Win
ON VALUE-CHANGED OF toWatermark IN FRAME DEFAULT-FRAME
DO:
    ASSIGN
     fiPdfWatermark:SENSITIVE = SELF:CHECKED
     coWMFont:SENSITIVE       = SELF:CHECKED
     fiFontSize:SENSITIVE     = SELF:CHECKED
     fiAngle:SENSITIVE        = SELF:CHECKED
     .
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
    RUN initialize.
    RUN loadSettings.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addFile C-Win 
PROCEDURE addFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER cFile      AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER iPageCount AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER cPdfId     AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cPath  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cType  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cValue AS CHARACTER   NO-UNDO.

DEFINE BUFFER bttPdfFiles FOR ttPdfFiles.

RUN statusBar ("Parsing PDF file" + QUOTER(cFile), "info").
PROCESS EVENTS.
giNbFiles = giNbFiles + 1.
giFileId = giFileId + 1.
FIND FIRST bttPdfFiles WHERE bttPdfFiles.file_name = cFile NO-ERROR.
IF AVAILABLE bttPdfFiles THEN ASSIGN
    iPageCount = bttPdfFiles.page_count
    cPdfId = STRING(bttPdfFiles.id, "999").
ELSE DO:
    cPdfId = STRING(giFileId, "999").
    RUN loadPdfFile(cFile, cPdfId, OUTPUT iPageCount).
END.
IF iPageCount = ? THEN DO:
    RUN statusBar ("Error when parsing the PDF file", "error").
    RETURN.
END.
CREATE ttPdfFiles.
ASSIGN
    ttPdfFiles.file_name     = cFile
    ttPdfFiles.id            = INTEGER(cPdfId)
    ttPdfFiles.order         = giNbFiles
    ttPdfFiles.pages_to_copy = "1-" + STRING(iPageCount)
    ttPdfFiles.page_count    = iPageCount
    .

{&OPEN-QUERY-brPdfFiles}

QUERY brPdfFiles:REPOSITION-TO-ROW(giNbFiles).
BROWSE brPdfFiles:SELECT-FOCUSED-ROW().

DO WITH FRAME {&FRAME-NAME}:
    brPdfFiles:MODIFIED = YES.
END.

RUN statusBar ("The PDF file has been added.", "info").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeSlot C-Win 
PROCEDURE changeSlot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER piSlot AS INTEGER     NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    fiSlot = piSlot.
    DISPLAY fiSlot.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteSlot C-Win 
PROCEDURE deleteSlot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSlotPrefix AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lButton     AS LOGICAL     NO-UNDO.
    
IF getModifiedStatus() THEN DO:
    MESSAGE "Some changes have not been saved!~n~nAre you sure you want to delete the current settings?"
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO TITLE "Delete settings?" SET lButton.
    IF NOT lButton THEN RETURN.
END.

cSlotPrefix = STRING(fiSlot, "99") + "-".

/* 09-DEC-2014 jcc: save last used parameters in the registry */
LOAD 'Software\PSC\PROGRESS\JCCTools' BASE-KEY 'HKEY_CURRENT_USER' NO-ERROR.
/* create it if it does not exist  ... well, would be surprising...*/
IF ERROR-STATUS:ERROR THEN LOAD 'Software\PSC\PROGRESS\JCCTools' NEW BASE-KEY 'HKEY_CURRENT_USER' NO-ERROR.
IF NOT ERROR-STATUS:ERROR THEN USE 'Software\PSC\PROGRESS\JCCTools'.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Author"       VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "AuthorHeader" VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Title"        VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "TitleHeader"  VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Subject"      VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Keywords"     VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Header"       VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "HeaderSep"    VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Footer"       VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "FooterSep"    VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Watermark"    VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "PdfWatermark" VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "WMFont"       VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "FontSize"     VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Angle"        VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Overlay"      VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "OverlayName"  VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "PdfFileName"  VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Compress"     VALUE ?.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "SlotName"     VALUE ?.

DEFINE VARIABLE cField    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cValue    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hBuffer   AS HANDLE      NO-UNDO.
DEFINE VARIABLE i         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLine     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNbFields AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNbValues AS INTEGER     NO-UNDO.
DEFINE VARIABLE j         AS INTEGER     NO-UNDO.

GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "nbSourceFiles" VALUE cValue.
IF cValue > "" THEN iNbValues = INTEGER(cValue).
hBuffer = TEMP-TABLE ttPdfFiles:DEFAULT-BUFFER-HANDLE.
iNbFields = hBuffer:NUM-FIELDS.
/* delete all keys */
DO i = 1 TO iNbValues:
    DO j = 1 TO iNbFields:
        cField = hBuffer:BUFFER-FIELD(j):NAME.
        PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + cField + "-" + STRING(i, "99") VALUE ?.
    END.
END.

PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "nbSourceFiles" VALUE ?.

PUT-KEY-VALUE SECTION "pdfinctk" KEY "lastSlot" VALUE STRING(fiSlot).

RUN loadMenus.

UNLOAD 'Software\PSC\PROGRESS\JCCTools' NO-ERROR.

EMPTY TEMP-TABLE ttPdfFiles.

RUN resetModifiedStatus. /* so that loadFromSlot does not ask confirmation to the user */

RUN loadFromSlot (fiSlot). /* reload settings to clear the widgets */

RUN statusBar ("Deleted slot settings " + STRING(fiSlot) + " - " + fiSlotName, "").

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
  DISPLAY fiTotalPages fiAuthor toAuthorHeader fiTitle toTitleHeader fiSubject 
          fiKeywords toHeader toHeaderSep toCompress toFooter toFooterSep 
          toWatermark fiPdfWatermark coWMFont fiFontSize fiAngle toOverlay 
          fiOverlay fiSlot fiSlotName fiPdfFileName fiStatusBar txBrowseTooltip 
          txFileDescription txOptionalEnhancements 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rectDescription rectOptions btnAddPdf brPdfFiles btnMoveUp btnMoveDown 
         btnFileDetails btnRemovePdf fiAuthor toAuthorHeader btnAbout fiTitle 
         toTitleHeader fiSubject fiKeywords toHeader toHeaderSep toCompress 
         toFooter toFooterSep toWatermark fiPdfWatermark coWMFont fiFontSize 
         fiAngle toOverlay fiOverlay btnChooseOverlay btnSaveSettings 
         btnSaveSettings2 fiSlotName btnGenerate fiPdfFileName btnChoosePdfFile 
         btnClose fiStatusBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generatePdf C-Win 
PROCEDURE generatePdf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cEntry AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPdfId AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTitle AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFrom  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPage  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTitle AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTo    AS INTEGER     NO-UNDO.
DEFINE VARIABLE j      AS INTEGER     NO-UNDO.

DEFINE BUFFER bttPdfFiles FOR ttPdfFiles.

SESSION:SET-WAIT-STATE("GENERAL").
RUN statusBar ("Generating PDF file...", "info").
PROCESS EVENTS.

RUN pdf_new("s", fiPdfFileName).
RUN pdf_set_parameter("s", "reuseExternal", "TRUE").
RUN pdf_set_parameter("s", "compress", STRING(toCompress, "TRUE/FALSE")).
/* RUN pdf_set_parameter("s", "formFlatten", ""). /* keep the forms as is */ */
RUN pdf_set_parameter("s", "retainAnnots", "*"). /* keep all annotations  */

RUN pdf_set_parameter("s", "headerSeparator", STRING(toHeaderSep, "TRUE/FALSE")).
RUN pdf_set_parameter("s", "footerSeparator", STRING(toFooterSep, "TRUE/FALSE")).

RUN pdf_set_info("s", "Producer", "PDFInclude toolkit").
RUN pdf_set_info("s", "Author", fiAuthor).
RUN pdf_set_info("s", "Title", fiTitle).
RUN pdf_set_info("s", "Subject", fiSubject).
RUN pdf_set_info("s", "Keywords", fiKeywords).

RUN pdf_set_topMargin("s", 40). /* for the header separator line */
RUN pdf_set_bottomMargin("s", 10). /* for the footer */

/* 05-DEC-2014 jcc: cannot use the defaultHeader parameter, because pdf_use_pdf_page will change the page size */
/* IF toHeader THEN RUN pdf_set_parameter("s", "defaultHeader", "TRUE"). */
/* IF toFooter THEN RUN pdf_set_parameter("s", "defaultFooter", "TRUE"). */

IF fiOverlay > "" THEN RUN pdf_open_pdf("s", fiOverlay, ENCODE(fiOverlay)).

FOR EACH bttPdfFiles BY bttPdfFiles.order:
    cPdfId = STRING(bttPdfFiles.id, "999").
    iTitle = 0.
    /* RUN pdf_open_pdf("s", bttPdfFiles.file_name, cPdfId). /* 03-DEC-2014 jcc: useless: when we use "reuseExternal", we reuse the result from the very first call to pdf_open_pdf */ */
    DO i = 1 TO NUM-ENTRIES(bttPdfFiles.pages_to_copy):
        cEntry = ENTRY(i, bttPdfFiles.pages_to_copy).
        iFrom = IF ENTRY(1, cEntry, "-") = "" THEN 1 ELSE INTEGER(ENTRY(1, cEntry, "-")).
        iTo = IF NUM-ENTRIES(cEntry, "-") > 1
              THEN (IF ENTRY(2, cEntry, "-") = "" THEN bttPdfFiles.page_count ELSE INTEGER(ENTRY(2, cEntry, "-")))
              ELSE iFrom.
        DO j = iFrom TO iTo:
            iPage = iPage + 1.
            RUN statusBar ("Generating PDF file... Page " + STRING(iPage), "info").
            RUN pdf_set_pagerotate("s", bttPdfFiles.pageRotate).
            RUN pdf_new_page("s").
            RUN pdf_set_parameter("s", "UseExternalPageSize", "TRUE").
            RUN pdf_use_pdf_page2("s", "p" + STRING(fiSlot,"99") + cPdfId, j, "Rotate=" + STRING(bttPdfFiles.rotateInPage)). /* will change the page size according to the external file page size */
            RUN pdf_set_parameter("s", "UseExternalPageSize", "FALSE"). /* 15-DEC-2014 jcc: must set this parameter to false for the overlay, else we are going to use the overlay's page size! */
            IF toOverlay AND fiOverlay > "" THEN RUN pdf_use_pdf_page("s", ENCODE(fiOverlay), 1).
            IF toWatermark AND fiPdfWatermark > "" THEN DO:
                DEFINE VARIABLE cFont AS CHARACTER   NO-UNDO.
                cFont = coWMFont.
                IF INDEX(cFont, " ") > 0 THEN
                    SUBSTRING(cFont, INDEX(cFont, " ")) = "-".
                cFont = REPLACE(cFont, " ", "").
                RUN pdf_set_font("s", cFont, fiFontSize).
                RUN pdf_text_color("s", .6, .6, .6).
                RUN pdf_set_textXY("s", pdf_LeftMargin("s") * 2, 12, NO).
                RUN pdf_text_rotate("s", fiAngle).
                RUN pdf_text("s", fiPdfWatermark).
                RUN pdf_text_rotate("s", 0).
            END.
            /* 05-DEC-2014 jcc: trigger manually the default header and footer */
            IF bttPdfFiles.pageTitle > "" THEN DO:
                iTitle = iTitle + 1. cTitle = "".
                cTitle = IF INDEX(bttPdfFiles.pageTitle, ";") > 0
                         THEN ENTRY(MINIMUM(iTitle,NUM-ENTRIES(bttPdfFiles.pageTitle, ";")),bttPdfFiles.pageTitle,";")
                         ELSE bttPdfFiles.pageTitle NO-ERROR.
                RUN pdf_set_parameter("s", "headerLine1", (IF toTitleHeader THEN fiTitle + " - " ELSE "") + cTitle).
            END.
            ELSE
                RUN pdf_set_parameter("s", "headerLine1", IF toTitleHeader THEN fiTitle ELSE ?).
            RUN pdf_set_parameter("s", "headerLine2", IF toAuthorHeader THEN "" ELSE ?).
            IF toHeader THEN RUN pdf_default_header("s").
            IF toFooter THEN RUN pdf_default_footer("s").
        END.
    END.
END.

RUN statusBar ("Generating PDF file... Writing file (" + STRING(iPage) + ") pages.", "info").
RUN pdf_close("s") NO-ERROR.
IF RETURN-VALUE > "" THEN
    MESSAGE "Error(s) while generating the PDF file:" SKIP RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

RUN statusBar ("PDF file generated.", "info").
SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCurrentRecord C-Win 
PROCEDURE getCurrentRecord :
/*------------------------------------------------------------------------------
  Purpose:     send the current ttPdfFiles buffer to the dialog box
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE PARAMETER BUFFER pttPdfFiles FOR ttPdfFiles.

FIND FIRST pttPdfFiles WHERE ROWID(pttPdfFiles) = ROWID(ttPdfFiles).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize C-Win 
PROCEDURE initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBrColumn AS HANDLE      NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
     ghWatermarkLabel = fiPdfWatermark:SIDE-LABEL-HANDLE
     ghOverlayLabel   = fiOverlay:SIDE-LABEL-HANDLE.
    
    C-Win:MIN-WIDTH-PIXELS  = txBrowseTooltip:X + txBrowseTooltip:WIDTH-PIXELS + 2.
    C-Win:MIN-HEIGHT-PIXELS = C-Win:HEIGHT-PIXELS.
    
    hBrColumn = brPdfFiles:GET-BROWSE-COLUMN(1).
    hBrColumn:WIDTH = 90.
    hBrColumn = brPdfFiles:GET-BROWSE-COLUMN(4).
    hBrColumn:WIDTH = 14.
    
    hBrColumn = brPdfFiles:GET-BROWSE-COLUMN(brPdfFiles:NUM-COLUMNS).
    giLastBrowseColumnWidth = hBrColumn:WIDTH-PIXELS.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadFromSlot C-Win 
PROCEDURE loadFromSlot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER piSlot AS INTEGER     NO-UNDO.

DEFINE BUFFER bttPdfFiles FOR ttPdfFiles.

DEFINE VARIABLE cSlotPrefix AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cValue      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iDummy      AS INTEGER     NO-UNDO.
DEFINE VARIABLE lButton     AS LOGICAL     NO-UNDO.

IF getModifiedStatus() THEN DO:
    MESSAGE "Some changes have not been saved!~n~nAre you sure you want to load other settings?"
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO TITLE "Load settings?" SET lButton.
    IF NOT lButton THEN RETURN.
END.

IF piSlot <> fiSlot THEN
    RUN changeSlot (piSlot).

cSlotPrefix = STRING(piSlot, "99") + "-".

LOAD 'Software\PSC\PROGRESS\JCCTools' BASE-KEY 'HKEY_CURRENT_USER' NO-ERROR.
IF NOT ERROR-STATUS:ERROR THEN USE 'Software\PSC\PROGRESS\JCCTools'.

DO WITH FRAME {&FRAME-NAME}:
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Author"       VALUE cValue.
    IF cValue = ? THEN fiAuthor = "". ELSE fiAuthor = cValue.
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "AuthorHeader" VALUE cValue.
    IF cValue = ? THEN toAuthorHeader = NO. ELSE toAuthorHeader = LOGICAL(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Title"        VALUE cValue.
    IF cValue = ? THEN fiTitle = "". ELSE fiTitle = cValue.
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "TitleHeader"  VALUE cValue.
    IF cValue = ? THEN toTitleHeader = NO. ELSE toTitleHeader = LOGICAL(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Subject"      VALUE cValue.
    IF cValue = ? THEN fiSubject = "". ELSE fiSubject = cValue.
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Keywords"     VALUE cValue.
    IF cValue = ? THEN fiKeywords = "". ELSE fiKeywords = cValue.
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Header"       VALUE cValue.
    IF cValue = ? THEN toHeader = NO. ELSE toHeader = LOGICAL(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "HeaderSep"    VALUE cValue.
    IF cValue = ? THEN toHeaderSep = NO. ELSE toHeaderSep = LOGICAL(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Footer"       VALUE cValue.
    IF cValue = ? THEN toFooter = NO. ELSE toFooter = LOGICAL(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "FooterSep"    VALUE cValue.
    IF cValue = ? THEN toFooterSep = NO. ELSE toFooterSep = LOGICAL(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Watermark"    VALUE cValue.
    IF cValue = ? THEN toWatermark = NO. ELSE toWatermark = LOGICAL(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "PdfWatermark" VALUE cValue.
    IF cValue = ? THEN fiPdfWatermark = "". ELSE fiPdfWatermark = cValue.
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "WMFont"       VALUE cValue.
    IF cValue = ? THEN coWMFont = "Helvetica". ELSE coWMFont = cValue.
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "FontSize"     VALUE cValue.
    IF cValue = ? THEN fiFontSize = 10. ELSE fiFontSize = DECIMAL(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Angle"        VALUE cValue.
    IF cValue = ? THEN fiAngle = 45. ELSE fiAngle = INTEGER(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Overlay"      VALUE cValue.
    IF cValue = ? THEN toOverlay = NO. ELSE toOverlay = LOGICAL(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "OverlayName"  VALUE cValue.
    IF cValue = ? THEN fiOverlay = "". ELSE fiOverlay = cValue.
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "PdfFileName"  VALUE cValue.
    IF cValue = ? THEN fiPdfFileName = "". ELSE fiPdfFileName = cValue.
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Compress"     VALUE cValue.
    IF cValue = ? THEN toCompress = YES. ELSE toCompress = LOGICAL(cValue).
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "SlotName"     VALUE cValue.
    IF cValue = ? THEN fiSlotName = "unnamed". ELSE fiSlotName = cValue.

    /* fill ttPdfFiles */
    DEFINE VARIABLE cField      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE hBuffer     AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i           AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNbSrcFiles AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j           AS INTEGER     NO-UNDO.

    EMPTY TEMP-TABLE ttPdfFiles.

    hBuffer = TEMP-TABLE ttPdfFiles:DEFAULT-BUFFER-HANDLE.
    GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "nbSourceFiles" VALUE cValue.
    IF cValue > "" THEN iNbSrcFiles = INTEGER(cValue).
    DO i = 1 TO iNbSrcFiles:
        hBuffer:BUFFER-CREATE().
        DO j = 1 TO hBuffer:NUM-FIELDS:
            cField = hBuffer:BUFFER-FIELD(j):NAME.
            GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + cField + "-" + STRING(i, "99") VALUE cValue.
            IF cValue <> ? THEN
                hBuffer:BUFFER-FIELD(j):BUFFER-VALUE = cValue.
        END.
    END.

    {&OPEN-QUERY-brPdfFiles}
    DISPLAY {&DISPLAYED-OBJECTS}.

    /* 06-MAR-2015 jcc: set a color to the not loaded files to provide visual feedback to the user */
    DEFINE VARIABLE iRow AS INTEGER     NO-UNDO.
    FOR EACH ttPdfFiles:
        iRow = iRow + 1.
        RUN setBrowseRowColor (iRow, 9).
    END.
    brPdfFiles:SELECT-ROW(1) NO-ERROR.

    RUN sensitizeWidgets.
END.

UNLOAD 'Software\PSC\PROGRESS\JCCTools' NO-ERROR.

/* Load the pdf files if necessary */
DEFINE VARIABLE iPageCount AS INTEGER   NO-UNDO.
ASSIGN
 iRow      = 0
 giNbFiles = 0.
SESSION:SET-WAIT-STATE("GENERAL").
FOR EACH bttPdfFiles:
    ASSIGN
     iRow      = iRow + 1
     giNbFiles = giNbFiles + 1.
    brPdfFiles:SELECT-ROW(iRow).
    IF CAN-FIND(ttPdfAdded WHERE ttPdfAdded.slot = fiSlot AND ttPdfAdded.pdfId = bttPdfFiles.id) THEN DO:
        RUN setBrowseRowColor (iRow, ?).
        NEXT.
    END.
    IF SEARCH(bttPdfFiles.file_name) = ? THEN
        RUN statusBar (bttPdfFiles.file_name + " not found!", "error").
    ELSE DO:
        RUN statusBar ("Parsing PDF file" + QUOTER(bttPdfFiles.file_name), "info").
        PROCESS EVENTS.
        RUN loadPDFFile (bttPdfFiles.file_name, STRING(bttPdfFiles.id, "999"), OUTPUT iPageCount).
        IF iPageCount = ? THEN
            RUN statusBar ("Error when parsing the PDF file", "error").
        RUN setBrowseRowColor (iRow, ?).
        PROCESS EVENTS.
    END.
END.
brPdfFiles:SELECT-ROW(1) NO-ERROR.
RUN updateTotalPages.

RUN resetModifiedStatus.

SESSION:SET-WAIT-STATE("").

RUN statusBar ("Loaded settings from slot " + STRING(fiSlot) + " - " + fiSlotName, "").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadMenu C-Win 
PROCEDURE loadMenu :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phMenuItem AS HANDLE      NO-UNDO.

DEFINE VARIABLE cValue    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iSlotNum  AS INTEGER     NO-UNDO.

DO WHILE VALID-HANDLE(phMenuItem):
    iSlotNum = INTEGER(ENTRY(2, ENTRY(1, phMenuItem:LABEL, "-"), " ")).
    GET-KEY-VALUE SECTION "pdfinctk" KEY STRING(iSlotNum, "99") + "-" + "SlotName" VALUE cValue.
    phMenuItem:LABEL = "Slot " + STRING(iSlotNum) + " - " + IF cValue > "" THEN cValue ELSE "free".
    phMenuItem = phMenuItem:NEXT-SIBLING.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadMenus C-Win 
PROCEDURE loadMenus :
/*------------------------------------------------------------------------------
  Purpose:     update menu labels: slots' name
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN loadMenu(MENU m_Load_Slot:FIRST-CHILD).

RUN loadMenu(MENU m_Save_As:FIRST-CHILD).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadPDFFile C-Win 
PROCEDURE loadPDFFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFile      AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcPdfId     AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER piPageCount AS INTEGER     NO-UNDO.

DEFINE BUFFER ttPdfAdded FOR ttPdfAdded.

RUN pdf_new("s", ?).
RUN pdf_set_parameter("s", "reuseExternal", "TRUE").
RUN pdf_open_pdf("s", pcFile, "p" + STRING(fiSlot,"99") + pcPdfId).
RUN pdf_ext_get_nb_pages("s", "p" + STRING(fiSlot,"99") + pcPdfId, OUTPUT piPageCount).
RUN pdf_close("s") NO-ERROR.
IF RETURN-VALUE > "" THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
CREATE ttPdfAdded.
ASSIGN
 ttPdfAdded.slot = fiSlot
 ttPdfAdded.pdfId = INTEGER(pcPdfId).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadSettings C-Win 
PROCEDURE loadSettings :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cValue      AS CHARACTER   NO-UNDO.

/* create it if it does not exist  ... well, would be surprising...*/
LOAD 'Software\PSC\PROGRESS\JCCTools' BASE-KEY 'HKEY_CURRENT_USER' NO-ERROR.
IF ERROR-STATUS:ERROR THEN LOAD 'Software\PSC\PROGRESS\JCCTools' NEW BASE-KEY 'HKEY_CURRENT_USER' NO-ERROR.
IF NOT ERROR-STATUS:ERROR THEN USE 'Software\PSC\PROGRESS\JCCTools'.

GET-KEY-VALUE SECTION "pdfinctk" KEY "lastSlot" VALUE cValue.
IF cValue > "" THEN fiSlot = INTEGER(cValue). ELSE fiSlot = 1.

/* update menu items */
RUN loadMenus.

UNLOAD 'Software\PSC\PROGRESS\JCCTools' NO-ERROR.

/* finally load the setting from last used slot */
RUN loadFromSlot (fiSlot).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openPropertiesDialog C-Win 
PROCEDURE openPropertiesDialog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iOrder    AS INTEGER   NO-UNDO.
DEFINE VARIABLE lModified AS LOGICAL   NO-UNDO.

IF NOT AVAILABLE ttPdfFiles THEN RETURN ERROR.

iOrder = ttPdfFiles.order.
RUN utilities/concat/pdftk-dlg.w(THIS-PROCEDURE, OUTPUT lModified).

{&OPEN-QUERY-brPdfFiles}
BROWSE brPdfFiles:SELECT-ROW(iOrder).
RUN updateTotalPages.

DO WITH FRAME {&FRAME-NAME}:
    brPdfFiles:MODIFIED = brPdfFiles:MODIFIED OR lModified.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetModifiedStatus C-Win 
PROCEDURE resetModifiedStatus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hWidget AS HANDLE      NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    hWidget = FRAME {&FRAME-NAME}:FIRST-CHILD:FIRST-CHILD.
    DO WHILE VALID-HANDLE(hWidget):
        IF LOOKUP(hWidget:NAME, "{&DISPLAYED-OBJECTS}", " ") > 0 THEN
            hWidget:MODIFIED = NO.
        hWidget = hWidget:NEXT-SIBLING.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveSettings C-Win 
PROCEDURE saveSettings :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSlotPrefix AS CHARACTER   NO-UNDO.
    
DO WITH FRAME {&FRAME-NAME}:
    /* ASSIGN fiAuthor toAuthorHeader fiTitle toTitleHeader fiSubject fiKeywords toHeader toHeaderSep toFooter toFooterSep toWatermark fiPdfWatermark coWMFont fiFontSize fiAngle toOverlay fiOverlay fiPdfFileName toCompress fiSlotName. */
    ASSIGN {&DISPLAYED-OBJECTS}.
END.

cSlotPrefix = STRING(fiSlot, "99") + "-".

/* 09-DEC-2014 jcc: save last used parameters in the registry */
LOAD 'Software\PSC\PROGRESS\JCCTools' BASE-KEY 'HKEY_CURRENT_USER' NO-ERROR.
/* create it if it does not exist  ... well, would be surprising...*/
IF ERROR-STATUS:ERROR THEN LOAD 'Software\PSC\PROGRESS\JCCTools' NEW BASE-KEY 'HKEY_CURRENT_USER' NO-ERROR.
IF NOT ERROR-STATUS:ERROR THEN USE 'Software\PSC\PROGRESS\JCCTools'.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Author"       VALUE fiAuthor.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "AuthorHeader" VALUE STRING(toAuthorHeader).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Title"        VALUE fiTitle.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "TitleHeader"  VALUE STRING(toTitleHeader).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Subject"      VALUE fiSubject.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Keywords"     VALUE fiKeywords.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Header"       VALUE STRING(toHeader).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "HeaderSep"    VALUE STRING(toHeaderSep).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Footer"       VALUE STRING(toFooter).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "FooterSep"    VALUE STRING(toFooterSep).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Watermark"    VALUE STRING(toWatermark).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "PdfWatermark" VALUE fiPdfWatermark.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "WMFont"       VALUE coWMFont.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "FontSize"     VALUE STRING(fiFontSize).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Angle"        VALUE STRING(fiAngle).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Overlay"      VALUE STRING(toOverlay).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "OverlayName"  VALUE fiOverlay.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "PdfFileName"  VALUE fiPdfFileName.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "Compress"     VALUE STRING(toCompress).
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "SlotName"     VALUE fiSlotName.

/* 04-MAR-2015 jcc: also save ttPdfFiles contents */
DEFINE VARIABLE cField    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cValue    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hBuffer   AS HANDLE      NO-UNDO.
DEFINE VARIABLE i         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLine     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNbFields AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNbValues AS INTEGER     NO-UNDO.
DEFINE VARIABLE j         AS INTEGER     NO-UNDO.

GET-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "nbSourceFiles" VALUE cValue.
IF cValue > "" THEN iNbValues = INTEGER(cValue).
hBuffer = TEMP-TABLE ttPdfFiles:DEFAULT-BUFFER-HANDLE.
iNbFields = hBuffer:NUM-FIELDS.
/* delete all keys */
DO i = 1 TO iNbValues:
    DO j = 1 TO iNbFields:
        cField = hBuffer:BUFFER-FIELD(j):NAME.
        PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + cField + "-" + STRING(i, "99") VALUE ?.
    END.
END.

/* save the table contents */
iLine = 0.
FOR EACH ttPdfFiles:
    iLine = iLine + 1.
    DO j = 1 TO iNbFields:
        cField = hBuffer:BUFFER-FIELD(j):NAME.
        PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + cField + "-" + STRING(iLine, "99") VALUE hBuffer:BUFFER-FIELD(j):BUFFER-VALUE.
    END.
END.
PUT-KEY-VALUE SECTION "pdfinctk" KEY cSlotPrefix + "nbSourceFiles" VALUE STRING(iLine).

PUT-KEY-VALUE SECTION "pdfinctk" KEY "lastSlot" VALUE STRING(fiSlot).

RUN resetModifiedStatus.

/* update menus (if the slot name has changed) */
RUN loadMenus.

UNLOAD 'Software\PSC\PROGRESS\JCCTools' NO-ERROR.

RUN statusBar ("Saved settings to slot " + STRING(fiSlot) + " - " + fiSlotName, "").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveToSlot C-Win 
PROCEDURE saveToSlot :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER piSlot AS INTEGER     NO-UNDO.

RUN changeSlot (piSlot).

RUN saveSettings.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sensitizeWidgets C-Win 
PROCEDURE sensitizeWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
     toHeaderSep:SENSITIVE      = toHeader:CHECKED
     toAuthorHeader:SENSITIVE   = toHeader:CHECKED
     toTitleHeader:SENSITIVE    = toHeader:CHECKED
     toFooterSep:SENSITIVE      = toFooter:CHECKED
     fiPdfWatermark:SENSITIVE   = toWatermark:CHECKED
     coWMFont:SENSITIVE         = toWatermark:CHECKED
     fiFontSize:SENSITIVE       = toWatermark:CHECKED
     fiAngle:SENSITIVE          = toWatermark:CHECKED
     fiOverlay:SENSITIVE        = toOverlay:CHECKED
     btnChooseOverlay:SENSITIVE = toOverlay:CHECKED
     .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBrowseRowColor C-Win 
PROCEDURE setBrowseRowColor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piRow   AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER piColor AS INTEGER   NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    brPdfFiles:SELECT-ROW(piRow).
    brPdfFiles:GET-BROWSE-COLUMN(1):FGCOLOR = piColor.
    brPdfFiles:GET-BROWSE-COLUMN(2):FGCOLOR = piColor.
    brPdfFiles:GET-BROWSE-COLUMN(3):FGCOLOR = piColor.
    brPdfFiles:GET-BROWSE-COLUMN(4):FGCOLOR = piColor.
    brPdfFiles:GET-BROWSE-COLUMN(5):FGCOLOR = piColor.
    brPdfFiles:GET-BROWSE-COLUMN(6):FGCOLOR = piColor.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE statusBar C-Win 
PROCEDURE statusBar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcMessage AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pcType    AS CHARACTER   NO-UNDO.

    fiStatusBar:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcMessage.

    IF pcType = "error" THEN
        fiStatusBar:FGCOLOR = 12.
    ELSE
        fiStatusBar:FGCOLOR = 0.

    /* Also log the message in the window's message area */
    MESSAGE pcMessage.

    /* STATUS DEFAULT pcMessage IN WINDOW {&WINDOW-NAME}. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateTotalPages C-Win 
PROCEDURE updateTotalPages :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cEntry AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFrom  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPages AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTo    AS INTEGER     NO-UNDO.

DEFINE BUFFER bttPdfFiles FOR ttPdfFiles.

FOR EACH bttPdfFiles:
    DO i = 1 TO NUM-ENTRIES(bttPdfFiles.pages_to_copy):
        ASSIGN
         cEntry = ENTRY(i, bttPdfFiles.pages_to_copy).
         iFrom = IF ENTRY(1, cEntry, "-") = "" THEN 1 ELSE INTEGER(ENTRY(1, cEntry, "-")).
         iTo = IF NUM-ENTRIES(cEntry, "-") > 1
               THEN (IF ENTRY(2, cEntry, "-") = "" THEN bttPdfFiles.page_count ELSE INTEGER(ENTRY(2, cEntry, "-")))
               ELSE iFrom.
         iPages = iPages + iTo - iFrom + 1.
    END.
END.

DO WITH FRAME {&FRAME-NAME}:
    fiTotalPages = iPages.
    DISPLAY fiTotalPages.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getModifiedStatus C-Win 
FUNCTION getModifiedStatus RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hWidget   AS HANDLE    NO-UNDO.
DEFINE VARIABLE iWidget   AS INTEGER   NO-UNDO.
DEFINE VARIABLE lModified AS LOGICAL   NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
    hWidget = FRAME {&FRAME-NAME}:FIRST-CHILD:FIRST-CHILD.
    DO WHILE VALID-HANDLE(hWidget):
        iWidget = LOOKUP(hWidget:NAME, "{&DISPLAYED-OBJECTS}", " ").
        IF iWidget <> 0 AND hWidget:TYPE <> "LITERAL" AND hWidget:NAME <> "fiStatusBar" AND hWidget:MODIFIED THEN
            RETURN TRUE.
        hWidget = hWidget:NEXT-SIBLING.
    END.
END.

IF brPdfFiles:MODIFIED THEN RETURN TRUE.

RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION quitApplication C-Win 
FUNCTION quitApplication RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE lButton AS LOGICAL     NO-UNDO.

IF getModifiedStatus() THEN DO:
    MESSAGE "Some changes have not been saved!~n~nAre you sure you want to quit?"
        VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO TITLE "Quit without saving?" SET lButton.
    IF NOT lButton THEN RETURN FALSE.
END.

QUIT. /* 09-MAR-2015 jcc: we want to quit the application! */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

