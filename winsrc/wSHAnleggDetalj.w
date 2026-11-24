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
 &SCOPED-DEFINE AdvGuiWin

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE bOk           AS LOG               NO-UNDO.
DEFINE VARIABLE ix            AS INTEGER           NO-UNDO.
DEFINE VARIABLE hBrowse       AS HANDLE            NO-UNDO.
DEFINE VARIABLE hQuery        AS HANDLE            NO-UNDO.
DEFINE VARIABLE hToolbar      AS HANDLE            NO-UNDO.
DEFINE VARIABLE hFieldMap     AS HANDLE            NO-UNDO.

DEFINE VARIABLE iProsjektid   AS INTEGER           NO-UNDO.
DEFINE VARIABLE cProsjektnavn AS CHARACTER         NO-UNDO.
DEFINE VARIABLE iAnleggsnr    AS INTEGER           NO-UNDO.
DEFINE VARIABLE cAnlegg       AS CHARACTER         NO-UNDO.

DEFINE VARIABLE oContainer    AS JBoxContainer     NO-UNDO.
DEFINE VARIABLE oParentBrowse AS JBoxBrowse        NO-UNDO.
DEFINE VARIABLE oDato         AS JBoxDevExDateEdit NO-UNDO.
DEFINE VARIABLE oAnbudsfrist  AS JBoxDevExDateEdit NO-UNDO.
DEFINE VARIABLE oLeveringstid AS JBoxDevExDateEdit NO-UNDO.
DEFINE VARIABLE oByggestart   AS JBoxDevExDateEdit NO-UNDO.


/* Code for Definitions: */

/*** Start instance property definitions for JBoxQuery object oQryNPSHANLG ***/
DEFINE VARIABLE oQryNPSHANLG  AS JBoxQuery         NO-UNDO.

DEFINE TEMP-TABLE NPSHANLG
  FIELD aktivt               AS LOGICAL
  FIELD anbudsfrist          AS DATE
  FIELD anlegg               AS CHARACTER
  FIELD anleggsnr            AS INTEGER
  FIELD anleggstype          AS CHARACTER
  FIELD arkivnr              AS CHARACTER
  FIELD beskrevet            AS CHARACTER
  FIELD byggestart           AS DATE
  FIELD dato                 AS DATE
  FIELD endrings_laas        AS LOGICAL
  FIELD entreprise           AS CHARACTER
  FIELD faktura#             AS INTEGER
  FIELD konsulentens_saksbeh AS CHARACTER
  FIELD konsulentid          AS INTEGER
  FIELD konsulentnr          AS CHARACTER
  FIELD kundenr              AS CHARACTER
  FIELD leveringstid         AS CHARACTER
  FIELD oppf_aar             AS INTEGER
  FIELD oppf_uke             AS INTEGER
  FIELD opplysninger         AS CHARACTER
  FIELD prosjektid           AS INTEGER
  FIELD referanse_tekst      AS CHARACTER
  FIELD saksbehandler        AS CHARACTER
  FIELD salgsdistrikt        AS CHARACTER
  FIELD selger               AS CHARACTER
  FIELD sikker               AS LOGICAL
  FIELD standardpris         AS DECIMAL
  FIELD RowIdent1            AS CHARACTER 
  FIELD RowCount             AS INTEGER
  INDEX idxRowids RowIdent1
  .
DEFINE BUFFER v_NPSHANLG FOR temp-table NPSHANLG.

FUNCTION getTableHandleQryNPSHANLG RETURNS HANDLE().
  RETURN BUFFER NPSHANLG:HANDLE:TABLE-HANDLE.
END FUNCTION.
FUNCTION getBuffersAndFieldsQryNPSHANLG RETURNS CHARACTER().
  RETURN 
    'NPSHANLG'.
END FUNCTION.
FUNCTION getQueryJoinQryNPSHANLG RETURNS CHARACTER().
  RETURN ''.
END FUNCTION.
/*** End instance property settings for JBoxQuery object oQryNPSHANLG ***/

DEFINE VARIABLE oFmNPSHANLG AS JBoxFieldMap  NO-UNDO.
DEFINE VARIABLE otbNPSHANLG AS JBoxToolbar   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define QUERY-NAME QUERY-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHANLG

/* Definitions for QUERY QUERY-2                                        */
&Scoped-define SELF-NAME QUERY-2
&Scoped-define QUERY-STRING-QUERY-2 FOR EACH NPSHANLG NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-QUERY-2 OPEN QUERY {&SELF-NAME} FOR EACH NPSHANLG NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-QUERY-2 NPSHANLG
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-2 NPSHANLG


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHANLG new_tbNPSHANLG edit_tbNPSHANLG ~
copy_tbNPSHANLG save_tbNPSHANLG undo_tbNPSHANLG delete_tbNPSHANLG ~
ProsjektId Aktivt endrings_laas sikker anleggsnr anlegg kundenr ~
btnkonsulent Konsulentens_saksbeh Saksbehandler beskrevet byggestart ~
entreprise selger Leveringstid dato salgsdistrikt oppf_aar oppf_uke ~
anbudsfrist standardpris opplysninger 
&Scoped-Define DISPLAYED-OBJECTS ProsjektId prosjektnavn Aktivt ~
endrings_laas sikker anleggsnr anlegg kundenr Kundenavn ~
Konsulentens_saksbeh Saksbehandler beskrevet byggestart entreprise selger ~
Leveringstid dato salgsdistrikt oppf_aar oppf_uke anbudsfrist standardpris ~
opplysninger lblOpplysninger 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnkonsulent 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON copy_tbNPSHANLG 
     IMAGE-UP FILE "img/ico/documents.ico":U
     LABEL "Copy" 
     SIZE 7.75 BY 1.94 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPSHANLG 
     IMAGE-UP FILE "img\ico\document_delete.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_delete_disabled.gif":U
     LABEL "Delete" 
     SIZE 7.75 BY 1.94 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON edit_tbNPSHANLG 
     IMAGE-UP FILE "img/ico/document_edit.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_edit_disabled.gif":U
     LABEL "Edit" 
     SIZE 7.75 BY 1.94 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON new_tbNPSHANLG 
     IMAGE-UP FILE "img\ico\document_add.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_add_disabled.gif":U
     LABEL "New" 
     SIZE 7.75 BY 1.94 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON save_tbNPSHANLG 
     IMAGE-UP FILE "img/ico/floppy_disk.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/floppy_disk_disabled.gif":U
     LABEL "Save" 
     SIZE 7.75 BY 1.94 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPSHANLG 
     IMAGE-UP FILE "img/ico/undo.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/undo_disabled.gif":U
     LABEL "Undo" 
     SIZE 7.75 BY 1.94 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE beskrevet AS CHARACTER FORMAT "X(10)" 
     LABEL "Beskrevet" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 25 BY 1.

DEFINE VARIABLE entreprise AS CHARACTER FORMAT "X(8)" 
     LABEL "Entreprise" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 14 BY 1.

DEFINE VARIABLE Saksbehandler AS CHARACTER FORMAT "X(22)" 
     LABEL "Saksbehandler" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 31 BY 1.

DEFINE VARIABLE salgsdistrikt AS CHARACTER FORMAT "X(30)" 
     LABEL "Salgsdistrikt" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 31 BY 1 TOOLTIP "Velg distrikt".

DEFINE VARIABLE selger AS CHARACTER FORMAT "X(25)" 
     LABEL "Selger" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 31 BY 1.

DEFINE VARIABLE opplysninger AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 145 BY 3.81 NO-UNDO.

DEFINE VARIABLE anbudsfrist AS DATE FORMAT "99.99.9999":U 
     LABEL "Anbudsfrist" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE anlegg AS CHARACTER FORMAT "X(100)" 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 TOOLTIP "Anleggets navn (oppdragssted)".

DEFINE VARIABLE anleggsnr AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Anleggsnr" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE byggestart AS DATE FORMAT "99.99.9999" 
     LABEL "Byggestart" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE dato AS DATE FORMAT "99.99.9999" 
     LABEL "Dato" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE Konsulentens_saksbeh AS CHARACTER FORMAT "X(60)":U 
     LABEL "v/" 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1 NO-UNDO.

DEFINE VARIABLE Kundenavn AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE kundenr AS CHARACTER FORMAT "X(8)" 
     LABEL "Kundenr" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE lblOpplysninger AS CHARACTER FORMAT "X(256)":U INITIAL "Opplysninger:" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 TOOLTIP "Vil bli skrevet pï¿½ anleggsrapport" NO-UNDO.

DEFINE VARIABLE Leveringstid AS DATE FORMAT "99.99.9999":U 
     LABEL "Leveringstid" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE oppf_aar AS INTEGER FORMAT "9999" INITIAL 0 
     LABEL "Oppf. år/uke" 
     VIEW-AS FILL-IN 
     SIZE 7.63 BY 1 TOOLTIP "Oppgi låst for neste oppfølging".

DEFINE VARIABLE oppf_uke AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "/" 
     VIEW-AS FILL-IN 
     SIZE 4.75 BY 1.

DEFINE VARIABLE ProsjektId AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Prosjektid" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE prosjektnavn AS CHARACTER FORMAT "X(100)" 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1 TOOLTIP "Anleggets navn (oppdragssted)".

DEFINE VARIABLE standardpris AS DECIMAL FORMAT ">>,>>>,>>9.99" INITIAL 0 
     LABEL "Standardpris" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.

DEFINE RECTANGLE tbNPSHANLG
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 124 BY 2.13.

DEFINE VARIABLE Aktivt AS LOGICAL INITIAL no 
     LABEL "Aktivt" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.38 BY .81 NO-UNDO.

DEFINE VARIABLE endrings_laas AS LOGICAL INITIAL no 
     LABEL "Låst" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .81 TOOLTIP "Låst for endring" NO-UNDO.

DEFINE VARIABLE sikker AS LOGICAL INITIAL no 
     LABEL "Sikker" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.38 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY QUERY-2 FOR 
      NPSHANLG SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHANLG AT ROW 1.09 COL 1.25 WIDGET-ID 26
     edit_tbNPSHANLG AT ROW 1.09 COL 9.25 WIDGET-ID 28
     copy_tbNPSHANLG AT ROW 1.09 COL 17 WIDGET-ID 30
     save_tbNPSHANLG AT ROW 1.09 COL 24.75 WIDGET-ID 34
     undo_tbNPSHANLG AT ROW 1.09 COL 32.63 WIDGET-ID 32
     delete_tbNPSHANLG AT ROW 1.09 COL 40.38 WIDGET-ID 36
     ProsjektId AT ROW 3.63 COL 16 COLON-ALIGNED
     prosjektnavn AT ROW 3.63 COL 26 COLON-ALIGNED NO-LABEL
     Aktivt AT ROW 3.63 COL 87 WIDGET-ID 52
     endrings_laas AT ROW 3.63 COL 98 WIDGET-ID 50
     sikker AT ROW 3.63 COL 112 WIDGET-ID 58
     anleggsnr AT ROW 4.81 COL 16 COLON-ALIGNED
     anlegg AT ROW 4.81 COL 26 COLON-ALIGNED NO-LABEL
     kundenr AT ROW 6 COL 16 COLON-ALIGNED
     btnkonsulent AT ROW 6 COL 28 WIDGET-ID 62 NO-TAB-STOP 
     Kundenavn AT ROW 6 COL 31 COLON-ALIGNED NO-LABEL
     Konsulentens_saksbeh AT ROW 6 COL 84 COLON-ALIGNED
     Saksbehandler AT ROW 7.66 COL 16 COLON-ALIGNED WIDGET-ID 54
     beskrevet AT ROW 7.66 COL 60 COLON-ALIGNED WIDGET-ID 46
     byggestart AT ROW 7.75 COL 98 COLON-ALIGNED
     entreprise AT ROW 8.56 COL 60 COLON-ALIGNED WIDGET-ID 44
     selger AT ROW 8.88 COL 16 COLON-ALIGNED WIDGET-ID 38
     Leveringstid AT ROW 8.91 COL 98 COLON-ALIGNED
     dato AT ROW 9.59 COL 60 COLON-ALIGNED
     salgsdistrikt AT ROW 10.06 COL 16 COLON-ALIGNED WIDGET-ID 40
     oppf_aar AT ROW 10.16 COL 99 COLON-ALIGNED
     oppf_uke AT ROW 10.16 COL 109 COLON-ALIGNED
     anbudsfrist AT ROW 10.75 COL 60 COLON-ALIGNED
     standardpris AT ROW 11.84 COL 60 COLON-ALIGNED
     opplysninger AT ROW 14.5 COL 2 NO-LABEL WIDGET-ID 64
     lblOpplysninger AT ROW 13.5 COL 2 NO-LABEL
     tbNPSHANLG AT ROW 1 COL 1 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 151.63 BY 17.66 WIDGET-ID 100.


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
         HEIGHT             = 17.66
         WIDTH              = 151.63
         MAX-HEIGHT         = 23.53
         MAX-WIDTH          = 151.63
         VIRTUAL-HEIGHT     = 23.53
         VIRTUAL-WIDTH      = 151.63
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
/* SETTINGS FOR FILL-IN Kundenavn IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lblOpplysninger IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       lblOpplysninger:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Opplysninger:".

/* SETTINGS FOR FILL-IN prosjektnavn IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       tbNPSHANLG:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,edit;Edit,copy;Copy,save;Save,undo;Undo,delete;Deletemaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-2
/* Query rebuild information for QUERY QUERY-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH NPSHANLG NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is FRAME DEFAULT-FRAME @ ( 4.56 , 126 )
*/  /* QUERY QUERY-2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <Insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE 
  DO:
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


&Scoped-define SELF-NAME btnkonsulent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnkonsulent C-Win
ON CHOOSE OF btnkonsulent IN FRAME DEFAULT-FRAME /* ... */
DO:
    /* To manipulate the lookup query object add the callback procedure hook "myLookupObject" 
       (probably use "WHERE false" as the initial query in this case) */
  
    JBoxServerAPI:Instance:Lookup("NPKunde"
      + ";kundenavn"
      + ";kundenr"
      ,"WHERE aktiv and er_konsulent"
      ,"kundenavn,kundenr"   /* <- return values for these fields */
      ).

    IF JBoxServerAPI:Instance:LookupOk THEN 
    DO WITH FRAME {&FRAME-NAME}:                                                                                                                 
      ASSIGN 
        kundenavn:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("kundenavn")
        kundenr:SCREEN-VALUE   = JBoxServerAPI:Instance:LookupValue("kundenr")
        .

      APPLY "any-printable" TO kundenr.
    END.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME QUERY-2
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
  DO:
    IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
    DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
    PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
    RUN disable_UI.
  END.

{incl/wintrigg.i}
/*{incl/conttrigg.i oBrw<>:BROWSE-HANDLE} */

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

  IF NOT THIS-PROCEDURE:PERSISTENT THEN 
  DO:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayRecord C-Win 
PROCEDURE DisplayRecord :
/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  RUN super.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF oQryNPSHANLG:IsCurrent AND valid-object(oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT) THEN 
    DO:
      IF VALID-HANDLE(oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE) AND oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE:avail THEN 
        ASSIGN 
          prosjektid:screen-value   = oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::prosjektid
          prosjektnavn:screen-value = oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::Prosjekt_navn
          prosjektid:modified       = FALSE
          prosjektnavn:modified     = FALSE
          .
      IF AVAILABLE NPSHANLG THEN 
        ASSIGN 
          Kundenavn:screen-value = JBoxServerAPI:Instance:FieldValues('NPKunde','WHERE kundenr = ' + quoter(NPSHANLG.kundenr),'kundenavn')
          .
    END.
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditRecord C-Win 
PROCEDURE EditRecord :
/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    RUN super.
    
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
  DISPLAY ProsjektId prosjektnavn Aktivt endrings_laas sikker anleggsnr anlegg 
          kundenr Kundenavn Konsulentens_saksbeh Saksbehandler beskrevet 
          byggestart entreprise selger Leveringstid dato salgsdistrikt oppf_aar 
          oppf_uke anbudsfrist standardpris opplysninger lblOpplysninger 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHANLG new_tbNPSHANLG edit_tbNPSHANLG copy_tbNPSHANLG 
         save_tbNPSHANLG undo_tbNPSHANLG delete_tbNPSHANLG ProsjektId Aktivt 
         endrings_laas sikker anleggsnr anlegg kundenr btnkonsulent 
         Konsulentens_saksbeh Saksbehandler beskrevet byggestart entreprise 
         selger Leveringstid dato salgsdistrikt oppf_aar oppf_uke anbudsfrist 
         standardpris opplysninger 
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
  DEFINE VARIABLE iGruppeId_saksbehandler AS INTEGER NO-UNDO.
  DEFINE VARIABLE iGruppeId_selger        AS INTEGER NO-UNDO.

  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().

  DO WITH FRAME {&FRAME-NAME}:

    oQryNPSHANLG = NEW JBoxQuery('NPSHANLG').

    oFmNPSHANLG = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
    oFmNPSHANLG:updateFields = 'anlegg,anbudsfrist,byggestart,konsulentens_saksbeh,kundenr,leveringstid,oppf_aar,oppf_uke,dato,standardpris,saksbehandler,salgsdistrikt,endrings_laas,aktivt,beskrevet,entreprise,selger,sikker,btnKonsulent,opplysninger'.  
    oFmNPSHANLG:DisplayFields = 'Prosjektid,anleggsnr'.
    oFmNPSHANLG:customCreateProc = 'npshanlg_create.p'.
    oFmNPSHANLG:customDeleteValProc = 'dlt_npshanlg.p'.
    oFmNPSHANLG:customUpdateValProc = 'upd_npshanlg.p'.
    
    oFmNPSHANLG:QUERY-OBJECT = oQryNPSHANLG.
    otbNPSHANLG = NEW JBoxToolbar(tbNPSHANLG:HANDLE).

    oQryNPSHANLG:TOOLBAR-OBJECT = otbNPSHANLG.
    oFmNPSHANLG:TOOLBAR-OBJECT = otbNPSHANLG.
  
    ASSIGN
      iGruppeId_saksbehandler       = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Saksbehandler"','iGruppeId')) 
      iGruppeId_selger              = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Selger"','iGruppeId'))
      Entreprise:DELIMITER          = '|'
      Entreprise:LIST-ITEM-PAIRS    = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListEntreprise' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
      beskrevet:DELIMITER           = '|'
      beskrevet:LIST-ITEM-PAIRS     = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListBeskrevet' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
      selger:DELIMITER              = '|'
      selger:LIST-ITEM-PAIRS        = JBoxServerAPI:Instance:FieldList("Persongruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_selger) + ", First Person of PersonGruppe where bAktiv AND person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
      /*    anleggstype:DELIMITER = '|'                                                                                                                                                                                                                                                            */
      /*    anleggstype:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPanleggstype,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_selger) + ", First Person of PersonGruppe where bAktiv AND person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")*/
      saksbehandler:DELIMITER       = '|'
      saksbehandler:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("PersonGruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_saksbehandler) + ", First Person of PersonGruppe where bAktiv and person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
      salgsdistrikt:DELIMITER       = '|'
      salgsdistrikt:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPkundedistrikt;Kundedistriktnr|KundeDistriktNavn;KundeDistriktNr","WHERE true" + ' BY KundedistriktNr')
      .
  &IF DEFINED(AdvGuiWin) &THEN
    oDato = NEW JBoxDevExDateEdit(THIS-PROCEDURE,Dato:HANDLE).
    oDato:RegisterWithJukeBox(NO).
    oDato:CreateDisplayLink(oFmNPSHANLG:BUFFER-HANDLE,"Dato").

    oAnbudsfrist = NEW JBoxDevExDateEdit(THIS-PROCEDURE,Anbudsfrist:HANDLE).
    oAnbudsfrist:RegisterWithJukeBox(NO).
    oAnbudsfrist:CreateDisplayLink(oFmNPSHANLG:BUFFER-HANDLE,"Anbudsfrist").
    
    oByggestart = NEW JBoxDevExDateEdit(THIS-PROCEDURE,Byggestart:HANDLE).
    oByggestart:RegisterWithJukeBox(NO).
    oByggestart:CreateDisplayLink(oFmNPSHANLG:BUFFER-HANDLE,"Byggestart").

    oLeveringstid = NEW JBoxDevExDateEdit(THIS-PROCEDURE,Leveringstid:HANDLE).
    oLeveringstid:RegisterWithJukeBox(NO).
    oLeveringstid:CreateDisplayLink(oFmNPSHANLG:BUFFER-HANDLE,"Leveringstid").
  &ENDIF
  
  END.


  oContainer:initResize(900,700).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveOfFieldHandle C-Win 
PROCEDURE LeaveOfFieldHandle :
/*------------------------------------------------------------------------------
    Purpose:     Retrieve lookup values when a foreign key field is modified
    Parameters:  Handle to foreign key field
    Notes:       The FieldValues method is a short version of Find
  ------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER ihField AS HANDLE NO-UNDO.

  IF ihField:MODIFIED THEN 
  DO WITH FRAME {&FRAME-NAME}:
    CASE ihField:NAME:
      WHEN "kundenr" THEN 
        kundenr:SCREEN-VALUE = JBoxServerAPI:Instance:FieldValues("NPKunde","WHERE kundenr = '" + ihField:SCREEN-VALUE + "'","kundenr").
    END CASE.

  END.

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
/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF VALID-OBJECT(oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT) THEN DO:
      IF VALID-HANDLE(oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE) AND oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE:avail THEN 
        ASSIGN
          iProsjektid   = oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::prosjektid
          cProsjektnavn = oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::Prosjekt_navn
/*          iAnleggsnr    = oQryNPSHANLG:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::anleggsnr*/
/*          cAnlegg       = oQryNPSHANLG:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::anlegg   */
          .
    END.
    
    RUN super.
    
    ASSIGN
      dato:screen-value         = STRING(TODAY)
      oppf_aar:screen-value     = STRING(YEAR(TODAY))
      ProsjektId:screen-value   = STRING(iProsjektid)
      prosjektnavn:screen-value = cProsjektnavn
      anlegg:screen-value       = cProsjektnavn
      endrings_laas:SENSITIVE   = false
      Aktivt:SENSITIVE          = false
      .
    IF oQryNPSHANLG:IsCurrent AND valid-object(oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT) THEN 
    DO:
      IF VALID-HANDLE(oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE) AND oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE:avail THEN 
        ASSIGN 
          prosjektid:screen-value   = oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::prosjektid
          prosjektnavn:screen-value = oQryNPSHANLG:PARENT-BROWSE-OBJECT:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::Prosjekt_navn
          prosjektid:modified       = FALSE
          prosjektnavn:modified     = FALSE
          .
    END.    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
if oFmNPSHANLG:isCopy then 
  assign /* for use when doing copy*/
    oFmNPSHANLG:bufferExtraFields = 'CopyRowid' 
    oFmNPSHANLG:bufferExtraValues = string(npshanlg.RowIdent1).
else
  assign 
    oFmNPSHANLG:bufferExtraFields = ''
    oFmNPSHANLG:bufferExtraValues = ''.
  
run super.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

