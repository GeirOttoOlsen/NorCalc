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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSPTILBUD ***/
DEF VAR oBrwNPSPTILBUD AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSPTILBUD
    FIELD anleggsnr AS integer
    FIELD avgittpris AS decimal
    FIELD bet_bet AS character
    FIELD deres_ref AS character
    FIELD gyldighetstid AS integer
    FIELD id AS integer
    FIELD kundenr AS character
    FIELD lev_bet AS character
    FIELD opplysninger AS character
    FIELD pris AS decimal
    FIELD rabatt% AS decimal
    FIELD tilbudsdato AS date
    FIELD tilbudsid AS integer
    FIELD tilbudsnr AS character
    FIELD vaar_ref AS character
    FIELD anlegg AS character
    FIELD anbudsfrist AS date
    FIELD dato AS date
    FIELD opplysninger2 AS character
    FIELD adresse1 AS character
    FIELD adresse2 AS character
    FIELD fax AS character
    FIELD postnr AS character
    FIELD poststed AS character
    FIELD cCompanyName AS character
    FIELD cBankAccount AS character
    FIELD cAddress1 AS character
    FIELD cAddress2 AS character
    FIELD cCity AS character
    FIELD cCountry AS character
    FIELD cEmail AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowIdent4 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3 RowIdent4
    .
DEF BUFFER v_NPSPTILBUD FOR TEMP-TABLE NPSPTILBUD.


FUNCTION getBuffersAndFieldsBrwNPSPTILBUD RETURNS CHARACTER():
  RETURN
    'NPSPTILBUD'
     + ';anleggsnr'
     + ';avgittpris'
     + ';bet_bet'
     + ';deres_ref'
     + ';gyldighetstid'
     + ';id'
     + ';kundenr'
     + ';lev_bet'
     + ';opplysninger'
     + ';pris'
     + ';rabatt%'
     + ';tilbudsdato'
     + ';tilbudsid'
     + ';tilbudsnr'
     + ';vaar_ref'
  + ',NPSPANLG'
     + ';anlegg'
     + ';anbudsfrist'
     + ';dato'
     + ';opplysninger'
  + ',NPKUNDE'
     + ';adresse1'
     + ';adresse2'
     + ';fax'
     + ';postnr'
     + ';poststed'
  + ',JBoxCompany'
     + ';cCompanyName'
     + ';cBankAccount'
     + ';cAddress1'
     + ';cAddress2'
     + ';cCity'
     + ';cCountry'
     + ';cEmail'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPTILBUD RETURNS CHARACTER():
  RETURN 'EACH NPSPANLG OF NPSPTILBUD NO-LOCK,EACH NPKUNDE OF NPSPTILBUD NO-LOCK,EACH JBoxCompany  WHERE TRUE /* Join to NPSPTILBUD incomplete */ NO-LOCK'.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define WIDGETID-FILE-NAME 

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSPTILBUD

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPTILBUD

/* Definitions for BROWSE BrwNPSPTILBUD                                 */
&Scoped-define FIELDS-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD.anleggsnr ~
NPSPTILBUD.avgittpris NPSPTILBUD.bet_bet NPSPTILBUD.deres_ref ~
NPSPTILBUD.gyldighetstid NPSPTILBUD.id NPSPTILBUD.kundenr ~
NPSPTILBUD.lev_bet NPSPTILBUD.opplysninger NPSPTILBUD.pris ~
NPSPTILBUD.rabatt% NPSPTILBUD.tilbudsdato NPSPTILBUD.tilbudsid ~
NPSPTILBUD.tilbudsnr NPSPTILBUD.vaar_ref NPSPTILBUD.anlegg ~
NPSPTILBUD.anbudsfrist NPSPTILBUD.dato NPSPTILBUD.opplysninger2 ~
NPSPTILBUD.adresse1 NPSPTILBUD.adresse2 NPSPTILBUD.fax NPSPTILBUD.postnr ~
NPSPTILBUD.poststed NPSPTILBUD.cCompanyName NPSPTILBUD.cBankAccount ~
NPSPTILBUD.cAddress1 NPSPTILBUD.cAddress2 NPSPTILBUD.cCity ~
NPSPTILBUD.cCountry NPSPTILBUD.cEmail 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD.anleggsnr 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD
&Scoped-define QUERY-STRING-BrwNPSPTILBUD FOR EACH NPSPTILBUD NO-LOCK, ~
    EACH NPSPANLG OF NPSPTILBUD NO-LOCK, ~
    EACH NPKUNDE OF NPSPTILBUD NO-LOCK, ~
    EACH JBoxCompany WHERE TRUE /* Join to NPSPTILBUD incomplete */ NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPTILBUD OPEN QUERY BrwNPSPTILBUD FOR EACH NPSPTILBUD NO-LOCK, ~
    EACH NPSPANLG OF NPSPTILBUD NO-LOCK, ~
    EACH NPKUNDE OF NPSPTILBUD NO-LOCK, ~
    EACH JBoxCompany WHERE TRUE /* Join to NPSPTILBUD incomplete */ NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BrwNPSPTILBUD 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSPTILBUD FOR 
      NPSPTILBUD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSPTILBUD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPTILBUD C-Win _STRUCTURED
  QUERY BrwNPSPTILBUD NO-LOCK DISPLAY
      NPSPTILBUD.anleggsnr FORMAT ">>>>>9":U
      NPSPTILBUD.avgittpris FORMAT ">>,>>>,>>9.99":U
      NPSPTILBUD.bet_bet FORMAT "X(20)":U
      NPSPTILBUD.deres_ref FORMAT "X(30)":U
      NPSPTILBUD.gyldighetstid FORMAT ">99":U
      NPSPTILBUD.id FORMAT ">>>>>>":U
      NPSPTILBUD.kundenr FORMAT "X(8)":U
      NPSPTILBUD.lev_bet FORMAT "X(8)":U
      NPSPTILBUD.opplysninger FORMAT "X(1024)":U
      NPSPTILBUD.pris FORMAT ">>,>>>,>>9.99":U
      NPSPTILBUD.rabatt% FORMAT "->>9.99":U
      NPSPTILBUD.tilbudsdato FORMAT "99.99.9999":U
      NPSPTILBUD.tilbudsid FORMAT "9999":U
      NPSPTILBUD.tilbudsnr FORMAT "X(20)":U
      NPSPTILBUD.vaar_ref FORMAT "X(25)":U
      NPSPTILBUD.anlegg FORMAT "X(45)":U
      NPSPTILBUD.anbudsfrist FORMAT "99.99.9999":U
      NPSPTILBUD.dato FORMAT "99.99.9999":U
      NPSPTILBUD.opplysninger2 FORMAT "X(3072)":U
      NPSPTILBUD.adresse1 FORMAT "X(30)":U
      NPSPTILBUD.adresse2 FORMAT "X(30)":U
      NPSPTILBUD.fax FORMAT "X(15)":U
      NPSPTILBUD.postnr FORMAT "X(8)":U
      NPSPTILBUD.poststed FORMAT "X(22)":U
      NPSPTILBUD.cCompanyName FORMAT "X(40)":U
      NPSPTILBUD.cBankAccount FORMAT "x(50)":U
      NPSPTILBUD.cAddress1 FORMAT "x(50)":U
      NPSPTILBUD.cAddress2 FORMAT "x(40)":U
      NPSPTILBUD.cCity FORMAT "x(40)":U
      NPSPTILBUD.cCountry FORMAT "x(40)":U
      NPSPTILBUD.cEmail FORMAT "x(60)":U
  ENABLE
      NPSPTILBUD.anleggsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 126 BY 10.24 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BrwNPSPTILBUD AT ROW 3.14 COL 2 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 127.4 BY 16.43 WIDGET-ID 100.


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
         HEIGHT             = 16.43
         WIDTH              = 127.4
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 127.4
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 127.4
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
/* BROWSE-TAB BrwNPSPTILBUD 1 DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 16.43
       FRAME DEFAULT-FRAME:WIDTH            = 127.4.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSPTILBUD
/* Query rebuild information for BROWSE BrwNPSPTILBUD
     _TblList          = "norcalc.NPSPTILBUD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSPTILBUD.anleggsnr
"NPSPTILBUD.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSPTILBUD.avgittpris
"NPSPTILBUD.avgittpris" "Avgitt pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSPTILBUD.bet_bet
"NPSPTILBUD.bet_bet" "Bet. bet." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSPTILBUD.deres_ref
"NPSPTILBUD.deres_ref" "Deres ref." "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSPTILBUD.gyldighetstid
"NPSPTILBUD.gyldighetstid" "Gyldighetstid" ">99" "integer" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSPTILBUD.id
"NPSPTILBUD.id" "Id" ">>>>>>" "integer" ? ? ? ? ? ? no "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSPTILBUD.kundenr
"NPSPTILBUD.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSPTILBUD.lev_bet
"NPSPTILBUD.lev_bet" "Lev. bet." "X(8)" "character" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSPTILBUD.opplysninger
"NPSPTILBUD.opplysninger" "Opplysninger" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPSPTILBUD.pris
"NPSPTILBUD.pris" "Pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPSPTILBUD.rabatt%
"NPSPTILBUD.rabatt%" "Rabatt%" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPSPTILBUD.tilbudsdato
"NPSPTILBUD.tilbudsdato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPSPTILBUD.tilbudsid
"NPSPTILBUD.tilbudsid" "tilbudsid" "9999" "integer" ? ? ? ? ? ? no "" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > NPSPTILBUD.tilbudsnr
"NPSPTILBUD.tilbudsnr" "Tilbudsnr." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > NPSPTILBUD.vaar_ref
"NPSPTILBUD.vaar_ref" "Vår ref." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > NPSPTILBUD.anlegg
"NPSPTILBUD.anlegg" "Anlegg" "X(45)" "character" ? ? ? ? ? ? no "Anleggets navn" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > NPSPTILBUD.anbudsfrist
"NPSPTILBUD.anbudsfrist" "Anbudsfrist" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > NPSPTILBUD.dato
"NPSPTILBUD.dato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > NPSPTILBUD.opplysninger2
"NPSPTILBUD.opplysninger2" "Opplysninger" "X(3072)" "character" ? ? ? ? ? ? no "" no no "3072" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > NPSPTILBUD.adresse1
"NPSPTILBUD.adresse1" "Adresse 1" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > NPSPTILBUD.adresse2
"NPSPTILBUD.adresse2" "Adresse 2" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > NPSPTILBUD.fax
"NPSPTILBUD.fax" "Fax" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > NPSPTILBUD.postnr
"NPSPTILBUD.postnr" "Postnr." "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > NPSPTILBUD.poststed
"NPSPTILBUD.poststed" "Poststed" "X(22)" "character" ? ? ? ? ? ? no "" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > NPSPTILBUD.cCompanyName
"NPSPTILBUD.cCompanyName" "Navn" "X(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > NPSPTILBUD.cBankAccount
"NPSPTILBUD.cBankAccount" "Konto" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > NPSPTILBUD.cAddress1
"NPSPTILBUD.cAddress1" "Adresse" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > NPSPTILBUD.cAddress2
"NPSPTILBUD.cAddress2" "Adresse" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > NPSPTILBUD.cCity
"NPSPTILBUD.cCity" "Poststed" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > NPSPTILBUD.cCountry
"NPSPTILBUD.cCountry" "Land" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > NPSPTILBUD.cEmail
"NPSPTILBUD.cEmail" "Epost" "x(60)" "character" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPTILBUD */
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


&Scoped-define BROWSE-NAME BrwNPSPTILBUD
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
{incl/conttrigg.i oBrwNPSPTILBUD:BROWSE-HANDLE}

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
  ENABLE BrwNPSPTILBUD 
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

  oBrwNPSPTILBUD = NEW JBoxBrowse(brwNPSPTILBUD:HANDLE).

END.
oBrwNPSPTILBUD:OpenQuery().


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

