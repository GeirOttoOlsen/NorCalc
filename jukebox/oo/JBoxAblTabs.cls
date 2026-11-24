 
 /*------------------------------------------------------------------------
    File        : JBoxAblTabs
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : brynj
    Created     : Fri Aug 09 09:44:06 CEST 2024
    Notes       :  folder.p
                 16.10.01 JKO
                 Basert på Progress' src/adm2/folder.w
              
                 Mye forandret. Ikke lenger avhengig av ADM.
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxAblTabs: 

  DEF TEMP-TABLE ttTab NO-UNDO 
      FIELD hProgram     AS HANDLE
      FIELD hFrame       AS HANDLE  
      FIELD iTab#        AS INT 
      FIELD cProgramName AS CHAR 
      FIELD cLabel       AS CHAR 
      FIELD cImage       AS CHAR 
      FIELD hPageQuery   AS HANDLE /* handle for browse or query on tab-page - 1st come 1st serve */
      INDEX idxTab# IS PRIMARY UNIQUE iTab#
      .

  DEF VAR hHelperProc AS HANDLE NO-UNDO.
  
  DEF PUBLIC PROPERTY TAB-FRAME-HANDLE AS HANDLE NO-UNDO GET. PROTECTED SET.
  DEF PUBLIC PROPERTY TAB-AREA-HANDLE  AS HANDLE NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY hSourceProc      AS HANDLE NO-UNDO GET. PROTECTED SET.   
  DEF PUBLIC PROPERTY CONTAINER-OBJECT AS JBoxContainer NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY tagImage         AS CHAR NO-UNDO INIT "bmp\ok.bmp" GET. SET.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC JBoxAblTabs ( INPUT ihTabFrame AS HANDLE
                                  ,INPUT icFolderLabels AS CHAR
                                  ,INPUT icImageList AS CHAR ):
    SUPER ().
    
    ASSIGN hSourceProc = SOURCE-PROCEDURE
           TAB-FRAME-HANDLE = ihTabFrame
//           TAB-FRAME-HANDLE:PRIVATE-DATA = "tab-folder"
           .
    
    RUN JBoxAblTabsHelper.p PERSIST SET hHelperProc (THIS-OBJECT).

    RUN initializeFolder IN hHelperProc (hSourceProc,
                                         ihTabFrame,
                                         1, // 5,
                                         icFolderLabels,
                                         -1, // 17,   /* Font*/
                                         -1, // 16,   /* Font selected */ 
                                         18). /* TagWidgetWidth */

    /* publish to container-helper who finds container for ttProgram.hProgram and calls back to setTabPageContainer in hHelper: */
    PUBLISH "getContainerForProc" FROM hSourceProc (hSourceProc,hHelperProc,"setTabContainer"). /* find container for hSourceProc and call back to setTabPageContainer in hHelper */
    
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxAblTabs ( INPUT ihTabFrame AS HANDLE):
    SUPER ().
    
    ASSIGN hSourceProc = SOURCE-PROCEDURE
           TAB-FRAME-HANDLE = ihTabFrame
//           TAB-FRAME-HANDLE:PRIVATE-DATA = "tab-folder"
           .
    IF TAB-FRAME-HANDLE:BGCOLOR = 2 THEN TAB-FRAME-HANDLE:BGCOLOR = ?.       
    
    RUN JBoxAblTabsHelper.p PERSIST SET hHelperProc (THIS-OBJECT).

    RUN initializeFolder IN hHelperProc (hSourceProc,
                                         ihTabFrame,
                                         1, // 5,
                                         "",
                                         -1, // 17,   /* Font*/
                                         -1, // 16,   /* Font selected */ 
                                         18). /* TagWidgetWidth */
    
    /* publish to container-helper who finds container for ttProgram.hProgram and calls back to setTabPageContainer in hHelper: */
    PUBLISH "getContainerForProc" FROM hSourceProc (hSourceProc,hHelperProc,"setTabContainer"). /* find container for hSourceProc and call back to setTabPageContainer in hHelper */
    
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID AddPage(INPUT ihFrame AS HANDLE,INPUT icLabel AS CHAR,INPUT icImage AS CHAR):

    DEF VAR iNewTabNum AS INT NO-UNDO INIT 1.

    FIND LAST ttTab NO-ERROR.
    IF AVAIL ttTab THEN iNewTabNum = ttTab.iTab# + 1.
    
    CREATE ttTab.
    ASSIGN ttTab.iTab# = iNewTabNum
           ttTab.cLabel = icLabel
           ttTab.cImage = icImage
           ttTab.hFrame = ihFrame
           ihFrame:BGCOLOR = ?
           ihFrame:BOX = NO
           ihFrame:WIDTH-PIXELS = TAB-AREA-HANDLE:WIDTH-PIXELS - 2
           ihFrame:HEIGHT-PIXELS = TAB-FRAME-HANDLE:HEIGHT-PIXELS - TAB-AREA-HANDLE:Y - 4
           ihFrame:VIRTUAL-WIDTH-PIXELS = ihFrame:WIDTH-PIXELS
           ihFrame:VIRTUAL-HEIGHT-PIXELS = ihFrame:HEIGHT-PIXELS
           ihFrame:X = TAB-AREA-HANDLE:X + 1
           ihFrame:Y = TAB-AREA-HANDLE:Y + 2
           ihFrame:PRIVATE-DATA = "tab-folder"
           .
    
    
    RUN create-folder-label IN hHelperProc (iNewTabNum,icLabel).
    
    RUN SetFolderTag IN hHelperProc(iNewTabNum,icImage).

    DYNAMIC-FUNCTION("setNumPages" IN hHelperProc,iNewTabNum).
        
 //   DYNAMIC-FUNCTION("setWidgetResize",hSourceProc:CURRENT-WINDOW,ihFrame:FIRST-CHILD,"Adjust","").
  END METHOD.

  METHOD PUBLIC VOID resizePages (INPUT iDeltaX AS INT,INPUT iDeltaY AS INT):
    FOR EACH ttTab:
      ASSIGN ttTab.hFrame:WIDTH-PIXELS = TAB-AREA-HANDLE:WIDTH-PIXELS - 2
             ttTab.hFrame:HEIGHT-PIXELS = TAB-FRAME-HANDLE:HEIGHT-PIXELS - TAB-AREA-HANDLE:Y - 4
             ttTab.hFrame:VIRTUAL-WIDTH-PIXELS = ttTab.hFrame:WIDTH-PIXELS
             ttTab.hFrame:VIRTUAL-HEIGHT-PIXELS = ttTab.hFrame:HEIGHT-PIXELS
             ttTab.hFrame:X = TAB-AREA-HANDLE:X + 1
             ttTab.hFrame:Y = TAB-AREA-HANDLE:Y + 2
             .
      DYNAMIC-FUNCTION("setDeltaX",iDeltaX).
      DYNAMIC-FUNCTION("setDeltaY",iDeltaY).
      DYNAMIC-FUNCTION("setMinXYmove",DYNAMIC-FUNCTION("getWinMinXmove",ttTab.hFrame:WINDOW,"X"),DYNAMIC-FUNCTION("getWinMinXmove",ttTab.hFrame:WINDOW,"Y")).
      DYNAMIC-FUNCTION("DoWidgetResize",ttTab.hFrame:FIRST-CHILD).
    END.  

  END METHOD.

  METHOD PUBLIC VOID selectPage (iiTab AS INT):
    /* Invokes also the selectPage proc in the container (input iiTab as int) if it exists */
    RUN changeFolderPage IN hHelperProc (iiTab).

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setFolderImage(INPUT iiTab AS INT, INPUT icImage AS CHAR):
    RUN SetFolderTag IN hHelperProc(iiTab,icImage).
  END METHOD.

  METHOD PUBLIC VOID tagFolder(INPUT iiTab AS INT, INPUT ibTag AS LOG):
    RUN SetFolderTag IN hHelperProc(iiTab,IF ibTag THEN tagImage ELSE "").
  END METHOD.

  METHOD PUBLIC VOID viewPage (iiTab AS INT):
    /* Invoked by the helper  */
    IF CAN-DO(hSourceProc:INTERNAL-ENTRIES,"TabChanged") THEN
      DYNAMIC-FUNCTION("TabChanged" IN hSourceProc,iiTab).
    ELSE DO:
      FIND FIRST ttTab
           WHERE ttTab.iTab# = iiTab
           NO-ERROR.  
      IF AVAIL ttTab THEN
        ttTab.hFrame:MOVE-TO-TOP().
    END.
  END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	DESTRUCTOR PUBLIC JBoxAblTabs ( ):
    IF VALID-HANDLE(hHelperProc) THEN DO:
      RUN Disable_UI IN hHelperProc.
      DELETE PROCEDURE hHelperProc.
    END.   
	END DESTRUCTOR.
  
  


/*
/* Local Variable Definitions ---                                       */

&SCOP max-labels 32
&SCOP tab-height 21
 
  /***********************  DEFINITIONS  *************************/

  def var wContainerHdl as handle no-undo.
  def var wCurrentPage# as int    no-undo.
  def var wFontSelected as int    no-undo.
  def var wFont         as int    no-undo.
  def var giTagWidthPxl as int    no-undo.

  /* minmum tab height */
  DEFINE VARIABLE xiTabMinHeightPxl    AS INT    NO-UNDO INIT 21.
  /* minimum width */ 
  DEFINE VARIABLE xiTabMinWidthPxl     AS INT    NO-UNDO INIT 12.
 
  /* label margin for variable width tab */
  DEFINE VARIABLE xiLblMarginPxl       AS INT    NO-UNDO INIT 10.
  /* Space for 'empty' variable width tab */
  DEFINE VARIABLE xiEmptyPxl           AS INT    NO-UNDO INIT 32.

  DEFINE VARIABLE giPrevPage           AS INTEGER NO-UNDO.
  DEFINE VARIABLE giTabHeightPxl       AS INTEGER NO-UNDO.  
  DEFINE VARIABLE number-of-pages      AS INTEGER NO-UNDO.
  DEFINE VARIABLE up-image             AS HANDLE  NO-UNDO.  
  DEFINE VARIABLE up-image2            AS HANDLE  NO-UNDO.
  DEFINE VARIABLE up-image3            AS HANDLE  NO-UNDO.
  DEFINE VARIABLE tab-type             AS INT NO-UNDO. /* 1,2 */
  DEFINE VARIABLE page-label           AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE image-hdl            AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE image-hdl2           AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE image-hdl3           AS HANDLE EXTENT {&max-labels} NO-UNDO.
  DEFINE VARIABLE page-enabled         AS LOGICAL EXTENT {&max-labels} NO-UNDO.

/* ************************  Function Prototypes ********************** */


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE Rect-Bottom
     EDGE-PIXELS 0  
     SIZE 33.57 BY .15
     BGCOLOR 7 .

DEFINE RECTANGLE Rect-Left
     EDGE-PIXELS 0  
     SIZE .57 BY 4.23
     BGCOLOR 15 .

DEFINE RECTANGLE Rect-Main
     EDGE-PIXELS 1 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.86 BY 4.35
     BGCOLOR 8 FGCOLOR 0 .

DEFINE RECTANGLE Rect-Right
     EDGE-PIXELS 0  
     SIZE .57 BY 4.35
     BGCOLOR 7 .

DEFINE RECTANGLE Rect-Top
     EDGE-PIXELS 0  
     SIZE 33.57 BY .15
     BGCOLOR 15 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Folder-Frm
     Rect-Bottom AT ROW 6 COL 1
     Rect-Left AT ROW 1.77 COL 1.14
     Rect-Main AT ROW 2.04 COL 3.14
     Rect-Right AT ROW 1.85 COL 34.14
     Rect-Top AT ROW 1.69 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 204.86 BY 34.35.

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

ASSIGN 
       FRAME Folder-Frm:HIDDEN           = TRUE
       FRAME Folder-Frm:HEIGHT           = 7.76
       FRAME Folder-Frm:WIDTH            = 50.4.


/* ***************************  Main Block  *************************** */


/* **********************  Internal Procedures  *********************** */

PROCEDURE changeFolderPage :
/* -----------------------------------------------------------
      Purpose:    Changes the folder visualization when a new page is
                  selected (from the folder or elsewhere). 
      Parameters:  <none>
      Notes: 
    -------------------------------------------------------------*/   
    DEF input param page#   AS INTEGER NO-UNDO.
  
    assign wCurrentPage#    = if page# = 0 or page# = ? then 1
                              else page#.
    RUN ShowCurrentPage(wCurrentPage#).
     
    RETURN. 
END PROCEDURE.


PROCEDURE create-folder-label :
/* -----------------------------------------------------------
      Purpose:     Defines an image for a single tab and sets its label.
      Parameters:  INPUT page number, label
      Notes:       
    -------------------------------------------------------------*/   
     
    DEFINE INPUT PARAMETER p-page#        AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-page-label   AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iTabWidth  AS INT  NO-UNDO.
    DEFINE VARIABLE sts        AS LOG  NO-UNDO.
    DEFINE VARIABLE dWidth     AS DEC  NO-UNDO.
    DEFINE VARIABLE iLblHeight AS INT  NO-UNDO.
    DEFINE VARIABLE iLblWidth  AS INT  NO-UNDO.
    DEFINE VARIABLE iX         AS INT  NO-UNDO.
    DEFINE VARIABLE lFixed     AS LOG  NO-UNDO.
    DEFINE VARIABLE iLoop      AS INT  NO-UNDO.
    DEFINE VARIABLE cStripLbl  AS CHAR NO-UNDO.  
    
    ASSIGN
      iLblHeight = FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(wFontSelected)
      iLblWidth  = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(p-page-label,wFontSelected)
                      /* don't calculate underscore & */
                    - (IF  INDEX(p-page-label,'&':U)  > 0
                       AND INDEX(p-page-label,'&&':U) = 0 
                       THEN FONT-TABLE:GET-TEXT-WIDTH-PIXELS('&':U,wFontSelected)
                       ELSE 0)
      iTabWidth  = iLblWidth + (xiLblMarginPxl  * 4)
      iX         = IF p-page# = 1 THEN 2
                   ELSE 0.
    
     /* If variable width and not page 1 find the pos of the previous tab */
     IF iX = 0 THEN
     DO iLoop = p-page# - 1 TO 1 BY -1:
       IF VALID-HANDLE(image-hdl[iLoop]) THEN 
       DO:
         iX = iX + image-hdl[iLoop]:X
                 + image-hdl[iloop]:WIDTH-PIXEL + 2.
         LEAVE. 
       END.
       ELSE /* add space for empty tabs */ 
         iX = iX + xiEmptyPxl.
     END. /* if ix = 0 then do iloop =  */

    CREATE IMAGE image-hdl[p-page#]
      ASSIGN 
        FRAME             = FRAME folder-frm:HANDLE
        X                 = iX  
        Y                 = 2   
        WIDTH-PIXEL       = iTabWidth - 2
        HEIGHT-PIXEL      = giTabHeightPxl - 2
        PRIVATE-DATA      = "Tab-Folder":U
        CONVERT-3D-COLORS = YES
        SENSITIVE         = YES
       TRIGGERS:      
        ON MOUSE-SELECT-CLICK
           PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
       END TRIGGERS.         

    CREATE IMAGE image-hdl2[p-page#]
      ASSIGN 
         FRAME             = FRAME folder-frm:HANDLE
         X                 = image-hdl[p-page#]:X
                           + image-hdl[p-page#]:WIDTH-P
         Y                 = 3
         WIDTH-PIXEL       = 2 
         HEIGHT-PIXEL      = giTabHeightPxl - 3
         PRIVATE-DATA      = "Tab-Folder":U
         CONVERT-3D-COLORS = YES
         SENSITIVE         = YES
        TRIGGERS:      
         ON MOUSE-SELECT-CLICK 
            PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
        END TRIGGERS.       

    CREATE TEXT page-label[p-page#]
       ASSIGN 
         FRAME         = FRAME folder-frm:HANDLE
          /* keep it nicely 2 pxls above the folder top line */
          Y            = image-hdl[p-page#]:Y + image-hdl[p-page#]:HEIGHT-PIXEL 
                         - iLblHeight
                         - 2 
          /* center label, but make sure X is 2 pxls left of tab:X 
             (visible when the tab to its left is selected) */
          X            = MAX(image-hdl[p-page#]:X + 2,
                         image-hdl[p-page#]:X + image-hdl[p-page#]:WIDTH-PIXEL  
                         - (2 * (image-hdl[p-page#]:WIDTH-PIXEL - iLblWidth) / 3)
                            - iLblWidth
                           ) 
          /* Never wider than 4 pxls ( - 2 and image2) less than tab */
          WIDTH-PIXEL  = MIN(image-hdl[p-page#]:WIDTH-PIXEL - 2,ilblWidth)
          HEIGHT-PIXEL = iLblHeight
          FORMAT       = "X(255)":U
          SENSITIVE    = YES 
          FONT         = wFont
          SCREEN-VALUE = p-page-label
          PRIVATE-DATA = "Tab-Folder":U    
         TRIGGERS:      
            ON MOUSE-SELECT-CLICK 
               PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).        
         END TRIGGERS.
    
    ASSIGN      
      sts = image-hdl[p-page#]:LOAD-IMAGE("bmp/lefttab.bmp":U,
                                           0,
                                           0,
                                           iTabWidth - 2,
                                           giTabHeightPxl - 2)

      sts = image-hdl2[p-page#]:LOAD-IMAGE("bmp/righttab.bmp":U)
      sts = image-hdl[p-page#]:MOVE-TO-TOP()
      sts = image-hdl2[p-page#]:MOVE-TO-TOP()
      sts = page-label[p-page#]:MOVE-TO-TOP()
      
      page-enabled[p-page#]     = yes
      image-hdl[p-page#]:HIDDEN = no     /* Set HIDDEN off explicitly */
      page-label[p-page#]:HIDDEN = no.   /*  or it may come up hidden. */

    CREATE IMAGE image-hdl3[p-page#]
      ASSIGN
        FRAME             = FRAME folder-frm:HANDLE
        X                 = page-label[p-page#]:X
                          + page-label[p-page#]:width-pixels
                          + (int(giTagWidthPxl / 2) - 2)
        Y                 = image-hdl[p-page#]:Y + 2
        WIDTH-PIXEL       = giTagWidthPxl - 2
        HEIGHT-PIXEL      = giTabHeightPxl - 4
        PRIVATE-DATA      = "Tab-Folder":U
        CONVERT-3D-COLORS = YES
        SENSITIVE         = YES
       TRIGGERS:
        ON MOUSE-SELECT-CLICK
           PERSISTENT RUN label-trigger IN THIS-PROCEDURE (p-page#).
       END TRIGGERS.

  RETURN.  
END PROCEDURE.


PROCEDURE disableFolderPage :
/* -----------------------------------------------------------
      Purpose:     Disable and gray out the tab for a page
      Parameters:  INPUT page number to disable
      Notes:       
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.

    ASSIGN page-enabled[p-page#] = no
           page-label[p-page#]:FGCOLOR = 7.  /* Gray out the text */
    RETURN. 
END PROCEDURE.


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
  HIDE FRAME Folder-Frm.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.


PROCEDURE enableFolderPage :
/* -----------------------------------------------------------
      Purpose:     Enable the tab for a page
      Parameters:  INPUT page number to enable
      Notes:       
    -------------------------------------------------------------*/   

    DEFINE INPUT PARAMETER p-page#  AS INTEGER NO-UNDO.

    ASSIGN page-enabled[p-page#] = yes
           page-label[p-page#]:FGCOLOR = ?.  /* Restore the text */
    RETURN. 
END PROCEDURE.


PROCEDURE initializeFolder :
/* -----------------------------------------------------------
      Purpose:     Creates the dynamic images for a tab or notebook
                   folder.
      Parameters:  <none>
      Notes:       Run automatically as part of folder startup.
    -------------------------------------------------------------*/   

    def input param iContainerHdl      as handle    no-undo. /* Calling prosedyre */
    def input param iParentFrameHdl    as widget    no-undo. /* Framen som folderen skal plasseres i */
    def input param iFrameBorder       as int       no-undo. /* Antall pixels for border */
    def input param ifolder-labels     AS CHARACTER NO-UNDO. /* Labels pipe-separert */
    def input param iFont              as integer   no-undo. /* Font for labels */
    def input param iFontSelected      as integer   no-undo. /* Font for valgt label */
    def input param iTagWidthPxl       as int       no-undo. /* Bredden på tag til høyre for labeltekst */

    DEFINE VARIABLE i                  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iLblHeight         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE temp-hdl           AS HANDLE    NO-UNDO.
    DEFINE VARIABLE del-hdl            AS HANDLE    NO-UNDO.             
    DEFINE VARIABLE rebuild            AS LOGICAL   NO-UNDO INIT no.

    ASSIGN
      wContainerHdl                 = iContainerHdl
      giTagWidthPxl                 = iTagWidthPxl
      frame folder-frm:parent       = iParentFrameHdl:first-child
      FRAME Folder-Frm:HEIGHT-pixel = iParentFrameHdl:height-pixels - iFrameBorder * 2
      FRAME Folder-Frm:WIDTH-pixel  = iParentFrameHdl:width-pixels - iFrameBorder * 2
      frame folder-frm:x            = iFrameBorder
      frame folder-frm:y            = iFrameBorder
      wFont                         = IF iFont < 0 THEN ? ELSE iFont
      wFontSelected                 = IF iFontSelected < 0 THEN ? ELSE iFontSelected
      iLblHeight                    = FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(wFontSelected)
      giTabHeightPxl                = MAX(xiTabMinHeightPxl,iLblHeight + 8)
      number-of-pages               = NUM-ENTRIES(ifolder-labels,'|':U).

    IF VALID-HANDLE(up-image) THEN 
    DO:  /* Rebuilding an existing folder */
      assign
        temp-hdl = FRAME folder-frm:HANDLE
        temp-hdl = temp-hdl:FIRST-CHILD    /* Field group */
        temp-hdl = temp-hdl:FIRST-CHILD.   /* First dynamic widget */
      DO WHILE VALID-HANDLE(temp-hdl):
        assign
          del-hdl = temp-hdl
          temp-hdl = temp-hdl:NEXT-SIBLING.
        IF del-hdl:PRIVATE-DATA = "Tab-Folder":U THEN
          DELETE WIDGET del-hdl.
      END.
    END.

    CREATE IMAGE up-image
     ASSIGN 
      FRAME             = FRAME folder-frm:HANDLE
      X                 = 0
      Y                 = 0
      WIDTH-PIXEL       = 110 + 2
      HEIGHT-PIXEL      = giTabHeightPxl + 1
      PRIVATE-DATA      = "Tab-Folder":U
      SENSITIVE         = YES
      CONVERT-3D-COLORS = YES
      HIDDEN            = YES.  /* page 0  */

    up-image:LOAD-IMAGE("bmp/lefttab.bmp":U).

    CREATE IMAGE up-image2
     ASSIGN 
      FRAME             = FRAME folder-frm:HANDLE
      X                 = UP-IMAGE:X + UP-IMAGE:WIDTH-PIXELS 
      Y                 = 1
      WIDTH-PIXEL       = 2 
      HEIGHT-PIXEL      = giTabHeightPxl
      PRIVATE-DATA      = "Tab-Folder":U
      SENSITIVE         = YES
      CONVERT-3D-COLORS = YES
      HIDDEN            = YES.  /* page 0 */

    up-image2:LOAD-IMAGE("bmp/righttab.bmp":U).

    /* hide in case the size is not wide enough for all tabs */
    ASSIGN FRAME folder-frm:HIDDEN = TRUE.
    DO i = 1 TO number-of-pages:       
       IF ENTRY(i,ifolder-labels,'|':U) NE "":U THEN /*Allow skipping of pos'ns*/
            RUN create-folder-label (i, ENTRY(i, ifolder-labels,'|':U)).
    END.

    RUN resizeObject (FRAME folder-frm:HEIGHT, FRAME folder-frm:WIDTH).
    FRAME folder-frm:HIDDEN = FALSE.  
    FRAME folder-frm:MOVE-TO-TOP().

    RUN changeFolderPage (wCurrentPage#).

    RETURN.
END PROCEDURE.


PROCEDURE label-trigger :
/*------------------------------------------------------------------------------
  Purpose:     This procedure serves as the trigger code for each tab label.
  Parameters:  INPUT page number
  Notes:       Used internally only in the definition of tab labels.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-page# AS INTEGER NO-UNDO.
  
  IF VALID-HANDLE(wContainerHdl) AND page-enabled[p-page#] THEN
     RUN changeFolderPage (p-page#).
  RETURN.
END PROCEDURE.


PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Sets the size of the rectangles which make up the folder
               "image" whenever it is resized.
  Parameters:  INPUT height and width.
  Notes:       Run automatically when the folder is initialized or resized.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER p-width  AS DECIMAL NO-UNDO.
  
  /* This is the minimum height needed for all the tabs and rectangles to exist: */
  p-Height = MAX((giTabHeightPxl / SESSION:PIXELS-PER-ROW) + 0.2,p-height) .

  DO WITH FRAME folder-frm:
      ASSIGN Rect-Main:HIDDEN = yes
             Rect-Top:HIDDEN = yes
             Rect-Bottom:HIDDEN = yes
             Rect-Left:HIDDEN = yes
             Rect-Right:HIDDEN = yes 
             Rect-Main:HEIGHT-P = 1
             Rect-Main:WIDTH-P  = 1
             Rect-Top:WIDTH-P  = 1
             Rect-Bottom:ROW    = FRAME folder-frm:ROW
             Rect-Bottom:WIDTH-P  = 1
             Rect-Left:HEIGHT-P = 1
             Rect-Right:COL    = FRAME folder-frm:COL
             Rect-Right:HEIGHT-P = 1
   
   /* Adjust the virtual height to match the new height, to avoid
            scrollbars - note that the frame can't be made non-scrollable
            because that may cause errors *during* a resize. 
            Also adjust the virtual width to match the new width or the
            required width of the tab images, whichever is greater;
            in the latter case scrollbars will appear. */
         FRAME folder-frm:HEIGHT = p-height
         FRAME folder-frm:WIDTH  = p-width
         FRAME folder-frm:VIRTUAL-HEIGHT-PIXELS = 
             FRAME folder-frm:HEIGHT-PIXELS
         FRAME folder-frm:VIRTUAL-WIDTH-PIXELS  = 
             IF (number-of-pages = 0)    /* May not have been set yet. */
             THEN FRAME folder-frm:WIDTH-PIXELS
             ELSE MAX(FRAME folder-frm:WIDTH-PIXELS,
                     image-hdl2[number-of-pages]:X 
                     + image-hdl2[number-of-pages]:WIDTH-PIXEL + 2).

.
            
  ASSIGN Rect-Main:X               = 0
         Rect-Main:Y               = giTabHeightPxl 
         Rect-Main:WIDTH-PIXELS    = FRAME folder-frm:VIRTUAL-WIDTH-PIXELS
         Rect-Main:HEIGHT-PIXELS   = FRAME folder-frm:HEIGHT-PIXELS 
                                     - giTabHeightPxl 
         Rect-Top:X                = 1
         Rect-Top:Y                = giTabHeightPxl
         Rect-Top:WIDTH-PIXELS     = FRAME folder-frm:VIRTUAL-WIDTH-PIXELS 
                                     - 2
         Rect-Top:HEIGHT-PIXELS    = 1
         Rect-Bottom:X             = 1
         Rect-Bottom:Y             = FRAME folder-frm:HEIGHT-PIXELS - 2 
         Rect-Bottom:HEIGHT-PIXELS = 1
         Rect-Bottom:WIDTH-PIXELS  = FRAME folder-frm:VIRTUAL-WIDTH-PIXELS 
                                     - 2
         Rect-Left:X               = 0
         Rect-Left:Y               = giTabHeightPxl
         Rect-Left:WIDTH-PIXELS    = 1
         Rect-Left:HEIGHT-PIXELS   = FRAME folder-frm:HEIGHT-PIXELS 
                                     - (giTabHeightPxl + 1)
         Rect-Right:X              = FRAME folder-frm:VIRTUAL-WIDTH-PIXELS 
                                     - 2
         Rect-Right:Y              = giTabHeightPxl + 1
         Rect-Right:WIDTH-PIXELS   = 1         
         Rect-Right:HEIGHT-PIXELS  = FRAME folder-frm:HEIGHT-PIXELS
                                     - (giTabHeightPxl + 2)
         Rect-Main:HIDDEN   = no
         Rect-Top:HIDDEN    = no
         Rect-Bottom:HIDDEN = no
         Rect-Left:HIDDEN   = no
         Rect-Right:HIDDEN  = no.
         Rect-left:MOVE-TO-TOP().
         Rect-Top:MOVE-TO-TOP().
  END.
          
  RETURN.
END PROCEDURE.


PROCEDURE SetFolderTag:

  def input param p-page# as int  no-undo.
  def input param iImage  as char no-undo.

  def var sts as log no-undo.

  assign
    sts = image-hdl3[p-page#]:LOAD-IMAGE(iImage).

end procedure.

PROCEDURE showCurrentPage :
/*------------------------------------------------------------------------------
  Purpose:     Shows the tab for "current" folder page
  Parameters:  page# - (INTEGER) The current page.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER page# AS INTEGER NO-UNDO.

  DEFINE VARIABLE sts     AS LOGICAL NO-UNDO.

  if giPrevPage = page# then
    leave.

  IF page# > 0 AND page# <= {&max-labels} 
  AND VALID-HANDLE (page-label[page#]) THEN
  do:
    ASSIGN 
      up-image:HIDDEN  = TRUE
      up-image2:HIDDEN  = TRUE
      up-image:WIDTH-P = image-hdl[page#]:WIDTH-P + 4 
      up-image:X       = image-hdl[page#]:X -  2
      up-image:Y       = 0 
      up-image:HIDDEN  = no
      up-image2:X      = up-image:X + up-image:WIDTH-PIXELS 
      up-image2:Y      = 1 
      up-image2:HIDDEN = no
      sts              = up-image:MOVE-TO-TOP()
      sts              = up-image2:MOVE-TO-TOP()
      /* raise text */
      page-label[page#]:Y = page-label[page#]:Y - 1
      page-label[page#]:font = wFontSelected
      sts = image-hdl3[page#]:MOVE-TO-TOP()
      up-image:HIDDEN  = FALSE
      up-image2:HIDDEN = FALSE NO-ERROR.
  end.
  /* If there are no tabs at all leave the up-image viewed for appearance.
     Otherwise if the user has selected page 0, hide the up-image in order
     to visually deselect all pages. */
  ELSE IF number-of-pages > 0 THEN
    ASSIGN
      up-image:HIDDEN  = yes
      up-image2:HIDDEN = yes.
  
  /* reset raised text */
  IF giPrevPage <> 0 AND giPrevPage <= {&max-labels} 
  AND VALID-HANDLE(page-label[giPrevPage]) THEN
    assign
      page-label[giPrevPage]:Y     = page-label[giPrevPage]:Y + 1
      page-label[giPrevPage]:font = wFont.

  giPrevPage       = page#.
  RUN selectPage IN wContainerHdl (INPUT page#).
END PROCEDURE.


/* ************************  Function Implementations ***************** */



*/
END CLASS.