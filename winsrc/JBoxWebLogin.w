&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
     
USING System.Windows.Forms.* FROM ASSEMBLY.
USING Progress.Windows.* FROM ASSEMBLY. 
    
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&IF "{1}" = "Developer_Studio_is_Running" &THEN
  &SCOPED-DEFINE UIB_is_Running 1 
&ENDIF   

/* Uncomment to enable use of .Net components: */
&SCOPED-DEFINE AdvGuiWin

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) NE 0 &THEN
  DEF VAR icUserId       AS CHAR NO-UNDO.
  DEF VAR icPrefLanguage AS CHAR NO-UNDO.
  DEF VAR bOK            AS LOG  NO-UNDO.
&ELSE
  DEF INPUT  PARAM icUserId       AS CHAR NO-UNDO.
  DEF INPUT  PARAM icPrefLanguage AS CHAR NO-UNDO.
  DEF OUTPUT PARAM bOK            AS LOG NO-UNDO.
&ENDIF



/* Local Variable Definitions ---                                       */

DEF VAR tries      AS INT NO-UNDO.
DEF VAR passord1   AS CHAR FORMAT "x(15)" NO-UNDO.
DEF VAR passord2   AS CHAR FORMAT "x(15)" NO-UNDO.
DEF VAR enco-pass  AS CHAR FORMAT "x(15)" NO-UNDO.

DEF VAR cOldPsw           AS CHAR   NO-UNDO.
DEF VAR bErr              AS LOG    NO-UNDO.
DEF VAR ix                AS INT    NO-UNDO.
DEF VAR hPwdChange        AS HANDLE NO-UNDO.
DEF VAR bPasswordChanged  AS LOG    NO-UNDO.

PROCEDURE SendMessageA EXTERNAL "USER32.dll":
  DEFINE INPUT PARAMETER hHWND AS LONG.
  DEFINE INPUT PARAMETER iCmd  AS LONG.
  DEFINE INPUT PARAMETER iChar AS LONG.
  DEFINE INPUT PARAMETER ulParam AS LONG.
END PROCEDURE.

PROCEDURE PostPWChar:
  DEFINE INPUT PARAMETER hHWND AS INT.
  RUN SendMessageA(hHWND, 204, ASC("*"), 0).
END PROCEDURE.

DEFINE VARIABLE hABLWindow AS HANDLE NO-UNDO. 
DEFINE VARIABLE hFrame AS HANDLE NO-UNDO. 
DEFINE  VARIABLE hPopUpForm_ABLContainer AS Progress.Windows.WindowContainer NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-cUserId fi-cPassword 
&Scoped-Define DISPLAYED-OBJECTS fi-cUserId fi-cPassword 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD PasswordChanged C-Win 
FUNCTION PasswordChanged RETURNS LOGICAL
  ( INPUT ibPasswordChanged AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-cPassword AS CHARACTER FORMAT "X(256)":U 
     LABEL "Password" 
     VIEW-AS FILL-IN 
     SIZE 31.8 BY .91 NO-UNDO.

DEFINE VARIABLE fi-cUserId AS CHARACTER FORMAT "X(256)":U 
     LABEL "User id" 
     VIEW-AS FILL-IN 
     SIZE 31.8 BY .91 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     fi-cUserId AT ROW 1.24 COL 12 COLON-ALIGNED
     fi-cPassword AT ROW 2.19 COL 3.6 BLANK 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 85.8 ROW 5.14
         SIZE 48.6 BY 2.81.


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
         TITLE              = "JBox login"
         COLUMN             = 3
         ROW                = 1.48
         HEIGHT             = 9.91
         WIDTH              = 143
         MAX-HEIGHT         = 47.91
         MAX-WIDTH          = 336
         VIRTUAL-HEIGHT     = 47.91
         VIRTUAL-WIDTH      = 336
         ALWAYS-ON-TOP      = yes
         RESIZE             = no
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

{incl/demo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-cPassword IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* JBox login */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* JBox login */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cPassword
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cPassword C-Win
ON ANY-PRINTABLE OF fi-cPassword IN FRAME DEFAULT-FRAME /* Password */
DO:
  RUN PostPWChar(fi-cPassword:HWND).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

hABLWindow = {&WINDOW-NAME}:HANDLE . 
hFrame     = FRAME {&FRAME-NAME}:HANDLE. 
def var oBtnOk as class System.Windows.Forms.Button no-undo.
def var oBtnExit as class System.Windows.Forms.Button no-undo.

ASSIGN
hABLWindow:TITLE        = "Win1" 
hABLWindow:VISIBLE      = FALSE  
hABLWindow:SENSITIVE    = TRUE. /* Make the form the parent of the window */
hABLWindow:HIDDEN       = TRUE. 

hPopUpForm_ABLContainer = NEW Progress.Windows.WindowContainer().
hPopUpForm_ABLContainer:Name = "windowContainer1".
/*hPopUpForm_ABLContainer:Dock = System.Windows.Forms.DockStyle:RIGHT. */
hPopUpForm_ABLContainer:Location = NEW System.Drawing.Point(hFrame:X,hframe:Y). 
hPopUpForm_ABLContainer:SIZE     = NEW System.Drawing.Size(hFrame:WIDTH-PIXELS,hframe:HEIGHT-PIXELS).
hPopUpForm_ABLContainer:TabIndex = 1.
hPopUpForm_ABLContainer:TabStop = FALSE.
hPopUpForm_ABLContainer:EmbeddedWindow =  hABLWindow.

hFrame:X = 0 . 
hFrame:Y = 0. 

DEFINE VARIABLE form1 AS Progress.Windows.Form NO-UNDO. 
ASSIGN 
    form1 = NEW Progress.Windows.Form()
    form1:TEXT = ""
    /*
    form1:FormBorderStyle = System.Windows.Forms.FormBorderStyle:NONE
    form1:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedToolwindow
    */
    form1:StartPosition   = System.Windows.Forms.FormStartPosition:CenterScreen
    form1:BackgroundImage = System.Drawing.Image:FromFile(SEARCH(".\img\logo.jpg")) 
    form1:Size            = NEW System.Drawing.Size(hABLWindow:WIDTH-PIXELS,hABLWindow:HEIGHT-PIXELS)
    form1:ControlBox      = FALSE /* remove close buttons / max min */          
    form1:AutoSize        = FALSE       
    form1:MaximizeBox     = TRUE                                                
    form1:MinimizeBox     = TRUE 
    form1:ShowInTaskbar   = FALSE
    form1:FormBorderStyle = FormBorderStyle:FixedSingle.
    .
    
    oBtnOk = new System.Windows.Forms.Button().
    oBtnOk:Text = 'OK'.
    oBtnOk:Location = new System.Drawing.Point(530,147).
    oBtnOk:Click:Subscribe("Event_Click_btnOk").
 
    oBtnExit = new System.Windows.Forms.Button().
    oBtnExit:Text = 'Exit'.
    oBtnExit:Location = new System.Drawing.Point(590,147).
    oBtnExit:Click:Subscribe("Event_Click_btnExit").
 
    form1:Controls:Add(oBtnOk).
    form1:Controls:Add(oBtnExit).
    
    form1:Controls:Add(hPopUpForm_ABLContainer).
    form1:TopMost = TRUE.
    form1:Show(). 
    form1:activate(). 
 
hABLWindow:PARENT = form1:ProWinHandle.
hABLWindow:HIDDEN = TRUE. 


FUNCTION SetStartupProgress RETURNS LOGICAL (INPUT  iNum AS INT ):
    DEF VAR Y AS INT NO-UNDO.
    DEF VAR iValue AS INT NO-UNDO. 

    hABLWindow:HIDDEN = TRUE. 
    PAUSE 0 NO-MESSAGE IN WINDOW hABLWindow. 
    RETURN TRUE.
END.


/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
DO:
   SetStartupProgress(1).
   hPopUpForm_ABLContainer:VISIBLE = FALSE.
      
   RUN disable_UI.
   form1:Dispose().
   /*
   form1:Dispose().
   DELETE OBJECT form1. 
   DELETE OBJECT hPopUpForm_ABLContainer NO-ERROR. 
   */
END.

ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  QUIT.
END.

ON RETURN OF {&WINDOW-NAME} ANYWHERE DO:
  IF NOT bErr THEN run doLogin .
END.    

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  RUN enable_UI.
  RUN InitWin. 
  
  WAIT-FOR Application:RUN(form1). 

/*
  IF NOT THIS-PROCEDURE:PERSISTENT THEN WAIT-FOR Application:RUN(form1). 

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CheckUser C-Win 
PROCEDURE CheckUser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM bOkUser AS LOG    NO-UNDO.
DEF VAR hAppservice      AS HANDLE NO-UNDO.
DEF VAR ocSessionId      AS CHAR   NO-UNDO.
DEF VAR oiCompanyId      AS INT    NO-UNDO.
DEF VAR ocASuserName     AS CHAR   NO-UNDO.
DEF VAR cUserStatus      AS CHAR   NO-UNDO.
DEF VAR bChangePwd       AS LOG    NO-UNDO.
DEF VAR cLangCode        AS CHAR   NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN SESSION:DATE-FORMAT    = 'dmy'
         SESSION:NUMERIC-FORMAT = 'european'
         .
  IF NOT bJukeBoxDemo THEN DO:
    ASSIGN fi-cUserId 
           fi-cPassword.
    hAppservice = DYNAMIC-FUNCTION("getAppserviceHandle").
    cLangCode = 'NO'.
        
    DYNAMIC-FUNCTION("setASUserId",fi-cUserId,"").
    bOkUser = DYNAMIC-FUNCTION("getUserConfirmation",fi-cPassword,"",0).
  
    IF NOT bOkUser THEN DO:
      IF cLangCode = "NO" THEN
        MESSAGE "Beklager, bruker/passord er ugyldig" VIEW-AS ALERT-BOX.
      ELSE 
        MESSAGE "Invalid userid/password" VIEW-AS ALERT-BOX.
  
      IF tries > 3 THEN QUIT.   /* only allow 3 tries*/
      tries = tries + 1.
      bOkUser = FALSE.
      RETURN.
    END.
    ELSE DO:
      IF VALID-HANDLE(hAppservice) THEN
        RUN jbserv_validateuser.p ON hAppservice (fi-cUserId,CHR(3),
                                           SESSION:DATE-FORMAT,
                                           SESSION:NUMERIC-FORMAT,
                                           OUTPUT ocSessionId,
                                           OUTPUT ocASuserName,
                                           OUTPUT oiCompanyId,
                                           OUTPUT bOkUser).
      ELSE 
        RUN jbserv_validateuser.p         (fi-cUserId,CHR(3),
                                           SESSION:DATE-FORMAT,
                                           SESSION:NUMERIC-FORMAT,
                                           OUTPUT ocSessionId,
                                           OUTPUT ocASuserName,
                                           OUTPUT oiCompanyId,
                                           OUTPUT bOkUser).

      IF NOT bOkUser THEN DO:
        IF DYNAMIC-FUNCTION("getLanguageCode") = "NO" THEN
          MESSAGE "Bruker må aktiveres for å kunne logge inn" VIEW-AS ALERT-BOX.
        ELSE 
          MESSAGE "User must be activated to proceed login" VIEW-AS ALERT-BOX.
        QUIT.  
      END. 

      DYNAMIC-FUNCTION("setSessionId",ocSessionId).
      DYNAMIC-FUNCTION("setASUserId",fi-cUserId,ocASuserName).
      DYNAMIC-FUNCTION("setLanguageCode",cLangCode).
      IF oiCompanyId NE 0 THEN
        DYNAMIC-FUNCTION("setCompanyId",oiCompanyId).
      ELSE 
        DYNAMIC-FUNCTION("getFunctionRestrictions").

      IF DYNAMIC-FUNCTION("runProc","jbserv_checkuserstatus.p","",?) THEN DO:
        cUserStatus = DYNAMIC-FUNCTION("getTransactionMessage").
        IF cUserStatus NE "" THEN DO:
          IF ENTRY(2,cUserStatus,"|") NE "" THEN
            bChangePwd = DYNAMIC-FUNCTION("DoMessage",0,4,
                                          IF DYNAMIC-FUNCTION("Scandinavian") THEN 
                                            "Passordet ditt utløper om " + ENTRY(2,cUserStatus,"|") + " dager." + CHR(10) + "Endre nå?"
                                          ELSE
                                            "Your password expires in " + ENTRY(2,cUserStatus,"|") + " days." + CHR(10) + "Change it now?"
                                         ,"","") = 6.
          ELSE bChangePwd = LOGICAL(ENTRY(1,cUserStatus,"|")).
  
          IF bChangePwd THEN DO:
            RUN JBoxChangePwd.w PERSIST SET hPwdChange.
            DYNAMIC-FUNCTION("setQuitOnCancel" IN hPwdChange,YES).
            RUN MoveToTop IN hPwdChange.
            SUBSCRIBE TO "InvalidateHandle" IN hPwdChange.
            bOkUser = ?.
            RETURN.
          END.
        END.
      END. 
    END.
  
    APPLY "CLOSE" TO THIS-PROCEDURE.
  END.
  ELSE DO WITH FRAME frmInput:
    bOkUser = TRUE.
    APPLY "CLOSE" TO THIS-PROCEDURE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doLogin C-Win 
PROCEDURE doLogin :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN CheckUser (OUTPUT bOk).
  IF NOT bOk THEN DO:
    APPLY "ENTRY" TO fi-cUserId IN FRAME {&FRAME-NAME}.
    RETURN NO-APPLY.
  END.

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
  DISPLAY fi-cUserId fi-cPassword 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE fi-cUserId fi-cPassword 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Event_Click_btnExit C-Win 
PROCEDURE Event_Click_btnExit :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
def INPUT param sender AS System.Object no-undo.
def input param  e AS System.EventArgs no-undo.

quit.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Event_Click_btnOk C-Win 
PROCEDURE Event_Click_btnOk :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
def INPUT param sender AS System.Object no-undo.
def input param  e AS System.EventArgs no-undo.
  run doLogin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitWin C-Win 
PROCEDURE InitWin :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
     
------------------------------------------------------------------------------*/
    
DO WITH FRAME {&FRAME-NAME}:

  DEFINE VARIABLE cgetBaseLanguageCode AS CHAR NO-UNDO.
  DEFINE VARIABLE cgetLanguages AS CHAR NO-UNDO.
  DEFINE VARIABLE cgetAppTitle AS CHAR NO-UNDO.
  def var cImage as char no-undo.

  ASSIGN 
  cgetBaseLanguageCode = DYNAMIC-FUNCTION("getBaseLanguageCode")
  cgetLanguages = DYNAMIC-FUNCTION("getLanguages")
  cgetAppTitle = DYNAMIC-FUNCTION("getAppTitle") NO-ERROR.


  IF NOT bJukeBoxDemo THEN DO:
/*    IF NUM-ENTRIES(cgetLanguages,"|") > 1 THEN                     */
/*      ASSIGN cmbLanguage:HIDDEN       = FALSE                      */
/*             cmbLanguage:DELIMITER    = "|"                        */
/*             cmbLanguage:SENSITIVE    = TRUE                       */
/*             cmbLanguage:LIST-ITEMS   = cGetLanguages              */
/*             cmbLanguage:SCREEN-VALUE = IF icPrefLanguage = "" THEN*/
/*                                          cgetBaseLanguageCode     */
/*                                        ELSE icPrefLanguage        */
/*             .                                                     */
    {&WINDOW-NAME}:TITLE = cGetAppTitle + " login".  

  END.
/*  ELSE                                                                 */
/*    ASSIGN cmbLanguage:HIDDEN        = FALSE                           */
/*           cmbLanguage:DELIMITER    = "|"                              */
/*           cmbLanguage:SENSITIVE    = TRUE                             */
/*           cmbLanguage:LIST-ITEMS    = "EN|NO"                         */
/*           fi-cUserId:SCREEN-VALUE   = "<whatever>"                    */
/*           cmbLanguage:SCREEN-VALUE  = IF icPrefLanguage = "" THEN "EN"*/
/*                                       ELSE icPrefLanguage             */
/*           .                                                           */

/*  ASSIGN cmbDateFormat:SCREEN-VALUE = SESSION:DATE-FORMAT   */
/*         cmbNumFormat:SCREEN-VALUE  = SESSION:NUMERIC-FORMAT*/
/*         .                                                  */
  IF icUserId NE ? THEN fi-cUserId:SCREEN-VALUE = icUserId.
  IF icUserId NE "" AND NOT icUserId BEGINS "<" THEN DO:
    APPLY "ENTRY" TO fi-cPassword.
  END.
  ELSE APPLY "ENTRY" TO fi-cUserid.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InvalidateHandle C-Win 
PROCEDURE InvalidateHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihProc AS HANDLE NO-UNDO.
IF ihProc = hPwdChange THEN DO:
  bOk = bPasswordChanged.  
  APPLY "close" TO THIS-PROCEDURE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION PasswordChanged C-Win 
FUNCTION PasswordChanged RETURNS LOGICAL
  ( INPUT ibPasswordChanged AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
bPasswordChanged = ibPasswordChanged.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

