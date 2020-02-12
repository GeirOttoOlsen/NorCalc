&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DLGOKCAN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DLGOKCAN 
/*------------------------------------------------------------------------

  File: dlgokcan.w

  Description: General use dialog box
    template witth OK, Cancel, and
    Help buttons

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 03/03/94 -  5:03 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
/*DEFINE INPUT PARAMETER appdata AS CHARACTER.                            */
/*DEFINE INPUT PARAMETER prosjektNavnParam LIKE NORPROSJEKT.prosjekt_navn.*/
/*DEFINE SHARED VAR Current-Rec AS ROWID.*/
/*DEFINE SHARED VAR nyRecord AS LOGICAL. */
/*DEFINE SHARED VAR prosjektIdParam LIKE NORPROSJEKT.prosjektid.*/
DEFINE VAR Current-Rec AS ROWID.
DEFINE VAR nyRecord AS LOGICAL.

def var prosjektIdParam like norprosjekt.prosjektid.
def var prosjektNavnParam like NORPROSJEKT.prosjekt_navn.
def var hParent as handle no-undo.

/* Local Variable Definitions ---                                       */
DEFINE VAR iNextAnleggsnr AS INTEGER.
DEFINE VAR konsulentnrParam AS CHAR.
DEFINE VAR konsulentnvnParam AS CHAR.
DEFINE VAR pointer AS LOGICAL.
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DLGOKCAN

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSPANLG.beskrevet NPSPANLG.dato ~
NPSPANLG.aktivt NPSPANLG.endrings_laas NPSPANLG.anlegg ~
NPSPANLG.konsulentens_saksbeh NPSPANLG.kundedistriktNr ~
NPSPANLG.saksbehandler NPSPANLG.selger NPSPANLG.entreprise ~
NPSPANLG.anbudsfrist NPSPANLG.byggestart NPSPANLG.oppf_uke ~
NPSPANLG.oppf_aar NPSPANLG.leveringstid NPSPANLG.opplysninger 
&Scoped-define ENABLED-TABLES NPSPANLG
&Scoped-define FIRST-ENABLED-TABLE NPSPANLG
&Scoped-Define ENABLED-OBJECTS Konsulent Btn_OK Btn_Cancel Btn_Help ~
COMBO-SPINN RECT-30 
&Scoped-Define DISPLAYED-FIELDS NPSPANLG.dato NPSPANLG.aktivt ~
NPSPANLG.endrings_laas NPSPANLG.konsulentens_saksbeh ~
NPSPANLG.kundedistriktNr NPSPANLG.saksbehandler NPSPANLG.selger ~
NPSPANLG.anbudsfrist NPSPANLG.byggestart NPSPANLG.oppf_aar ~
NPSPANLG.opplysninger 
&Scoped-define DISPLAYED-TABLES NPSPANLG
&Scoped-define FIRST-DISPLAYED-TABLE NPSPANLG


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancel":L 
     SIZE 11.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help":L 
     SIZE 11.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&OK":L 
     SIZE 11.2 BY 1.24
     BGCOLOR 8 .

DEFINE VARIABLE Konsulent AS CHARACTER FORMAT "X(40)":U 
     LABEL "Konsulent" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 51 BY 1.24
     FONT 2 NO-UNDO.

DEFINE IMAGE COMBO-SPINN
     FILENAME "bmp\spinn":U
     SIZE 3.6 BY 1.19.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 129.4 BY 16.95.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGOKCAN
     NPSPANLG.beskrevet AT ROW 8.38 COL 55 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "     ","     ",
                     "Spirotop","Spirotop",
                     "Air","Air",
                     "Air & Dirt","Air & Dirt",
                     "Air Sup","Air Sup",
                     "Air & Dirt Dem","Air & Dirt Dem",
                     "Dirt Sep","Dirt Sep",
                     "Dirt Sep Dem","Dirt Sep Dem",
                     "Luft","Luft",
                     "Mikr","Mikr",
                     "Mikr/Smuss","Mikr/Smuss",
                     "Smuss","Smuss",
                     "Ajevent","Ajevent",
                     "Flamco","Flamco",
                     "Nonair","Nonair",
                     "Andre","Andre",
                     "Fritt","Fritt"
          DROP-DOWN-LIST
          SIZE 26.6 BY 1.05
     NPSPANLG.anleggsnr AT ROW 1.71 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.dato AT ROW 1.71 COL 44 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 18 BY 1.24
          FONT 2
     NPSPANLG.aktivt AT ROW 1.81 COL 69
          VIEW-AS TOGGLE-BOX
          SIZE 12.4 BY .95
     NPSPANLG.endrings_laas AT ROW 1.81 COL 90
          LABEL "Låst for endringer"
          VIEW-AS TOGGLE-BOX
          SIZE 25.2 BY .95
          FGCOLOR 12 FONT 2
     NPSPANLG.anlegg AT ROW 3.05 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 75.4 BY 1.24
          FONT 2
     Konsulent AT ROW 4.33 COL 23 COLON-ALIGNED
     NPSPANLG.konsulentens_saksbeh AT ROW 4.38 COL 82.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 37 BY 1.24
     NPSPANLG.kundedistriktNr AT ROW 5.76 COL 23 COLON-ALIGNED
          LABEL "Salgsdistrikt"
          VIEW-AS COMBO-BOX INNER-LINES 8
          LIST-ITEM-PAIRS "",1
          DROP-DOWN-LIST
          SIZE 47.8 BY 1.05
          FONT 2
     NPSPANLG.saksbehandler AT ROW 6.95 COL 23 COLON-ALIGNED
          LABEL "Saksbeh."
          VIEW-AS COMBO-BOX 
          DROP-DOWN-LIST
          SIZE 44 BY 1
     NPSPANLG.selger AT ROW 6.95 COL 88 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          DROP-DOWN-LIST
          SIZE 36.8 BY 1.05
     NPSPANLG.entreprise AT ROW 8.38 COL 18.6 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "RØR ","RØR ",
                     "VENT ","VENT ",
                     "AUTO ","AUTO ",
                     "SKIP ","SKIP ",
                     "KULDE","KULDE",
                     "FORPRO","FORPRO",
                     "ELEKTRO","ELEKTRO",
                     "TOTAL","TOTAL"
          DROP-DOWN-LIST
          SIZE 18.2 BY 1.05
          FONT 2
     NPSPANLG.anbudsfrist AT ROW 8.14 COL 104.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 18 BY 1.24
          FONT 2
     NPSPANLG.byggestart AT ROW 9.71 COL 18.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 18 BY 1.24
          FONT 2
     NPSPANLG.oppf_uke AT ROW 9.81 COL 55 COLON-ALIGNED
          LABEL "Oppf.uke"
          VIEW-AS FILL-IN NATIVE 
          SIZE 4.8 BY 1.24
          FONT 2
     NPSPANLG.oppf_aar AT ROW 9.81 COL 74.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.6 BY 1.24
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME DLGOKCAN
     NPSPANLG.leveringstid AT ROW 9.52 COL 104 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 22.6 BY 1.24
          FONT 2
     NPSPANLG.opplysninger AT ROW 12.33 COL 4.6 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 125.4 BY 5.57
          FONT 2
     Btn_OK AT ROW 18.67 COL 47.2
     Btn_Cancel AT ROW 18.67 COL 60.2
     Btn_Help AT ROW 18.67 COL 72.2
     "Opplysninger" VIEW-AS TEXT
          SIZE 18.2 BY .76 AT ROW 11.33 COL 5.4
     COMBO-SPINN AT ROW 4.57 COL 76.8
     RECT-30 AT ROW 1.38 COL 2.6
     SPACE(1.99) SKIP(1.99)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "Spiroventanlegg":L
         CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DLGOKCAN
   NOT-VISIBLE FRAME-NAME UNDERLINE Custom                              */
ASSIGN 
       FRAME DLGOKCAN:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN NPSPANLG.anlegg IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSPANLG.anleggsnr IN FRAME DLGOKCAN
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSPANLG.beskrevet IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX NPSPANLG.endrings_laas IN FRAME DLGOKCAN
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPSPANLG.entreprise IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN Konsulent IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX NPSPANLG.kundedistriktNr IN FRAME DLGOKCAN
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSPANLG.leveringstid IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSPANLG.oppf_uke IN FRAME DLGOKCAN
   NO-DISPLAY EXP-LABEL                                                 */
/* SETTINGS FOR COMBO-BOX NPSPANLG.saksbehandler IN FRAME DLGOKCAN
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DLGOKCAN
/* Query rebuild information for DIALOG-BOX DLGOKCAN
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX DLGOKCAN */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel DLGOKCAN
ON CHOOSE OF Btn_Cancel IN FRAME DLGOKCAN /* Cancel */
DO:
            nyRecord = FALSE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help DLGOKCAN
ON CHOOSE OF Btn_Help IN FRAME DLGOKCAN /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK DLGOKCAN
ON CHOOSE OF Btn_OK IN FRAME DLGOKCAN /* OK */
DO:
    /* Dersom oppf. uke og år ikke er fylt ut, stopp registrering */
    IF INTEGER(NPSPANLG.oppf_uke:SCREEN-VALUE) = 0 OR 
        INTEGER(NPSPANLG.oppf_aar:SCREEN-VALUE) = 0 THEN DO:
            MESSAGE 'Neste oppfølgingsuke og år MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
    END.

    IF konsulentnrParam = '0' THEN    /* Ok trykket uten at konsulent er valgt -- ulovlig! */
        APPLY 'CHOOSE' TO Btn_Cancel.
    ELSE DO:
      find first npkundedistrikt where NPkundedistrikt.kundedistriktNr = int(npspanlg.kundedistriktnr:screen-value) no-lock no-error.
      if avail npkundedistrikt then NPSPANLG.salgsdistrikt = string(npkundedistrikt.kundedistriktnr) + ' / ' + NPkundedistrikt.kundedistriktnavn.
      IF nyRecord THEN DO:
        define var cp_tabell_navn as char.
        define var ip_neste_id as integer.
  
        cp_tabell_navn  = 'NPSPANLG'.
        run neste_id.p (input cp_tabell_navn, output ip_neste_id).
        ASSIGN  NPSPANLG.kundenr = konsulentnrParam
                           NPSPANLG.anleggsnr = ip_neste_id
                           NPSPANLG.prosjektid = prosjektIdParam.
        Current-Rec = ROWID(NPSPANLG).
        nyRecord = TRUE.
        /* Ved nytt anlegg, skal prosjektet v‘re aktivt uansett */
        UPDATE NORPROSJEKT SET NORPROSJEKT.aktivt = TRUE
        WHERE NORPROSJEKT.prosjektid = prosjektidParam.
      END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-SPINN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-SPINN DLGOKCAN
ON MOUSE-SELECT-CLICK OF COMBO-SPINN IN FRAME DLGOKCAN
DO:
    APPLY "LEAVE"  TO konsulent.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Konsulent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Konsulent DLGOKCAN
ON LEAVE OF Konsulent IN FRAME DLGOKCAN /* Konsulent */
DO:
   FIND NPKUNDE WHERE NPKUNDE.kundenavn = Konsulent:SCREEN-VALUE NO-ERROR.
   IF NOT AVAILABLE(NPKUNDE) THEN
       DO:
           konsulentnrParam = '0'.
           konsulentnvnParam = "".
           RUN VELGKONS.W (INPUT-OUTPUT konsulentnrParam, INPUT-OUTPUT konsulentnvnParam) NO-ERROR.
           IF konsulentnrParam = '0' THEN
               RETURN.
           ELSE 
               DO:
                    Konsulent = konsulentnvnParam.
                    NPSPANLG.kundenr = konsulentnrParam.
                   DISPLAY konsulent WITH FRAME  {&FRAME-NAME}.
                    APPLY "ENTRY" TO NPSPANLG.entreprise.
               END.
        END.
   ELSE
       DO:
           Konsulent = NPKUNDE.kundenavn.
           konsulentnrParam = NPKUNDE.kundenr.
           DISPLAY konsulent WITH FRAME  {&FRAME-NAME}.
           APPLY "ENTRY" TO entreprise.
       END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.kundedistriktNr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.kundedistriktNr DLGOKCAN
ON VALUE-CHANGED OF NPSPANLG.kundedistriktNr IN FRAME DLGOKCAN /* Salgsdistrikt */
DO:
/*   WHEN '90-Nordland' OR WHEN '100-Troms/Finnmark' OR WHEN '110-Svalbard' THEN*/
  CASE SELF:SCREEN-VALUE:
    WHEN '90' OR WHEN '100' OR WHEN '110' THEN
        DO:
            NPSPANLG.selger = 'Steinar Aune'.
            DISPLAY NPSPANLG.selger WITH FRAME {&FRAME-NAME}.
          END.
    OTHERWISE
        DO:
            NPSPANLG.selger = "Arne Svensson".
            DISPLAY NPSPANLG.selger WITH FRAME {&FRAME-NAME}.
          END.           
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.saksbehandler
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.saksbehandler DLGOKCAN
ON ANY-PRINTABLE OF NPSPANLG.saksbehandler IN FRAME DLGOKCAN /* Saksbeh. */
DO:
  seek-item:
  DO i = 1 TO SELF:NUM-ITEMS:
    IF SELF:ENTRY(i) BEGINS LAST-EVENT:FUNCTION
    THEN DO:
        SELF:SCREEN-VALUE = SELF:ENTRY(i).
        LEAVE seek-item.
    END.
  END.
  IF i > SELF:NUM-ITEMS
  THEN BELL.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.saksbehandler DLGOKCAN
ON CURSOR-DOWN OF NPSPANLG.saksbehandler IN FRAME DLGOKCAN /* Saksbeh. */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.saksbehandler DLGOKCAN
ON CURSOR-UP OF NPSPANLG.saksbehandler IN FRAME DLGOKCAN /* Saksbeh. */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.selger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.selger DLGOKCAN
ON ANY-PRINTABLE OF NPSPANLG.selger IN FRAME DLGOKCAN /* Selger */
DO:
  seek-item:
  DO i = 1 TO SELF:NUM-ITEMS:
    IF SELF:ENTRY(i) BEGINS LAST-EVENT:FUNCTION
    THEN DO:
        SELF:SCREEN-VALUE = SELF:ENTRY(i).
        LEAVE seek-item.
    END.
  END.
  IF i > SELF:NUM-ITEMS
  THEN BELL.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.selger DLGOKCAN
ON CURSOR-DOWN OF NPSPANLG.selger IN FRAME DLGOKCAN /* Selger */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.selger DLGOKCAN
ON CURSOR-UP OF NPSPANLG.selger IN FRAME DLGOKCAN /* Selger */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DLGOKCAN 


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
  SESSION:SET-WAIT-STATE("").
  current-rec = dynamic-function('getCurrentRec' in hParent).
  nyRecord    = logical(dynamic-function('getNyRecord' in hParent)).
  prosjektidparam = int(jboxSession:Instance:getJBoxAttribute('ProsjektId')).
  prosjektNavnparam = jboxSession:Instance:getJBoxAttribute('ProsjektNavn').
  
   RUN fyll_combo.

  IF nyRecord THEN
      RUN nyttAnlegg.
  ELSE
      RUN endreAnlegg.

END.    
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DLGOKCAN  _DEFAULT-DISABLE
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
  HIDE FRAME DLGOKCAN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DLGOKCAN  _DEFAULT-ENABLE
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
  IF AVAILABLE NPSPANLG THEN 
    DISPLAY NPSPANLG.dato NPSPANLG.aktivt NPSPANLG.endrings_laas 
          NPSPANLG.konsulentens_saksbeh NPSPANLG.kundedistriktNr 
          NPSPANLG.saksbehandler NPSPANLG.selger NPSPANLG.anbudsfrist 
          NPSPANLG.byggestart NPSPANLG.oppf_aar NPSPANLG.opplysninger 
      WITH FRAME DLGOKCAN.
  ENABLE NPSPANLG.beskrevet NPSPANLG.dato NPSPANLG.aktivt 
         NPSPANLG.endrings_laas NPSPANLG.anlegg Konsulent 
         NPSPANLG.konsulentens_saksbeh NPSPANLG.kundedistriktNr 
         NPSPANLG.saksbehandler NPSPANLG.selger NPSPANLG.entreprise 
         NPSPANLG.anbudsfrist NPSPANLG.byggestart NPSPANLG.oppf_uke 
         NPSPANLG.oppf_aar NPSPANLG.leveringstid NPSPANLG.opplysninger Btn_OK 
         Btn_Cancel Btn_Help COMBO-SPINN RECT-30 
      WITH FRAME DLGOKCAN.
  {&OPEN-BROWSERS-IN-QUERY-DLGOKCAN}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreAnlegg DLGOKCAN 
PROCEDURE endreAnlegg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND NPSPANLG WHERE ROWID(NPSPANLG) = Current-Rec EXCLUSIVE-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE NPSPANLG THEN DO with frame {&Frame-name}:
    DISPLAY NPSPANLG.anleggsnr   WITH FRAME DLGOKCAN.
    FIND NPKUNDE WHERE NPKUNDE.kundenr = NPSPANLG.kundenr
      NO-LOCK NO-WAIT NO-ERROR.
    IF AVAILABLE NPKUNDE THEN  konsulent = NPKUNDE.kundenavn.
    ELSE
      RETURN.
            
    UPDATE 
      norcalc.NPSPANLG.dato NPSPANLG.aktivt NPSPANLG.endrings_laas 
      norcalc.NPSPANLG.anlegg Konsulent NPSPANLG.konsulentens_saksbeh
      NPSPANLG.kundedistriktnr NPSPANLG.saksbehandler NPSPANLG.selger 
      norcalc.NPSPANLG.entreprise 
      norcalc.NPSPANLG.beskrevet 
      norcalc.NPSPANLG.anbudsfrist 
      norcalc.NPSPANLG.byggestart
      norcalc.NPSPANLG.oppf_uke NPSPANLG.oppf_aar NPSPANLG.leveringstid 
      NPSPANLG.opplysninger
       Btn_OK Btn_Cancel Btn_Help
    WITH FRAME DLGOKCAN.
  END.
  ELSE DO:
    MESSAGE 'Tabellen for Spiroventtanlegg er opptatt. Prøv igjen om en liten stund' VIEW-AS ALERT-BOX TITLE 'STOPP'.
    RETURN.
  END.
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_combo DLGOKCAN 
PROCEDURE fyll_combo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var iGruppeId_saksbehandler as int no-undo.
def var iGruppeId_selger as int no-undo.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      iGruppeId_saksbehandler       = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Saksbehandler"','iGruppeId')) 
      iGruppeId_selger              = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Selger"','iGruppeId'))
      npspanlg.Entreprise:DELIMITER          = '|'
      npspanlg.Entreprise:LIST-ITEM-PAIRS    = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListEntreprise' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
      npspanlg.beskrevet:DELIMITER           = '|'
      npspanlg.beskrevet:LIST-ITEM-PAIRS     = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListBeskrevet' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
      npspanlg.selger:DELIMITER              = '|'
      npspanlg.selger:LIST-ITEM-PAIRS        = JBoxServerAPI:Instance:FieldList("Persongruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_selger) + ", First Person of PersonGruppe where bAktiv AND person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
      npspanlg.saksbehandler:DELIMITER       = '|'
      npspanlg.saksbehandler:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("PersonGruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_saksbehandler) + ", First Person of PersonGruppe where bAktiv and person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
      npspanlg.kundedistriktnr:DELIMITER       = '|'
      npspanlg.kundedistriktnr:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPkundedistrikt;Kundedistriktnr|KundeDistriktNavn;KundeDistriktNr","WHERE true" + ' BY KundedistriktNr')
    .
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyttAnlegg DLGOKCAN 
PROCEDURE nyttAnlegg :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
     iNextAnleggsnr = 0.
     create NPSPANLG.
     NPSPANLG.dato = TODAY.
     NPSPANLG.oppf_aar = YEAR(TODAY).
     NPSPANLG.anleggsnr = iNextAnleggsnr.
     NPSPANLG.anlegg = prosjektNavnParam.
     NPSPANLG.leveringstid = 'Vanligvis lager'.
     DISPLAY NPSPANLG.anleggsnr  NPSPANLG.anlegg NPSPANLG.dato 
        WITH FRAME  {&FRAME-NAME}.
  ENABLE  COMBO-SPINN WITH FRAME DLGOKCAN.
 UPDATE 
        RECT-30 norcalc.NPSPANLG.dato norcalc.NPSPANLG.anlegg Konsulent 
        NPSPANLG.konsulentens_saksbeh
        NPSPANLG.saksbehandler NPSPANLG.kundedistriktnr NPSPANLG.selger 
        norcalc.NPSPANLG.entreprise norcalc.NPSPANLG.beskrevet 
        norcalc.NPSPANLG.anbudsfrist norcalc.NPSPANLG.byggestart
        norcalc.NPSPANLG.oppf_uke NPSPANLG.oppf_aar NPSPANLG.leveringstid 
        NPSPANLG.opplysninger
         Btn_OK Btn_Cancel Btn_Help
      WITH FRAME DLGOKCAN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

