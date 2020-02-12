&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME ANLEGGSOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS ANLEGGSOK 
/*------------------------------------------------------------------------

  File: dlgclose.w

  Description: General use dialog box 
    template with Close and Help buttons

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 03/08/94 -  9:14 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE INPUT PARAMETER appdata AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER sokeStreng AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER sortStreng AS CHAR.
DEFINE VAR lBeskrevet AS LOGICAL INITIAL FALSE.
DEFINE VAR lEntreprise AS LOGICAL INITIAL FALSE.

/* Disse styrer MDI - simulering */
IF THIS-PROCEDURE:PERSISTENT THEN
    THIS-PROCEDURE:PRIVATE-DATA = appdata.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME ANLEGGSOK

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHANLG

/* Definitions for DIALOG-BOX ANLEGGSOK                                 */
&Scoped-define OPEN-QUERY-ANLEGGSOK OPEN QUERY ANLEGGSOK FOR EACH NPSHANLG SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-ANLEGGSOK NPSHANLG
&Scoped-define FIRST-TABLE-IN-QUERY-ANLEGGSOK NPSHANLG


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-2 FILL-IN_anlegg COMBO-BOX-3 ~
FILL-IN_anleggsnr FILL-IN_konsulentid COMBO-BOX_beskrevet ~
COMBO-BOX_entreprise COMBO-BOX-1 Btn_OK Btn_Help RECT-11 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-2 COMBO-BOX-3 FILL-IN_anleggsnr ~
FILL-IN_konsulentid COMBO-BOX_beskrevet COMBO-BOX_entreprise COMBO-BOX-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Help 
     LABEL "&Hjelp":L 
     SIZE 12.6 BY 1.24
     BGCOLOR 8 FONT 1.

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK":L 
     SIZE 12.6 BY 1.24
     BGCOLOR 8 FONT 1.

DEFINE VARIABLE COMBO-BOX-1 AS CHARACTER FORMAT "X(12)":U INITIAL "Anlegg" 
     LABEL "&Sortere på" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Anlegg","Anleggsnr","Oppf_uke","Beskrevet","Entreprise" 
     DROP-DOWN-LIST
     SIZE 27.44 BY 1.24
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-2 AS CHARACTER FORMAT "X(15)":U INITIAL "Begynner med" 
     LABEL "&Anlegg" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Begynner med","Er lik","Inneholder" 
     DROP-DOWN-LIST
     SIZE 31.36 BY 1.24
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-3 AS CHARACTER FORMAT "X(12)":U INITIAL "St›rre enn" 
     LABEL "Anleggs&nr" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Større enn","Lik" 
     DROP-DOWN-LIST
     SIZE 27.44 BY 1.24
     BGCOLOR 15 FONT 2 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_beskrevet AS CHARACTER FORMAT "X(8)" 
     LABEL "&Beskrevet" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "FM ","MS ","ABS ","L&G ","TTM ","ANDRE ","FRITT" 
     DROP-DOWN-LIST
     SIZE 17.92 BY 1.24
     BGCOLOR 15 FONT 2.

DEFINE VARIABLE COMBO-BOX_entreprise AS CHARACTER FORMAT "X(8)" 
     LABEL "&Entreprise" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "RØR ","VENT ","AUTO ","SKIP ","KULDE" 
     DROP-DOWN-LIST
     SIZE 19.88 BY 1.24
     BGCOLOR 15 FONT 2.

DEFINE VARIABLE FILL-IN_anlegg AS CHARACTER FORMAT "X(45)" 
     VIEW-AS FILL-IN 
     SIZE 90.44 BY 1.54
     BGCOLOR 15 FONT 2.

DEFINE VARIABLE FILL-IN_anleggsnr AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1.54
     BGCOLOR 15 FONT 2.

DEFINE VARIABLE FILL-IN_konsulentid AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "&Konsulent" 
     VIEW-AS FILL-IN 
     SIZE 10.08 BY 1.54
     BGCOLOR 15 FONT 2.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 151.2 BY 7.32.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY ANLEGGSOK FOR 
      NPSHANLG SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME ANLEGGSOK
     COMBO-BOX-2 AT ROW 3.01 COL 25.6 COLON-ALIGNED
     FILL-IN_anlegg AT ROW 3.01 COL 58.08 COLON-ALIGNED NO-LABEL
     COMBO-BOX-3 AT ROW 4.89 COL 25.32 COLON-ALIGNED
     FILL-IN_anleggsnr AT ROW 4.89 COL 69.16 RIGHT-ALIGNED NO-LABEL
     FILL-IN_konsulentid AT ROW 4.89 COL 101.08 RIGHT-ALIGNED
     COMBO-BOX_beskrevet AT ROW 6.6 COL 25.6 COLON-ALIGNED
     COMBO-BOX_entreprise AT ROW 6.6 COL 67.88 COLON-ALIGNED
     COMBO-BOX-1 AT ROW 6.6 COL 120.52 COLON-ALIGNED
     Btn_OK AT ROW 10.43 COL 65.4
     Btn_Help AT ROW 10.43 COL 84.72
     RECT-11 AT ROW 2.18 COL 3.24
     " Søkekriterium:" VIEW-AS TEXT
          SIZE 29.12 BY 1 AT ROW 1.53 COL 9.12
     SPACE(118.71) SKIP(9.78)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 8 
         TITLE BGCOLOR 8 "Søke etter Shuntanlegg":L
         DEFAULT-BUTTON Btn_OK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX ANLEGGSOK
   UNDERLINE                                                            */
ASSIGN 
       FRAME ANLEGGSOK:SCROLLABLE       = FALSE
       FRAME ANLEGGSOK:PRIVATE-DATA     = 
                "DLGCLOSE".

ASSIGN 
       Btn_OK:PRIVATE-DATA IN FRAME ANLEGGSOK     = 
                "Btn_Close".

/* SETTINGS FOR FILL-IN FILL-IN_anlegg IN FRAME ANLEGGSOK
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN FILL-IN_anleggsnr IN FRAME ANLEGGSOK
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN FILL-IN_konsulentid IN FRAME ANLEGGSOK
   ALIGN-R                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX ANLEGGSOK
/* Query rebuild information for DIALOG-BOX ANLEGGSOK
     _TblList          = "norcalc.NPSHANLG"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX ANLEGGSOK */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help ANLEGGSOK
ON CHOOSE OF Btn_Help IN FRAME ANLEGGSOK /* Hjelp */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK ANLEGGSOK
ON CHOOSE OF Btn_OK IN FRAME ANLEGGSOK /* OK */
DO:
/* Sett sammen søkestreng og sortering */
sokeStreng = "".
sortStreng = "".

/* Anlegg */
IF   FILL-IN_Anlegg:SCREEN-VALUE > "" THEN
    DO:
        CASE COMBO-BOX-2:SCREEN-VALUE:
            WHEN 'Begynner med' THEN
                sokeStreng =  " NPSHANLG.anlegg BEGINS " + '"' + FILL-IN_Anlegg:SCREEN-VALUE + '"'.
            WHEN  'Er lik' THEN
                sokeStreng =  " NPSHANLG.anlegg = " + '"' + FILL-IN_Anlegg:SCREEN-VALUE + '"'.
            WHEN 'Inneholder' THEN
                sokeStreng =  " NPSHANLG.anlegg MATCHES " + '"' + FILL-IN_Anlegg:SCREEN-VALUE + '"'.
        END CASE.    
    END.

/* Anleggsnr */
IF   FILL-IN_anleggsnr:SCREEN-VALUE <> "0" THEN
    DO:
        CASE COMBO-BOX-3:SCREEN-VALUE:
            WHEN 'Større enn' THEN
                IF sokeStreng <> "" THEN
                    sokeStreng =  sokeStreng + " AND NPSHANLG.anleggsnr  > " + FILL-IN_anleggsnr:SCREEN-VALUE.
                ELSE
                    sokeStreng =  " NPSHANLG.anleggsnr > " + FILL-IN_anleggsnr:SCREEN-VALUE.     
            WHEN 'Lik' THEN
                IF sokeStreng <> "" THEN
                    sokeStreng =  sokeStreng + " AND NPSHANLG.anleggsnr  = " + FILL-IN_anleggsnr:SCREEN-VALUE.
                ELSE
                    sokeStreng =  " NPSHANLG.anleggsnr = " + FILL-IN_anleggsnr:SCREEN-VALUE.
        END CASE.    
    END.

/* Konsulentid */
IF   FILL-IN_konsulentid:SCREEN-VALUE <> "0" THEN
    DO:
         IF sokeStreng <> "" THEN
             sokeStreng =  sokeStreng + " AND NPSHANLG.konsulentid  = " + FILL-IN_konsulentid:SCREEN-VALUE.
         ELSE
             sokeStreng =  " NPSHANLG.konsulentid = " + FILL-IN_konsulentid:SCREEN-VALUE.
    END.

/* Beskrevet */
IF  lBeskrevet THEN
    DO:
         IF sokeStreng <> "" THEN
             sokeStreng =  sokeStreng + " AND NPSHANLG.beskrevet  = " + '"' + COMBO-BOX_beskrevet:SCREEN-VALUE + '"'.
         ELSE
             sokeStreng =  " NPSHANLG.beskrevet = " + '"' + COMBO-BOX_beskrevet:SCREEN-VALUE + '"'.
    END.

/* Entreprise */
IF   lEntreprise THEN
    DO:
         IF sokeStreng <> "" THEN
             sokeStreng =  sokeStreng + " AND NPSHANLG.entreprise  = " + COMBO-BOX_entreprise:SCREEN-VALUE.
         ELSE
             sokeStreng =  " NPSHANLG.entreprise = " + COMBO-BOX_entreprise:SCREEN-VALUE.
    END.

/* Sortering */
IF COMBO-BOX-1:SCREEN-VALUE <> "" THEN
    IF COMBO-BOX-1:SCREEN-VALUE = 'Oppf.uke' THEN
        sortStreng = COMBO-BOX-1:SCREEN-VALUE + ' DESC'.
    ELSE    
        sortStreng = COMBO-BOX-1:SCREEN-VALUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_beskrevet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_beskrevet ANLEGGSOK
ON VALUE-CHANGED OF COMBO-BOX_beskrevet IN FRAME ANLEGGSOK /* Beskrevet */
DO:
    lBeskrevet = True.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_entreprise
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_entreprise ANLEGGSOK
ON VALUE-CHANGED OF COMBO-BOX_entreprise IN FRAME ANLEGGSOK /* Entreprise */
DO:
  lEntreprise = True.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK ANLEGGSOK 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI ANLEGGSOK  _DEFAULT-DISABLE
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
  HIDE FRAME ANLEGGSOK.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI ANLEGGSOK  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-ANLEGGSOK}
  GET FIRST ANLEGGSOK.
  DISPLAY COMBO-BOX-2 COMBO-BOX-3 FILL-IN_anleggsnr FILL-IN_konsulentid 
          COMBO-BOX_beskrevet COMBO-BOX_entreprise COMBO-BOX-1 
      WITH FRAME ANLEGGSOK.
  ENABLE COMBO-BOX-2 FILL-IN_anlegg COMBO-BOX-3 FILL-IN_anleggsnr 
         FILL-IN_konsulentid COMBO-BOX_beskrevet COMBO-BOX_entreprise 
         COMBO-BOX-1 Btn_OK Btn_Help RECT-11 
      WITH FRAME ANLEGGSOK.
  {&OPEN-BROWSERS-IN-QUERY-ANLEGGSOK}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

