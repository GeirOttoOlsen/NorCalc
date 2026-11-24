
/*------------------------------------------------------------------------
    File        : startJBoxTools.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Fri Mar 24 18:03:38 CET 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

/*------------------------------------------------------------------------
    File        : startMypage.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Jun 21 14:32:27 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

//ROUTINE-LEVEL ON ERROR UNDO, THROW.

SESSION:MULTITASKING-INTERVAL        = 40.

/*hWin:VISIBLE = NO.                  */
/*hWin:Y = SESSION:HEIGHT-PIXELS + 50.*/

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEF VAR hServer AS HANDLE NO-UNDO.
DEF VAR bOk     AS LOG    NO-UNDO INIT YES.
DEF VAR hWin    AS HANDLE NO-UNDO.
DEF VAR ConnectParam as char no-undo.

{tt_schema.i "NEW SHARED"}

SESSION:SUPPRESS-WARNINGS = YES.

RUN splashthis.

CREATE SERVER hServer.

IF ENTRY(1,SESSION:PARAM,";") NE "" THEN DO: 
  ConnectParam = ENTRY(1,SESSION:PARAM,";").
  hServer:connect(ConnectParam).  
  IF NOT hServer:CONNECTED() THEN DO:
    MESSAGE "Could not connect to appserver: " ConnectParam
    VIEW-AS ALERT-BOX WARNING.
  END.
END.
ELSE hServer = SESSION.    

RUN InitJukeBoxTools.p PERSISTENT (ConnectParam,hServer).

SESSION:SET-WAIT-STATE("").

SESSION:MULTITASKING-INTERVAL        = 0.

WAIT-FOR System.Windows.Forms.Application:Run().

PROCEDURE splashthis:
    
    DEFINE VARIABLE ourCover AS HANDLE  NO-UNDO.
    DEFINE VARIABLE hImage   AS HANDLE  NO-UNDO.
    DEFINE VARIABLE ldummy   AS LOGICAL NO-UNDO.
    DEF VAR iTitleChars AS INT NO-UNDO.
    DEF VAR iFill       AS INT NO-UNDO.


    CREATE WINDOW hWin
    ASSIGN HIDDEN = YES
           VISIBLE = NO
           SMALL-TITLE        = yes
           SHOW-IN-TASKBAR    = no
           CONTROL-BOX        = no
           MIN-BUTTON         = no
           MAX-BUTTON         = no
           RESIZE             = no
           SCROLL-BARS        = no
           STATUS-AREA        = no
           STATUS-AREA = NO
           MESSAGE-AREA = NO
           .
              
    CREATE FRAME ourCover
        ASSIGN
        BOX        = FALSE
        OVERLAY    = TRUE
        PARENT     = hWin
        X          =  0
        Y          =  0
        VISIBLE    = YES
        SCROLLABLE = TRUE
        .

    CREATE IMAGE hImage
        ASSIGN
        FRAME      = ourCover
        VISIBLE    = YES
        SENSITIVE  = YES
        .

    /*
     * The following are needed to insure that the logo screen is
     * displayed during startup. This insures that window switch
     * events etc. get handled during long startup.
     * It gets reset in y-menu.p.
     */
    ASSIGN
        ldummy                     = hImage:LOAD-IMAGE("SplashScreen.bmp":u)
        hWin:VIRTUAL-WIDTH-PIXELS  = hImage:WIDTH-PIXELS
        hWin:VIRTUAL-HEIGHT-PIXELS = hImage:HEIGHT-PIXELS
        hWin:WIDTH-PIXELS          = hImage:WIDTH-PIXELS
        hWin:HEIGHT-PIXELS         = hImage:HEIGHT-PIXELS
        hWin:MAX-WIDTH-PIXELS      = hImage:WIDTH-PIXELS
        hWin:MAX-HEIGHT-PIXELS     = hImage:HEIGHT-PIXELS
        hWin:SMALL-TITLE           = YES
        hWin:MESSAGE-AREA          = NO
        hWin:STATUS-AREA           = NO

        /* put logo window in the middle of the screen */
        hWin:ROW                   = MAXIMUM(1,(SESSION:HEIGHT 
                                            - hWin:HEIGHT) / 2)
        hWin:COLUMN                = MAXIMUM(1,(SESSION:WIDTH  
                                            - hWin:WIDTH) / 2)

        ourCover:WIDTH-PIXELS                = hImage:WIDTH-PIXELS
        ourCover:HEIGHT-PIXELS               = hImage:HEIGHT-PIXELS 
        ourCover:VIRTUAL-HEIGHT-PIXELS       = hImage:HEIGHT-PIXELS
        ourCover:VIRTUAL-WIDTH-PIXELS        = hImage:WIDTH-PIXELS
        SESSION:IMMEDIATE-DISPLAY            = TRUE
        
        hWin:VISIBLE                         = TRUE
  NO-ERROR.
    
    VIEW ourCover.

/*    iTitleChars = hWin:WIDTH-PIXELS / FONT-TABLE:GET-TEXT-WIDTH-PIXELS("&",hWin:FONT).                              */
/*    iFill = (iTitleChars - FONT-TABLE:GET-TEXT-WIDTH-PIXELS("Sôderberg & Partners | Privat-modulen",hWin:FONT)) / 2.*/
    
    hWin:TITLE = /* FILL(" ",iFill) + */ "Chemistry AS | LazyBI".

    SESSION:SET-WAIT-STATE("General").
    
END PROCEDURE.

PROCEDURE HideSplash:
  DELETE OBJECT hWin NO-ERROR.  
END PROCEDURE.    