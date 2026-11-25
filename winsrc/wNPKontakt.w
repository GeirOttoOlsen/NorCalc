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
&SCOPED-DEFINE AdvGuiWin

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE oToolbar AS JBoxToolbar NO-UNDO.
DEFINE VARIABLE oContainer AS JBoxContainer NO-UNDO.


/*** Start instance property definitions for JBoxBrowse object oBrwNPKONTAKT ***/
DEF VAR oBrwNPKONTAKT AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPKONTAKT
    FIELD cCreatedBy AS character
    FIELD cModifiedBy AS character
    FIELD dCreated AS date
    FIELD dModified AS date
    FIELD ePost AS character
    FIELD Etternavn AS character
    FIELD Fornavn AS character
    FIELD iNPKontaktId AS integer
    FIELD kontaktperson AS character
    FIELD kundenr AS character
    FIELD Mobil AS character
    FIELD Notat AS character
    FIELD Telefon AS character
    FIELD Web AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPKONTAKT FOR TEMP-TABLE NPKONTAKT.


FUNCTION getBuffersAndFieldsBrwNPKONTAKT RETURNS CHARACTER():
  RETURN
    'NPKONTAKT'
     + ';cCreatedBy'
     + ';cModifiedBy'
     + ';dCreated'
     + ';dModified'
     + ';ePost'
     + ';Etternavn'
     + ';Fornavn'
     + ';iNPKontaktId'
     + ';kontaktperson'
     + ';kundenr'
     + ';Mobil'
     + ';Notat'
     + ';Telefon'
     + ';Web'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPKONTAKT RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPKONTAKT AS JBoxFieldMap NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPKONTAKT

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPKONTAKT

/* Definitions for BROWSE BrwNPKONTAKT                                  */
&Scoped-define FIELDS-IN-QUERY-BrwNPKONTAKT NPKONTAKT.cCreatedBy ~
NPKONTAKT.cModifiedBy NPKONTAKT.dCreated NPKONTAKT.dModified ~
NPKONTAKT.ePost NPKONTAKT.Etternavn NPKONTAKT.Fornavn ~
NPKONTAKT.iNPKontaktId NPKONTAKT.kontaktperson NPKONTAKT.kundenr ~
NPKONTAKT.Mobil NPKONTAKT.Notat NPKONTAKT.Telefon NPKONTAKT.Web 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPKONTAKT NPKONTAKT.cCreatedBy 
&Scoped-define QUERY-STRING-BrwNPKONTAKT FOR EACH NPKONTAKT NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPKONTAKT OPEN QUERY BrwNPKONTAKT FOR EACH NPKONTAKT NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPKONTAKT NPKONTAKT
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPKONTAKT NPKONTAKT


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPKONTAKT new_tbNPKONTAKT copy_tbNPKONTAKT ~
undo_tbNPKONTAKT save_tbNPKONTAKT delete_tbNPKONTAKT refresh_tbNPKONTAKT ~
iNPKontaktId BrwNPKONTAKT kundenr kundenavn Fornavn Etternavn Mobil Telefon ~
ePost Web cCreatedBy dCreated cModifiedBy dModified 
&Scoped-Define DISPLAYED-OBJECTS iNPKontaktId kundenr kundenavn Fornavn ~
Etternavn Mobil Telefon ePost Web cCreatedBy dCreated cModifiedBy dModified 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON new_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPKONTAKT 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE cCreatedBy AS CHARACTER FORMAT "x(8)" 
     LABEL "Opprettet" 
     VIEW-AS FILL-IN 
     SIZE 13.6 BY 1.

DEFINE VARIABLE cModifiedBy AS CHARACTER FORMAT "x(8)" 
     LABEL "Modifisert" 
     VIEW-AS FILL-IN 
     SIZE 13.6 BY 1.

DEFINE VARIABLE dCreated AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE dModified AS DATE FORMAT "99/99/9999" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE ePost AS CHARACTER FORMAT "x(50)" 
     LABEL "ePost" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1.

DEFINE VARIABLE Etternavn AS CHARACTER FORMAT "x(50)" 
     LABEL "Etternavn" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1.

DEFINE VARIABLE Fornavn AS CHARACTER FORMAT "x(30)" 
     LABEL "Fornavn" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1.

DEFINE VARIABLE iNPKontaktId AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Id" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1.

DEFINE VARIABLE kundenavn AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE kundenr AS CHARACTER FORMAT "X(8)" 
     LABEL "Kundenr" 
     VIEW-AS FILL-IN 
     SIZE 13.6 BY 1.

DEFINE VARIABLE Mobil AS CHARACTER FORMAT "x(15)" 
     LABEL "Mobil" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.

DEFINE VARIABLE Telefon AS CHARACTER FORMAT "x(15)" 
     LABEL "Jobb telefon" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.

DEFINE VARIABLE Web AS CHARACTER FORMAT "x(100)" 
     LABEL "Web" 
     VIEW-AS FILL-IN 
     SIZE 44 BY 1.

DEFINE RECTANGLE tbNPKONTAKT
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 127 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPKONTAKT FOR 
      NPKONTAKT SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPKONTAKT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPKONTAKT C-Win _STRUCTURED
  QUERY BrwNPKONTAKT NO-LOCK DISPLAY
      NPKONTAKT.cCreatedBy COLUMN-LABEL "Av" FORMAT "x(8)":U
      NPKONTAKT.cModifiedBy COLUMN-LABEL "Av" FORMAT "x(8)":U
      NPKONTAKT.dCreated COLUMN-LABEL "Opprettet" FORMAT "99/99/9999":U
            WIDTH 10
      NPKONTAKT.dModified COLUMN-LABEL "Endret" FORMAT "99/99/9999":U
            WIDTH 10
      NPKONTAKT.ePost COLUMN-LABEL "ePost" FORMAT "x(50)":U
      NPKONTAKT.Etternavn COLUMN-LABEL "Etternavn" FORMAT "x(50)":U
      NPKONTAKT.Fornavn COLUMN-LABEL "Fornavn" FORMAT "x(30)":U
      NPKONTAKT.iNPKontaktId COLUMN-LABEL "Kontakt" FORMAT ">>>>9":U
            WIDTH 6.88
      NPKONTAKT.kontaktperson COLUMN-LABEL "kontaktperson" FORMAT "X(25)":U
      NPKONTAKT.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPKONTAKT.Mobil COLUMN-LABEL "Mobil" FORMAT "x(15)":U
      NPKONTAKT.Notat COLUMN-LABEL "Notat" FORMAT "x(255)":U
      NPKONTAKT.Telefon COLUMN-LABEL "Telefon" FORMAT "x(15)":U
      NPKONTAKT.Web COLUMN-LABEL "Web" FORMAT "x(100)":U
  ENABLE
      NPKONTAKT.cCreatedBy
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 60 BY 14 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPKONTAKT AT ROW 1.1 COL 1.2 WIDGET-ID 8
     copy_tbNPKONTAKT AT ROW 1.1 COL 7.2 WIDGET-ID 10
     undo_tbNPKONTAKT AT ROW 1.1 COL 13.4 WIDGET-ID 12
     save_tbNPKONTAKT AT ROW 1.1 COL 19.4 WIDGET-ID 14
     delete_tbNPKONTAKT AT ROW 1.1 COL 25.6 WIDGET-ID 16
     refresh_tbNPKONTAKT AT ROW 1.1 COL 31.6 WIDGET-ID 18
     iNPKontaktId AT ROW 2.91 COL 75 COLON-ALIGNED
     BrwNPKONTAKT AT ROW 3 COL 1 WIDGET-ID 200
     kundenr AT ROW 3.95 COL 75 COLON-ALIGNED
     kundenavn AT ROW 3.95 COL 89.6 COLON-ALIGNED NO-LABEL
     Fornavn AT ROW 5.05 COL 75 COLON-ALIGNED
     Etternavn AT ROW 6.05 COL 75 COLON-ALIGNED
     Mobil AT ROW 7.43 COL 75 COLON-ALIGNED
     Telefon AT ROW 8.43 COL 75 COLON-ALIGNED
     ePost AT ROW 9.67 COL 75 COLON-ALIGNED
     Web AT ROW 10.76 COL 71.6
     cCreatedBy AT ROW 14.76 COL 75 COLON-ALIGNED
     dCreated AT ROW 14.76 COL 88.2 COLON-ALIGNED NO-LABEL
     cModifiedBy AT ROW 15.76 COL 75 COLON-ALIGNED
     dModified AT ROW 15.76 COL 88.2 COLON-ALIGNED NO-LABEL
     tbNPKONTAKT AT ROW 1 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 127 BY 16.38 WIDGET-ID 100.


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
         TITLE              = "Vedklikehold saksbehandler"
         HEIGHT             = 16.38
         WIDTH              = 127
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 127
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 127
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
/* BROWSE-TAB BrwNPKONTAKT iNPKontaktId DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 16.38
       FRAME DEFAULT-FRAME:WIDTH            = 127.

ASSIGN 
       tbNPKONTAKT:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refreshmaxborder".

/* SETTINGS FOR FILL-IN Web IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPKONTAKT
/* Query rebuild information for BROWSE BrwNPKONTAKT
     _TblList          = "norcalc.NPKONTAKT"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPKONTAKT.cCreatedBy" "Av" "x(8)" "character" ? ? ? ? ? ? yes "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPKONTAKT.cModifiedBy" "Av" "x(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPKONTAKT.dCreated" "Opprettet" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPKONTAKT.dModified" "Endret" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPKONTAKT.ePost" "ePost" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPKONTAKT.Etternavn" "Etternavn" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPKONTAKT.Fornavn" "Fornavn" "x(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPKONTAKT.iNPKontaktId" "Kontakt" ">>>>9" "integer" ? ? ? ? ? ? no "" no no "6.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPKONTAKT.kontaktperson" "kontaktperson" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPKONTAKT.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPKONTAKT.Mobil" "Mobil" "x(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPKONTAKT.Notat" "Notat" "x(255)" "character" ? ? ? ? ? ? no "" no no "255" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPKONTAKT.Telefon" "Telefon" "x(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPKONTAKT.Web" "Web" "x(100)" "character" ? ? ? ? ? ? no "" no no "100" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPKONTAKT */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Vedklikehold saksbehandler */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Vedklikehold saksbehandler */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPKONTAKT
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
{incl/conttrigg.i oBrwNPKONTAKT:BROWSE-HANDLE}

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
  DISPLAY iNPKontaktId kundenr kundenavn Fornavn Etternavn Mobil Telefon ePost 
          Web cCreatedBy dCreated cModifiedBy dModified 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPKONTAKT new_tbNPKONTAKT copy_tbNPKONTAKT undo_tbNPKONTAKT 
         save_tbNPKONTAKT delete_tbNPKONTAKT refresh_tbNPKONTAKT iNPKontaktId 
         BrwNPKONTAKT kundenr kundenavn Fornavn Etternavn Mobil Telefon ePost 
         Web cCreatedBy dCreated cModifiedBy dModified 
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
  DEFINE VARIABLE iDetailMoveX AS INTEGER NO-UNDO.
  DEFINE VARIABLE iAuditMoveY AS INTEGER NO-UNDO.

  IF VALID-OBJECT(oToolbar) THEN RETURN.

  RUN enable_UI.
  oContainer = NEW JBoxContainer().
  oContainer:AddStatusBar().

  DO WITH FRAME {&FRAME-NAME}:
    /* Let the browse grow while the right-hand details follow its edge.
       Only the audit fields below Web follow vertical resizing. */
    ASSIGN
      iDetailMoveX = BrwNPKONTAKT:X + BrwNPKONTAKT:WIDTH-PIXELS
      iAuditMoveY = Web:Y + Web:HEIGHT-PIXELS.

    oBrwNPKONTAKT = NEW JBoxBrowse(BrwNPKONTAKT:HANDLE).
    oBrwNPKONTAKT:CreateGridFilter("").
    oFmNPKONTAKT = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
    oFmNPKONTAKT:UpdateFields = "kundenr,Web,ePost,Mobil,Telefon,Etternavn,Fornavn".
    oFmNPKONTAKT:DisplayFields = "iNPKontaktId,cModifiedBy,dModified,cCreatedBy,dCreated,kundenavn".
    oFmNPKONTAKT:BufferExtraFields = "kundenavn".
    oFmNPKONTAKT:BROWSE-OBJECT = oBrwNPKONTAKT.
    oToolbar = NEW JBoxToolbar(tbNPKONTAKT:HANDLE).
    oBrwNPKONTAKT:TOOLBAR-OBJECT = oToolbar.
    oFmNPKONTAKT:TOOLBAR-OBJECT = oToolbar.
  END.

  oBrwNPKONTAKT:OpenQuery().
  oContainer:InitResize(iDetailMoveX, iAuditMoveY).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewRecord C-Win 
PROCEDURE NewRecord :
DO WITH FRAME {&FRAME-NAME}:
  
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
/*    assign                                                                                */
/*      kundenr:SCREEN-VALUE   = oBrwNPKONTAKT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::kundenr  */
/*      kundenavn:SCREEN-VALUE = oBrwNPKONTAKT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::kundenavn*/
/*    .                                                                                     */
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
DO WITH FRAME {&FRAME-NAME}:
/*    oFmNPKONTAKT:bufferExtraValues = kundenr:screen-value + '|' + kundenavn:screen-value.*/
/*    oFmNPKONTAKT:bufferExtraValues = kundenavn:screen-value.                             */
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

