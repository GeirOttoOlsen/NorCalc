&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DLGCLOSE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DLGCLOSE 
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
/*DEFINE SHARED VAR systemnrParam LIKE NPSHSYST.systemnr.  */
/*DEFINE SHARED VAR anleggsnrParam LIKE NPSHSYST.anleggsnr.*/
def var systemNrParam LIKE NPSHSYST.systemnr.
def var anleggsNrParam like npshsyst.anleggsnr.
def var current-rec as rowid.
def var hParent as handle no-undo.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DLGCLOSE

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHSYST

/* Definitions for DIALOG-BOX DLGCLOSE                                  */
&Scoped-define FIELDS-IN-QUERY-DLGCLOSE NPSHSYST.standardpris 
&Scoped-define ENABLED-FIELDS-IN-QUERY-DLGCLOSE NPSHSYST.standardpris 
&Scoped-define ENABLED-TABLES-IN-QUERY-DLGCLOSE NPSHSYST
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-DLGCLOSE NPSHSYST
&Scoped-define QUERY-STRING-DLGCLOSE FOR EACH NPSHSYST ~
      WHERE NPSHSYST.anleggsnr = anleggsnrParam ~
 AND NPSHSYST.systemnr = systemnrParam SHARE-LOCK
&Scoped-define OPEN-QUERY-DLGCLOSE OPEN QUERY DLGCLOSE FOR EACH NPSHSYST ~
      WHERE NPSHSYST.anleggsnr = anleggsnrParam ~
 AND NPSHSYST.systemnr = systemnrParam SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DLGCLOSE NPSHSYST
&Scoped-define FIRST-TABLE-IN-QUERY-DLGCLOSE NPSHSYST


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHSYST.standardpris 
&Scoped-define ENABLED-TABLES NPSHSYST
&Scoped-define FIRST-ENABLED-TABLE NPSHSYST
&Scoped-Define ENABLED-OBJECTS Btn_OK 
&Scoped-Define DISPLAYED-FIELDS NPSHSYST.standardpris 
&Scoped-define DISPLAYED-TABLES NPSHSYST
&Scoped-define FIRST-DISPLAYED-TABLE NPSHSYST


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK":L 
     SIZE 9 BY 1.43
     BGCOLOR 8 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DLGCLOSE FOR 
      NPSHSYST SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGCLOSE
     NPSHSYST.standardpris AT ROW 1.62 COL 24.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.8 BY 1.24
          BGCOLOR 15 FONT 2
     Btn_OK AT ROW 4.67 COL 24.8
     SPACE(22.62) SKIP(1.15)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 8 FONT 2
         TITLE BGCOLOR 8 "Shuntpris":L
         DEFAULT-BUTTON Btn_OK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DLGCLOSE
   FRAME-NAME UNDERLINE                                                 */
ASSIGN 
       FRAME DLGCLOSE:SCROLLABLE       = FALSE
       FRAME DLGCLOSE:PRIVATE-DATA     = 
                "DLGCLOSE".

ASSIGN 
       Btn_OK:PRIVATE-DATA IN FRAME DLGCLOSE     = 
                "Btn_Close".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DLGCLOSE
/* Query rebuild information for DIALOG-BOX DLGCLOSE
     _TblList          = "norcalc.NPSHSYST"
     _Options          = "SHARE-LOCK"
     _Where[1]         = "NPSHSYST.anleggsnr = anleggsnrParam
 AND NPSHSYST.systemnr = systemnrParam"
     _Query            is OPENED
*/  /* DIALOG-BOX DLGCLOSE */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK DLGCLOSE
ON CHOOSE OF Btn_OK IN FRAME DLGCLOSE /* OK */
DO:
   DEFINE VAR c_shuntpris AS DECIMAL INITIAL 0.
   DEFINE VAR c_pris AS DECIMAL INITIAL 0.
   DEFINE VAR c_avgittpris AS DECIMAL INITIAL 0.
   
  FIND NPSHSYST WHERE ROWID(NPSHSYST) = current-rec EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAILABLE NPSHSYST THEN
    DO:
        MESSAGE 'NPSHSYST ikke tilgjengelig for oppdatering' VIEW-AS ALERT-BOX TITLE 'STOPP'.
        RETURN.
    END.
  ASSIGN NPSHSYST.standardpris.

   /* Dersom det er gitt tilbud på dette anlegg - endre shuntpris på alle */

/*  FOR EACH NPSHSYST WHERE NPSHSYST.anleggsnr = anleggsnrParam:*/
/*        c_shuntpris = c_shuntpris + NPSHSYST.standardpris.    */
/*   END.                                                       */

/*  FIND FIRST NPSHTILBUD WHERE NPSHTILBUD.anleggsnr = anleggsnrParam 
    EXCLUSIVE-LOCK NO-ERROR.
  IF AVAILABLE NPSHTILBUD THEN
    DO:
        /* Oppdater shuntpris, prisog avgitt pris for avgitte tilbud */
            c_pris = c_shuntpris.
            c_avgittpris = c_pris - ((c_pris *  NPSHTILBUD.rabatt%) / 100).          
        FOR EACH NPSHTILBUD WHERE NPSHTILBUD.anleggsnr = anleggsnrParam:
             ASSIGN NPSHTILBUD.pris_shuntgrupper  = c_shuntpris
                  NPSHTILBUD.pris = c_pris
                  NPSHTILBUD.avgittpris =  c_avgittpris.
        END.
     END.
*/        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DLGCLOSE 


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

  hParent = source-procedure.
  anleggsnrparam = int(dynamic-function('getAttribute',hParent,'anleggsnrParam')).
  systemnrparam  = int(dynamic-function('getAttribute',hParent,'systemNrParam')).

  FRAME {&FRAME-NAME}:TITLE   = 'Endre pris for systemnr: ' + string(systemNrParam).
  current-rec = dynamic-function('getCurrentRec' in hParent).
  
  RUN enable_UI.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DLGCLOSE  _DEFAULT-DISABLE
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
  HIDE FRAME DLGCLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DLGCLOSE  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-DLGCLOSE}
  GET FIRST DLGCLOSE.
  IF AVAILABLE NPSHSYST THEN 
    DISPLAY NPSHSYST.standardpris 
      WITH FRAME DLGCLOSE.
  ENABLE NPSHSYST.standardpris Btn_OK 
      WITH FRAME DLGCLOSE.
  {&OPEN-BROWSERS-IN-QUERY-DLGCLOSE}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

