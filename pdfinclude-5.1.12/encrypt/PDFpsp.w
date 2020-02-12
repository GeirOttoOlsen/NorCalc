&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File:                 PDFpsp.w

  Description:          Encrypts a PDF document using the PSP (Pretty Safe PDF)
                        product from PDFlib GmbH.
                        
                        ***** IMPORTANT NOTE: *******
                        
                        You must have the Pretty Safe PDF product (from PDFlib
                        Gmbh) installed.  You can download the product from
                        www.pdflib.com.  If you wish to purchase the product then
                        go to www.epro-sys.com.  
                    
                        PRO-SYS offers a discount to PEG Members.  The discount 
                        will only be accepted if products are ordered via 
                        PRO-SYS. PDFlib GmbH will not honour the discount.


  Input Parameters:     pFile   - name of PDF file to encruypt
      <none>            pMaster - Master password - max 32 characters
                        pUser   - User password - max 32 characters
                        pAccess - Access List - comma delimited
                        pKey    - 40 or 128 Bit Encryption Length
                        pMode   - COM, SHARED or OS                       
                        pSilent - TRUE OR FALSE                       

  Output Parameters:    pStatus - Blank for Encryption OK.
      <none>                      'Cancel' if the Cancel button as pressed.
                                  Otherwise returns Error message.

  Author: 

  Created: 02/21/95 -  4:18 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{ PSP.i }

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER pFile      AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pMaster    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pUser      AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pAccess    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pKey       AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER pMode      AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pSilent    AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pStatus    AS CHARACTER NO-UNDO.

/* DEFINE VARIABLE pFile      AS CHARACTER INITIAL "/my/path/myfile.pdf"  NO-UNDO. */
/* DEFINE VARIABLE pMaster    AS CHARACTER   NO-UNDO.                              */
/* DEFINE VARIABLE pUser      AS CHARACTER   NO-UNDO.                              */
/* DEFINE VARIABLE pAccess    AS CHARACTER   NO-UNDO.                              */
/* DEFINE VARIABLE pKey       AS INTEGER     NO-UNDO.                              */
/* DEFINE VARIABLE pMode      AS CHARACTER INITIAL "SHARED"  NO-UNDO.              */
/* DEFINE VARIABLE pSilent    AS LOGICAL     NO-UNDO.                              */
/* DEFINE VARIABLE pStatus    AS CHARACTER   NO-UNDO.                              */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE vTempFileName     AS CHARACTER NO-UNDO.
  
/* Create Temporary File Name */
vTempFileName = SESSION:TEMP-DIRECTORY 
              + STRING(TODAY,"999999") 
              + STRING(TIME) 
              + ".pdf".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v_User v_Master v_Key v_PreventLoResPrint ~
v_PreventHiResPrint v_PreventForm v_PreventCopy v_PreventAdd v_PreventFill ~
v_PreventExtract v_PreventPage Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS v_User v_Master v_Key v_PreventLoResPrint ~
v_PreventHiResPrint v_PreventForm v_PreventCopy v_PreventAdd v_PreventFill ~
v_PreventExtract v_PreventPage v_FileName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 v_User v_Master v_Key v_PreventLoResPrint ~
v_PreventHiResPrint v_PreventForm v_PreventCopy v_PreventAdd v_PreventFill ~
v_PreventExtract v_PreventPage 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY DEFAULT 
     LABEL "Cancel" 
     SIZE 11 BY 1.

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT 
     LABEL "OK" 
     SIZE 6 BY 1.

DEFINE VARIABLE v_Key AS CHARACTER FORMAT "X(256)":U INITIAL "40" 
     LABEL "Key Length" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "40 ","128" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE v_FileName AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE v_Master AS CHARACTER FORMAT "X(32)":U 
     LABEL "Master Password" 
     VIEW-AS FILL-IN 
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE v_User AS CHARACTER FORMAT "X(32)":U 
     LABEL "User Password" 
     VIEW-AS FILL-IN 
     SIZE 29 BY 1 NO-UNDO.

DEFINE VARIABLE v_PreventAdd AS LOGICAL INITIAL no 
     LABEL "Prevent Adding or Changing Comments or Form Fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 57 BY 1 NO-UNDO.

DEFINE VARIABLE v_PreventCopy AS LOGICAL INITIAL no 
     LABEL "Prevent Copying and Extracting Text or Graphics" 
     VIEW-AS TOGGLE-BOX
     SIZE 51 BY 1 NO-UNDO.

DEFINE VARIABLE v_PreventExtract AS LOGICAL INITIAL no 
     LABEL "Prevent Extraction of Text or Graphics" 
     VIEW-AS TOGGLE-BOX
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE v_PreventFill AS LOGICAL INITIAL no 
     LABEL "Prevent Filling of Form Fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE v_PreventForm AS LOGICAL INITIAL no 
     LABEL "Prevent Adding Form Fields && Other Changes" 
     VIEW-AS TOGGLE-BOX
     SIZE 45 BY 1 NO-UNDO.

DEFINE VARIABLE v_PreventHiResPrint AS LOGICAL INITIAL no 
     LABEL "Prevent High Resolution Printing" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE v_PreventLoResPrint AS LOGICAL INITIAL no 
     LABEL "Prevent Printing of the File" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE v_PreventPage AS LOGICAL INITIAL no 
     LABEL "Prevent Inserting/Deleting/Rotating Page, Bookmarks" 
     VIEW-AS TOGGLE-BOX
     SIZE 54 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     v_User AT ROW 4 COL 20 COLON-ALIGNED WIDGET-ID 30 BLANK 
     v_Master AT ROW 5 COL 20 COLON-ALIGNED WIDGET-ID 12 BLANK 
     v_Key AT ROW 7 COL 20 COLON-ALIGNED WIDGET-ID 10
     v_PreventLoResPrint AT ROW 9 COL 5 WIDGET-ID 26
     v_PreventHiResPrint AT ROW 10 COL 5 WIDGET-ID 24
     v_PreventForm AT ROW 11 COL 5 WIDGET-ID 22
     v_PreventCopy AT ROW 12 COL 5 WIDGET-ID 16
     v_PreventAdd AT ROW 13 COL 5 WIDGET-ID 14
     v_PreventFill AT ROW 14 COL 5 WIDGET-ID 20
     v_PreventExtract AT ROW 15 COL 5 WIDGET-ID 18
     v_PreventPage AT ROW 16 COL 5 WIDGET-ID 28
     Btn_OK AT ROW 18 COL 6 WIDGET-ID 4
     Btn_Cancel AT ROW 18 COL 15 WIDGET-ID 2
     v_FileName AT ROW 2 COL 1 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     "Encrypt File:" VIEW-AS TEXT
          SIZE 13 BY 1 AT ROW 1 COL 3 WIDGET-ID 6
     SPACE(46.00) SKIP(17.00)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "PDF encryption" WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN v_FileName IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX v_Key IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR FILL-IN v_Master IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX v_PreventAdd IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX v_PreventCopy IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX v_PreventExtract IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX v_PreventFill IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX v_PreventForm IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX v_PreventHiResPrint IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX v_PreventLoResPrint IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR TOGGLE-BOX v_PreventPage IN FRAME Dialog-Frame
   1                                                                    */
/* SETTINGS FOR FILL-IN v_User IN FRAME Dialog-Frame
   1                                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* PDF encryption */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
  DEFINE VARIABLE l_Permission AS CHARACTER NO-UNDO.

  ASSIGN FRAME {&FRAME-NAME} 
         {&LIST-1}.

  IF v_User <> "" AND v_User = v_Master THEN DO:
    MESSAGE "User and Master passwords cannot be the same!"
            VIEW-AS ALERT-BOX.
    RETURN NO-APPLY.
  END.

  ASSIGN pUser    = v_User
         pMaster  = v_Master
         pKey     = INT(v_Key).

  IF v_PreventLoResPrint THEN 
    L_Permission = "noprint:".

  IF v_PreventHiResPrint THEN 
    L_Permission = L_Permission + "nohiresprint:".

  IF v_PreventForm THEN 
    L_Permission = L_Permission + "nomodify:".

  IF v_PreventCopy THEN 
    L_Permission = L_Permission + "nocopy:".

  IF v_PreventAdd THEN 
    L_Permission = L_Permission + "noannots:".

  IF v_PreventFill THEN 
    L_Permission = L_Permission + "noforms:".

  IF v_PreventExtract THEN 
    L_Permission = L_Permission + "noaccessible:".

  IF v_PreventPage THEN 
    L_Permission = L_Permission + "noassemble:".

  IF L_Permission <> "" THEN
    ASSIGN L_Permission = SUBSTR(L_Permission,1,LENGTH(L_Permission) - 1)
           pAccess      = l_Permission.

  RUN pdf_Encrypt_Silent.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


RUN LocalInit.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

    IF pSilent THEN
      RUN pdf_Encrypt_silent.
    ELSE DO:
      RUN enable_UI.
      WAIT-FOR GO OF FRAME {&FRAME-NAME}.
    END.
END.

IF NOT pSilent THEN
  RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY v_User v_Master v_Key v_PreventLoResPrint v_PreventHiResPrint 
          v_PreventForm v_PreventCopy v_PreventAdd v_PreventFill 
          v_PreventExtract v_PreventPage v_FileName 
      WITH FRAME Dialog-Frame.
  ENABLE v_User v_Master v_Key v_PreventLoResPrint v_PreventHiResPrint 
         v_PreventForm v_PreventCopy v_PreventAdd v_PreventFill 
         v_PreventExtract v_PreventPage Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LocalInit Dialog-Frame 
PROCEDURE LocalInit :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABlE l_Loop    AS INTEGER NO-UNDO.

  ASSIGN v_FileName           = pFile
         v_User               = IF pSilent THEN pUser   ELSE ""
         v_Master             = IF pSilent THEN pMaster ELSE ""
         v_Key                = STRING(pKey)

         v_PreventLoResPrint  = FALSE
         v_PreventHiResPrint  = FALSE
         v_PreventForm        = FALSE
         v_PreventCopy        = FALSE
         v_PreventAdd         = FALSE
         v_PreventFill        = FALSE
         v_PreventExtract     = FALSE
         v_PreventPage        = FALSE.

  DO l_Loop = 1 TO NUM-ENTRIES(pAccess,";"):

    CASE ENTRY(l_Loop,pAccess,";"):
      WHEN "nohiresprint" THEN
        v_PreventHiResPrint = TRUE.
      
      WHEN "noprint" THEN
        v_PreventLoResPrint = TRUE.

      WHEN "nomodify" THEN
        v_PreventForm = TRUE.

      WHEN "nocopy" THEN
        v_PreventCopy = TRUE.
      
      WHEN "noannots" THEN
        v_PreventAdd = TRUE.
      
      WHEN "noforms" THEN
        v_PreventFill = TRUE.
    
      WHEN "noaccessible" THEN
        v_PreventExtract = TRUE.
      
      WHEN "noassemble" THEN
        v_PreventPage = TRUE.
    END CASE.

  END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pdf_COM_Encrypt Dialog-Frame 
PROCEDURE pdf_COM_Encrypt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ch_PSPAppl   AS COM-HANDLE NO-UNDO.
  
  CREATE "PSPlib_Com.PSP" ch_PSPAppl NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    RETURN "Cannot Find PSP COM Automation Object".

  ch_PSPAppl:Open_File("",SEARCH(pFile)).
  ch_PSPAppl:Create_file(pMaster,pUser,pAccess,2, pKey, vTempFileName).
  ch_PSPAppl:Close().

  RELEASE OBJECT ch_PSPAppl.

  /* Remove the Original File and rename the Temporary File to the Orignal 
     FileName */
  OS-DELETE VALUE(pFile).
  OS-RENAME VALUE(vTempFileName) VALUE(pFile).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pdf_Encrypt_Silent Dialog-Frame 
PROCEDURE pdf_Encrypt_Silent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF pMode = "COM" THEN
    RUN pdf_COM_Encrypt.

  ELSE IF pMode = "SHARED" THEN
    RUN pdf_SHARED_Encrypt.

  ELSE IF pMode = "OS" THEN
    RUN pdf_OS_Encrypt.

  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pdf_OS_Encrypt Dialog-Frame 
PROCEDURE pdf_OS_Encrypt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE l_Command AS CHARACTER NO-UNDO.

  L_Command = "psp -replace".

  IF pMaster <> "" THEN
    l_Command = L_Command + " -m " + pMaster.

  IF pUser <> "" THEN
    l_Command = L_Command + " -u " + pUser.

  l_Command = IF pKey = 40 THEN
                l_Command + " -k 40"
              ELSE
                l_Command + " -k 128".

  IF pAccess <> "" THEN
    ASSIGN pAccess = REPLACE(pAccess,";"," ")
           L_Command = L_Command + " -a " + pAccess.

  L_Command = l_Command + " -i " + pFile.

  OS-COMMAND SILENT VALUE(L_Command).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pdf_SHARED_Encrypt Dialog-Frame 
PROCEDURE pdf_SHARED_Encrypt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE l_PSP        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE l_Return     AS INTEGER   NO-UNDO.

  /* Create a New PSP Binding */
  l_PSP = PSP_New().
  IF l_PSP = -1 THEN DO:
    RETURN "Unable to create a new PSP binding".
  END.

  /* Open the existing PDF file -- assume blank password since if calling from
     PDFinclude then this is probably a newly generated PDF file */
  l_Return = PSP_open_File(l_PSP,"",SEARCH(pFile)).
  IF l_Return = -1 THEN DO:
    RETURN "Unable to open the PDF file (" + pFile + ")!".
  END.

  l_Return = PSP_create_file(l_PSP, pMaster, pUser, pAccess, 2, pKey, vTempFileName).
  PSP_close(l_PSP).
  PSP_delete(l_PSP).

  /* Remove the Original File and rename the Temporary File to the Orignal 
     FileName */
  OS-DELETE VALUE(pFile).
  OS-RENAME VALUE(vTempFileName) VALUE(pFile).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pdf_SHARED_Encrypt_PLOP Dialog-Frame 
PROCEDURE pdf_SHARED_Encrypt_PLOP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE l_PLOP        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE l_Return     AS INTEGER   NO-UNDO.

  /* Create a New PLOP Binding */
  l_PLOP = PLOP_New().
  IF l_PLOP = -1 THEN DO:
    RETURN "Unable to create a new PLOP binding".
  END.

  /* Open the existing PDF file -- assume blank password since if calling from
     PDFinclude then this is probably a newly generated PDF file */
  l_Return = PLOP_open_document(l_PLOP,SEARCH(pFile),LENGTH(SEARCH(pFile),"CHARACTER"),"").
  IF l_Return = -1 THEN DO:
    RETURN "Unable to open the PDF file (" + pFile + ")!".
  END.

  /* l_Return = PSP_create_file(l_PLOP, pMaster, pUser, pAccess, 2, pKey, vTempFileName). */
  l_Return = PLOP_create_file(l_PLOP,vTempFileName,LENGTH(SEARCH(vTempFileName),"CHARACTER"),
                              "compatibility= " + IF pKey = 40 THEN "1.3 " ELSE "1.4 " +
                              "master-password={" + pMaster + "} " +
                              "user-password={" + pUser + "} " +
                              IF pAccess > "" THEN " permissions=" + pAccess ELSE "").
  PLOP_close(l_PLOP).
  PLOP_delete(l_PLOP).

  /* Remove the Original File and rename the Temporary File to the Orignal 
     FileName */
  OS-DELETE VALUE(pFile).
  OS-RENAME VALUE(vTempFileName) VALUE(pFile).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

