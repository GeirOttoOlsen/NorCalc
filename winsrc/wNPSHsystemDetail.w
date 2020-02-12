&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description:        JukeBox suppressed window template
                      This template is for use with a tabfolder or viewer object
                      to parent the suppressed window

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:            brynjar@chemistry.no

  Created:           30.march.2008

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
&SCOPED-DEFINE AdvGuiWin YES

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR bOk                 AS LOG    NO-UNDO.
DEF VAR ix                  AS INT    NO-UNDO.
DEF VAR hBrowse             AS HANDLE NO-UNDO.
DEF VAR hToolbar            AS HANDLE NO-UNDO.
DEF VAR hParent             AS HANDLE NO-UNDO.
DEF VAR hButton             AS HANDLE NO-UNDO.

DEF VAR hQuery              AS HANDLE NO-UNDO.
DEF VAR hFieldMap           AS HANDLE NO-UNDO.

DEF VAR oReg_dato           AS JBoxDevExDateEdit NO-UNDO.

DEF VAR dPrimHastighet      AS DECIMAL NO-UNDO.
DEF VAR dSekHastighet       AS DECIMAL NO-UNDO.
DEF VAR dDimmVerdi          AS DECIMAL NO-UNDO.
DEF VAR editModus           AS INT     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rectToolbar rectOppsett rectInfo ~
SHUNTTEGNING systemnr systembetegnelse koblings_alternativ sek_effekt ~
prim_effekt beregnet_anvendelse sek_temp_inn prim_temp_inn sek_temp_ut ~
prim_temp_ut sek_kapasitet prim_kapasitet btnReset type ~
ms_shuntventil_i_leveranse ms_ventiltype tillegg_montasje tillegg_kapsling ~
system_kode lblVentilType 
&Scoped-Define DISPLAYED-OBJECTS systemnr systembetegnelse anvendelse ~
koblings_alternativ prim_konst_var sek_konst_var reguleringsventil ~
ventil_type sek_effekt prim_effekt beregnet_anvendelse sek_temp_inn ~
prim_temp_inn sek_temp_ut prim_temp_ut sek_kapasitet prim_kapasitet ~
ms_shuntventil_i_leveranse ms_ventiltype shunt_dimmensjon tillegg_montasje ~
tillegg_kapsling system_kode lblVentilType 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD InitializeResize C-Win 
FUNCTION InitializeResize RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnReset 
     LABEL "&Reset" 
     SIZE 10.4 BY 1.14.

DEFINE VARIABLE koblings_alternativ AS CHARACTER FORMAT "X(2)" INITIAL "1" 
     LABEL "Kobl.alt." 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEM-PAIRS "1","1"
     DROP-DOWN-LIST
     SIZE 46 BY 1.

DEFINE VARIABLE ms_ventiltype AS CHARACTER FORMAT "X(256)":U 
     LABEL "MS-Ventiltype" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "item1","item1"
     DROP-DOWN-LIST
     SIZE 20.4 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE anvendelse AS CHARACTER FORMAT "X(15)" INITIAL "Varme/Kjøle" 
     LABEL "Anvendelse" 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1.

DEFINE VARIABLE lblVentilType AS CHARACTER FORMAT "X(256)":U INITIAL "Ventil:" 
      VIEW-AS TEXT 
     SIZE 7 BY .62 NO-UNDO.

DEFINE VARIABLE prim_effekt AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "Effekt" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE prim_kapasitet AS DECIMAL FORMAT "->>9.999" INITIAL 0 
     LABEL "Kapasitet" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE prim_konst_var AS CHARACTER FORMAT "X(15)" INITIAL "Konstant" 
     LABEL "Primærkrets" 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1.

DEFINE VARIABLE prim_temp_inn AS DECIMAL FORMAT "->>9.99" INITIAL 0 
     LABEL "Temp. inn" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE prim_temp_ut AS DECIMAL FORMAT "->>9.99" INITIAL 0 
     LABEL "Temp. ut" 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE reguleringsventil AS CHARACTER FORMAT "X(20)" INITIAL "Sekundærkrets" 
     LABEL "Reguleringsventil i" 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1.

DEFINE VARIABLE sek_effekt AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE sek_kapasitet AS DECIMAL FORMAT "->>9.999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE sek_konst_var AS CHARACTER FORMAT "X(15)" INITIAL "Konstant" 
     LABEL "Sekundærkrets" 
     VIEW-AS FILL-IN 
     SIZE 21.2 BY 1.

DEFINE VARIABLE sek_temp_inn AS DECIMAL FORMAT "->>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE sek_temp_ut AS DECIMAL FORMAT "->>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE shunt_dimmensjon AS CHARACTER FORMAT "X(3)" 
     LABEL "Shuntdimmensjon" 
     VIEW-AS FILL-IN 
     SIZE 7.6 BY 1.

DEFINE VARIABLE systembetegnelse AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1.

DEFINE VARIABLE systemnr AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Systemnr" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE system_kode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Systemkode" 
     VIEW-AS FILL-IN 
     SIZE 117 BY 1 NO-UNDO.

DEFINE VARIABLE tillegg_kapsling AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tillegg kapsling" 
     VIEW-AS FILL-IN 
     SIZE 117 BY 1 NO-UNDO.

DEFINE VARIABLE tillegg_montasje AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tillegg montasje" 
     VIEW-AS FILL-IN 
     SIZE 117 BY 1 NO-UNDO.

DEFINE VARIABLE ventil_type AS CHARACTER FORMAT "X(10)" 
     LABEL "Ventiltype" 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1.

DEFINE IMAGE SHUNTTEGNING
     SIZE 39.4 BY 11.67.

DEFINE VARIABLE beregnet_anvendelse AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "item1", "item1"
     SIZE 35.8 BY 6.91.

DEFINE VARIABLE type AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "item1", "item1"
     SIZE 16 BY .95.

DEFINE RECTANGLE rectInfo
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 4.52.

DEFINE RECTANGLE rectOppsett
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 7.38.

DEFINE RECTANGLE rectToolbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 148 BY 1.71.

DEFINE VARIABLE ms_shuntventil_i_leveranse AS LOGICAL INITIAL no 
     LABEL "MS - Shuntventil med i leveranse" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .76.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     systemnr AT ROW 4.1 COL 10 COLON-ALIGNED
     systembetegnelse AT ROW 4.1 COL 21 COLON-ALIGNED NO-LABEL
     anvendelse AT ROW 4.33 COL 77 COLON-ALIGNED
     koblings_alternativ AT ROW 5.29 COL 10 COLON-ALIGNED WIDGET-ID 22
     prim_konst_var AT ROW 5.29 COL 77 COLON-ALIGNED
     sek_konst_var AT ROW 5.29 COL 120 COLON-ALIGNED
     reguleringsventil AT ROW 6.24 COL 77 COLON-ALIGNED
     ventil_type AT ROW 7.24 COL 77 COLON-ALIGNED
     sek_effekt AT ROW 8.33 COL 31.8 COLON-ALIGNED NO-LABEL
     prim_effekt AT ROW 8.38 COL 17.4 COLON-ALIGNED
     beregnet_anvendelse AT ROW 9.1 COL 60 NO-LABEL WIDGET-ID 72
     sek_temp_inn AT ROW 9.38 COL 31.8 COLON-ALIGNED NO-LABEL
     prim_temp_inn AT ROW 9.43 COL 17.4 COLON-ALIGNED
     sek_temp_ut AT ROW 10.48 COL 31.8 COLON-ALIGNED NO-LABEL
     prim_temp_ut AT ROW 10.52 COL 17.4 COLON-ALIGNED
     sek_kapasitet AT ROW 11.52 COL 31.8 COLON-ALIGNED NO-LABEL
     prim_kapasitet AT ROW 11.57 COL 17.4 COLON-ALIGNED
     btnReset AT ROW 12.91 COL 41 WIDGET-ID 88
     type AT ROW 15.29 COL 22 NO-LABEL WIDGET-ID 76
     ms_shuntventil_i_leveranse AT ROW 16.71 COL 22 WIDGET-ID 74
     ms_ventiltype AT ROW 17.43 COL 20 COLON-ALIGNED WIDGET-ID 84
     shunt_dimmensjon AT ROW 18.62 COL 20 COLON-ALIGNED
     tillegg_montasje AT ROW 20.76 COL 25 COLON-ALIGNED
     tillegg_kapsling AT ROW 21.71 COL 25 COLON-ALIGNED
     system_kode AT ROW 22.67 COL 25 COLON-ALIGNED
     lblVentilType AT ROW 15.29 COL 13 COLON-ALIGNED NO-LABEL
     " Sekundær" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 7.48 COL 33.8 WIDGET-ID 52
     " Primær" VIEW-AS TEXT
          SIZE 10.8 BY .67 AT ROW 7.57 COL 19.4 WIDGET-ID 54
     "W" VIEW-AS TEXT
          SIZE 4.4 BY .67 AT ROW 8.48 COL 46.4 WIDGET-ID 56
     "°C" VIEW-AS TEXT
          SIZE 5.8 BY .67 AT ROW 9.48 COL 46.4 WIDGET-ID 58
     "°C" VIEW-AS TEXT
          SIZE 5.6 BY .67 AT ROW 10.76 COL 46 WIDGET-ID 60
     "l/s" VIEW-AS TEXT
          SIZE 6.2 BY .62 AT ROW 11.81 COL 46 WIDGET-ID 62
     rectToolbar AT ROW 1.24 COL 2 WIDGET-ID 2
     rectOppsett AT ROW 6.95 COL 7 WIDGET-ID 42
     rectInfo AT ROW 4.1 COL 59 WIDGET-ID 68
     SHUNTTEGNING AT ROW 8.86 COL 105 WIDGET-ID 70
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 151.2 BY 24.52 WIDGET-ID 100.


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
         TITLE              = "Prosjekt"
         HEIGHT             = 24.52
         WIDTH              = 151.2
         MAX-HEIGHT         = 28.57
         MAX-WIDTH          = 165.6
         VIRTUAL-HEIGHT     = 28.57
         VIRTUAL-WIDTH      = 165.6
         SHOW-IN-TASKBAR    = no
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
/* SETTINGS FOR FILL-IN anvendelse IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       anvendelse:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN prim_konst_var IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       prim_konst_var:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN reguleringsventil IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       reguleringsventil:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN sek_konst_var IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       SHUNTTEGNING:SELECTABLE IN FRAME DEFAULT-FRAME       = TRUE.

/* SETTINGS FOR FILL-IN shunt_dimmensjon IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET type IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN ventil_type IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       ventil_type:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Prosjekt */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Prosjekt */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnReset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnReset C-Win
ON CHOOSE OF btnReset IN FRAME DEFAULT-FRAME /* Reset */
DO:
  ASSIGN 
    prim_effekt:SCREEN-VALUE     = "0.0"
    sek_effekt:SCREEN-VALUE      = "0.0"
    prim_temp_inn:SCREEN-VALUE   = "0.0"
    sek_temp_inn:SCREEN-VALUE    = "0.0"
    prim_temp_ut:SCREEN-VALUE    = "0.0"
    sek_temp_ut:SCREEN-VALUE     = "0.0"    
    prim_kapasitet:SCREEN-VALUE  = "0.0"
    sek_kapasitet:SCREEN-VALUE   = "0.0"
  .
  
  APPLY 'ENTRY' TO sek_effekt.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ms_ventiltype
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ms_ventiltype C-Win
ON ANY-PRINTABLE OF ms_ventiltype IN FRAME DEFAULT-FRAME /* MS-Ventiltype */
DO:
  /*
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
  */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ms_ventiltype C-Win
ON CURSOR-DOWN OF ms_ventiltype IN FRAME DEFAULT-FRAME /* MS-Ventiltype */
DO:
  /*
  i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ms_ventiltype C-Win
ON CURSOR-UP OF ms_ventiltype IN FRAME DEFAULT-FRAME /* MS-Ventiltype */
DO:
  /*
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
{incl/wintrigg.i}  

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
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnPrim C-Win 
PROCEDURE beregnPrim :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VAR teller AS DECIMAL.
    DEFINE VAR nevner AS DECIMAL.
    
    DO WITH FRAME {&FRAME-NAME}:
        IF INTEGER(prim_effekt:SCREEN-VALUE) <> 0 AND DECIMAL(prim_temp_inn:SCREEN-VALUE) <>  0 AND DECIMAL(prim_temp_ut:SCREEN-VALUE)  <>  0 THEN
        DO:
          teller = DECIMAL(prim_effekt:SCREEN-VALUE)  * 0.86.
          nevner = DECIMAL(prim_temp_inn:SCREEN-VALUE)  - DECIMAL(prim_temp_ut:SCREEN-VALUE).
          ASSIGN  
            prim_kapasitet:SCREEN-VALUE = STRING(ABSOLUTE((teller  /  nevner) / 3600)).
        END.
    END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeregnRecord C-Win 
PROCEDURE BeregnRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Ingen endringer kan gj›res dersom det er gitt tilbud */
    /* Er endringsl†s opphevet */
/*     DEFINE VAR laast AS LOGICAL.                                                    */
/*     DEFINE VAR editModus AS INTEGER.                                                */
/*                                                                                     */
/*     SELECT endrings_laas INTO laast FROM NPSHANLG WHERE anleggsnr = anleggsnrParam. */
/*     IF laast THEN                                                                   */
/*         editModus = 0.                                                              */
/*      ELSE                                                                           */
/*         editModus = 1.                                                              */

    /* Fyr av rett beregningsvindu */
    /*pointer =  SESSION:SET-WAIT-STATE("GENERAL").*/
/*     valgtKobling = koblings_alternativ. */
/*     systemnrParam = NPSHSYST.systemnr.  */
    /*
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
        */
   JBoxRelation:instance:addBaseQueryHdl('System',JBoxRelation:instance:BaseQueryHdl('SHSystem')).
   
   CASE koblings_alternativ:
     WHEN '1' THEN RUN dwBeregning_1.w.
     WHEN '2' THEN RUN dwBeregning_2.w.
     WHEN '3' THEN RUN dwBeregning_3.w.
     WHEN '4' THEN RUN dwBeregning_4.w.
     WHEN '5' THEN RUN dwBeregning_5.w.
     WHEN '6' THEN RUN dwBeregning_6.w.
     WHEN '7' THEN RUN dwBeregning_7.w.
     WHEN '7A' THEN RUN dwBeregning_7a.w.
   END CASE.        
   RUN visSystemKode. 
  CATCH anyError AS Progress.Lang.Error:    
 MESSAGE anyError:GetMessageNum(1)
   VIEW-AS ALERT-BOX INFO BUTTONS OK.

END CATCH.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnSek C-Win 
PROCEDURE beregnSek :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VAR teller AS DECIMAL.
    DEFINE VAR nevner AS DECIMAL.
    
    DO WITH FRAME {&FRAME-NAME}:
        IF INTEGER(sek_effekt:SCREEN-VALUE) > 0 AND DECIMAL(sek_temp_inn:SCREEN-VALUE) <>  0 AND DECIMAL(sek_temp_ut:SCREEN-VALUE)  <>  0 THEN
           /* Kapasitet er ikke kjent */
           /* FORMEL: KAPASITET = (A * 0.86) / (B - C) / 3600  */
            DO:
                teller = DECIMAL(sek_effekt:SCREEN-VALUE)  * 0.86.
                nevner = DECIMAL(sek_temp_inn:SCREEN-VALUE)  - DECIMAL(sek_temp_ut:SCREEN-VALUE).
                ASSIGN sek_kapasitet = ABSOLUTE((teller  /  nevner) / 3600).
                IF sek_kapasitet = ? THEN
                    ASSIGN sek_kapasitet = 0.
                DISPLAY  sek_kapasitet.
                ASSIGN  prim_kapasitet = sek_kapasitet.
                DISPLAY  prim_kapasitet.
            END.
        ELSE  IF INTEGER(sek_effekt:SCREEN-VALUE) = 0
            AND DECIMAL(sek_temp_inn:SCREEN-VALUE) <>  0
            AND DECIMAL(sek_temp_ut:SCREEN-VALUE)  <>  0
            AND DECIMAL(sek_kapasitet:SCREEN-VALUE) > 0 THEN
            /* Effekt er ikke kjent */
           /* Formel: EFFEKT = (D* 3600) * (B - C) / 0.86 */
            DO:
                teller = (DECIMAL(sek_kapasitet:SCREEN-VALUE)  * 3600) *
                    (DECIMAL(sek_temp_inn:SCREEN-VALUE)  - 
                    DECIMAL(sek_temp_ut:SCREEN-VALUE)).
                nevner = 0.86.
                ASSIGN sek_effekt = ABSOLUTE((teller  /  nevner)).
                IF sek_effekt = ? THEN
                    ASSIGN sek_effekt = 0.
                DISPLAY  sek_effekt.
                ASSIGN  prim_effekt = sek_effekt.
                DISPLAY  prim_effekt.
            END.
        ELSE  IF INTEGER(sek_effekt:SCREEN-VALUE) > 0
            AND DECIMAL(sek_temp_inn:SCREEN-VALUE) = 0 
            AND DECIMAL(sek_temp_ut:SCREEN-VALUE)  >  0
            AND DECIMAL(sek_kapasitet:SCREEN-VALUE) > 0 THEN
            /* Temperatur inn er ikke kjent */
            /* FORMEL: TEMPERATUR INN = C + (A * 0.86) / (D* 3600) */
            DO:
                teller = DECIMAL(sek_effekt:SCREEN-VALUE)  *   0.86.
                nevner =  DECIMAL(sek_kapasitet:SCREEN-VALUE)   * 3600. 
                ASSIGN sek_temp_inn =  
                    DECIMAL(sek_temp_ut:SCREEN-VALUE) + (teller  /  nevner).
                IF sek_temp_inn = ? THEN
                    ASSIGN sek_temp_inn = 0.
                DISPLAY  sek_temp_inn.
                ASSIGN  prim_temp_inn = sek_temp_inn.
                DISPLAY  prim_temp_inn.
            END.                      
        ELSE  IF INTEGER(sek_effekt:SCREEN-VALUE) > 0
            AND DECIMAL(sek_temp_inn:SCREEN-VALUE) > 0 
            AND DECIMAL(sek_temp_ut:SCREEN-VALUE)  =  0
            AND DECIMAL(sek_kapasitet:SCREEN-VALUE) > 0 THEN
            /* Temperatur ut er ikke kjent */
            /* FORMEL: TEMPERATUR UT = B - (A * 0.86) / (D* 3600) */
            DO:
                teller = DECIMAL(sek_effekt:SCREEN-VALUE)  *   0.86.
                nevner =  DECIMAL(sek_kapasitet:SCREEN-VALUE)   * 3600. 
                ASSIGN sek_temp_ut =  
                    DECIMAL(sek_temp_inn:SCREEN-VALUE) - (teller  /  nevner).
                IF sek_temp_ut = ? THEN
                    ASSIGN sek_temp_ut = 0.
                IF sek_temp_ut < 0 THEN
                    ASSIGN sek_temp_ut = (sek_temp_ut  *  -1).
                DISPLAY  sek_temp_ut.
                ASSIGN  prim_temp_ut = sek_temp_ut.
                DISPLAY  prim_temp_ut.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayRecord C-Win 
PROCEDURE DisplayRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def var bhParent as handle no-undo.
  def var bLocked  as logical no-undo.
  def var cReturn  as char    no-undo.
  
  bhParent = JBoxRelation:instance:BaseQueryHdl('SHanlegg').
  if not valid-handle(bhParent) then
  do:
    /*Get info regarding NorProsjekt from its own record. New event is not available*/
    if hFieldMap:avail then
    do:
      cReturn = DYNAMIC-FUNCTION('getFieldValues','npshanlg','WHERE npshanlg.anleggsnr = ' + hFieldMap:BUFFER-FIELD('anleggsnr'):STRING-VALUE,'anleggsnr,anlegg,endrings_laas').
    end.
    DYNAMIC-FUNCTION("setAttribute",hToolbar,"disabledevents","new,copy").
  end.
  else
  do:
    if bhParent:type = 'Browse' then bhParent = bhParent:query:get-buffer-handle(1). else bhParent:GET-BUFFER-HANDLE(1).
  end.

  DYNAMIC-FUNCTION('setAttribute',hToolbar,'EnabledEvents','').
  DYNAMIC-FUNCTION('setAttribute',hToolbar,'DisabledEvents','Beregn').

RUN SUPER.

DO WITH FRAME {&FRAME-NAME}:
  if valid-handle(bhParent) then bLocked = bhParent::endrings_laas.  
  else bLocked = logical(entry(3,cReturn,'|')).

  if bLocked then DO:
    ASSIGN 
      hButton = DYNAMIC-FUNCTION('getToolbarButtonHandle',hToolbar,'Edit')
      hButton:SENSITIVE = FALSE
/*      hButton = DYNAMIC-FUNCTION('getToolbarButtonHandle',hToolbar,'Beregn')*/
/*      hButton:SENSITIVE = FALSE                                             */
      hButton = DYNAMIC-FUNCTION('getToolbarButtonHandle',hToolbar,'Delete')
      hButton:SENSITIVE = FALSE
      hButton = DYNAMIC-FUNCTION('getToolbarButtonHandle',hToolbar,'New')
      hButton:SENSITIVE = FALSE
    .

  END.

  if hFieldMap:avail then
  do:
    ASSIGN 
      ms_ventiltype:SENSITIVE              = hFieldMap:BUFFER-FIELD("type"):BUFFER-VALUE = 'MS' 
      ms_ventiltype:MODIFIED               = FALSE
      ms_shuntventil_i_leveranse:SENSITIVE = hFieldMap:BUFFER-FIELD("type"):BUFFER-VALUE = 'MS' 
      ms_shuntventil_i_leveranse:MODIFIED  = FALSE
    .
  end.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditRecord C-Win 
PROCEDURE EditRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DYNAMIC-FUNCTION('setAttribute',hToolbar,'EnabledEvents','Beregn').
  DYNAMIC-FUNCTION('setAttribute',hToolbar,'DisabledEvents','').
  
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
    
    ASSIGN 
      ms_ventiltype:SENSITIVE              = hFieldMap:BUFFER-FIELD("type"):BUFFER-VALUE = 'MS' 
      ms_ventiltype:MODIFIED               = FALSE
      ms_shuntventil_i_leveranse:SENSITIVE = hFieldMap:BUFFER-FIELD("type"):BUFFER-VALUE = 'MS' 
      ms_shuntventil_i_leveranse:MODIFIED  = FALSE
    .
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
  DISPLAY systemnr systembetegnelse anvendelse koblings_alternativ 
          prim_konst_var sek_konst_var reguleringsventil ventil_type sek_effekt 
          prim_effekt beregnet_anvendelse sek_temp_inn prim_temp_inn sek_temp_ut 
          prim_temp_ut sek_kapasitet prim_kapasitet ms_shuntventil_i_leveranse 
          ms_ventiltype shunt_dimmensjon tillegg_montasje tillegg_kapsling 
          system_kode lblVentilType 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rectToolbar rectOppsett rectInfo SHUNTTEGNING systemnr 
         systembetegnelse koblings_alternativ sek_effekt prim_effekt 
         beregnet_anvendelse sek_temp_inn prim_temp_inn sek_temp_ut 
         prim_temp_ut sek_kapasitet prim_kapasitet btnReset type 
         ms_shuntventil_i_leveranse ms_ventiltype tillegg_montasje 
         tillegg_kapsling system_kode lblVentilType 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreSystem C-Win 
PROCEDURE endreSystem :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
MESSAGE 'inne i endreSystem'
  VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
DO TRANSACTION:
  FIND NPSHSYST WHERE ROWID(NPSHSYST) = Current-Syst-Rec EXCLUSIVE-LOCK
   NO-ERROR NO-WAIT.
  IF AVAILABLE NPSHSYST THEN
    DO:
      DO WITH FRAME ENDRE-SYSTEM:
          DISPLAY NPSHSYST.koblings_alternativ.
          ENABLE  NPSHSYST.koblings_alternativ.
          APPLY "VALUE-CHANGED" TO NPSHSYST.koblings_alternativ.
          DISPLAY NPSHSYST.shunt_dimmensjon.
          ENABLE BUTTON-reset.
      END.

      /* Set combo-box til feltverdi for ventiltype */
      IF NPSHSYST.type = 'MS' THEN
          DO WITH FRAME ENDRE-SYSTEM:
              DEFINE VAR ventilType AS CHAR.
              DEFINE VAR finnesIListe AS INTEGER.
            
              ventilType = NPSHSYST.ms_ventiltype.
                  finnesIListe = LOOKUP(ventilType, temp-string).
                  IF finnesIListe > 0 THEN
                      COMBO-BOX-VENTILTYPE:SCREEN-VALUE = ventilType.            
                ENABLE COMBO-BOX-VENTILTYPE.
                ENABLE NPSHSYST.ms_shuntventil_i_leveranse.
                DISPLAY NPSHSYST.ms_shuntventil_i_leveranse.
           END.
      ELSE 
      DO:
              DISABLE COMBO-BOX-VENTILTYPE.
              DISABLE NPSHSYST.ms_shuntventil_i_leveranse.
     END.

     UPDATE
        NPSHSYST.systembetegnelse NPSHSYST.koblings_alternativ 
        NPSHSYST.sek_effekt 
        NPSHSYST.sek_temp_inn 
        NPSHSYST.sek_temp_ut 
        NPSHSYST.prim_effekt 
        NPSHSYST.prim_temp_inn 
        NPSHSYST.prim_temp_ut 
        NPSHSYST.sek_kapasitet NPSHSYST.prim_kapasitet
        NPSHSYST.beregnet_anvendelse                 
        NPSHSYST.type
        Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME ENDRE-SYSTEM.
     END.
    ELSE
      IF LOCKED NPSHSYST THEN
         DO:
             MESSAGE 'Tabellen for shuntsystem er opptatt. Prøv senere' VIEW-AS ALERT-BOX 
                 TITLE 'Registrere nytt system'.
            RETURN.
         END.
    
END.  /* TRANSACTION */
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EntryOfWidget C-Win 
PROCEDURE EntryOfWidget :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEF VAR hObject AS HANDLE NO-UNDO.  

  hButton = DYNAMIC-FUNCTION('getToolbarButtonHandle',hToolbar,'Edit').
  IF NOT hButton:SENSITIVE THEN LEAVE.
  hObject = DYNAMIC-FUNCTION('getCurrentWidget'). 
  
  DO WITH FRAME {&FRAME-NAME}:
    CASE hObject:NAME:
      WHEN 'prim_kapasitet' THEN
      DO:
        IF CAN-DO('5,7',koblings_alternativ:SCREEN-VALUE) THEN
        DO:
          IF DECIMAL(prim_effekt:SCREEN-VALUE) GT 0.00 THEN
          RETURN NO-APPLY.
        END.
      END.
      WHEN 'sek_kapasitet' THEN
      DO:
        IF INTEGER(sek_effekt:SCREEN-VALUE)  > 0 THEN RETURN NO-APPLY.
      END.
      WHEN 'beregnet_anvendelse' THEN
      DO:
        IF koblings_alternativ:SCREEN-VALUE = '6' THEN
        RETURN NO-APPLY.
      END.
      WHEN 'shunt_dimmensjon' THEN
      DO:
/*         DEFINE VAR c_kapasitet  AS DEC NO-UNDO.                                                           */
/*         DEFINE VAR c_grunnlag AS CHARACTER NO-UNDO.                                                       */
/*                                                                                                           */
/*         IF dec(prim_kapasitet:SCREEN-VALUE) = 0.0 AND dec(sek_kapasitet:SCREEN-VALUE) = 0.0 THEN          */
/*         DO:                                                                                               */
/*           MESSAGE 'Shuntdimmensjon kan ikke beregnes når kapasitet er 0'.                                 */
/*           APPLY "ENTRY" TO sek_effekt.                                                                    */
/*           RETURN NO-APPLY.                                                                                */
/*         END.                                                                                              */
/*                                                                                                           */
/*         CASE koblings_alternativ:                                                                         */
/*           WHEN '5' OR WHEN '6' OR WHEN '7'  THEN                                                          */
/*           DO:                                                                                             */
/*             c_kapasitet = DECIMAL(sek_kapasitet:SCREEN-VALUE).                                            */
/*             c_grunnlag = 'Sekundærkrets'.                                                                 */
/*           END.                                                                                            */
/*           OTHERWISE                                                                                       */
/*           DO:                                                                                             */
/*             c_kapasitet = DECIMAL(prim_kapasitet:SCREEN-VALUE).                                           */
/*             c_grunnlag = 'Primærkrets'.                                                                   */
/*           END.                                                                                            */
/*         END CASE.                                                                                         */
/*                                                                                                           */
/*         CASE type:SCREEN-VALUE:                                                                           */
/*           WHEN  'FM' THEN RUN VELGFMDM.W (INPUT-OUTPUT  dDimmVerdi, INPUT c_kapasitet, INPUT c_grunnlag). */
/*           WHEN  'MS' THEN                                                                                 */
/*           DO:                                                                                             */
/*             Message('Kun Shunt-type FM er implementert') VIEW-AS ALERT-BOX.                               */
/*             RETURN FALSE.                                                                                 */
/*           END.                                                                                            */
/*         END CASE.                                                                                         */
/*         ASSIGN                                                                                            */
/*           shunt_dimmensjon:SCREEN-VALUE = string(dDimmVerdi)                                              */
/*         .                                                                                                 */

      END.
      WHEN 'prim_temp_inn' THEN
      DO:
        IF CAN-DO('1,2,3,4,6,7A',koblings_alternativ:SCREEN-VALUE) THEN RETURN NO-APPLY.
        IF CAN-DO('5,7',koblings_alternativ:SCREEN-VALUE) AND INTEGER(prim_effekt:SCREEN-VALUE) = 0 THEN RETURN NO-APPLY.
      END.
    END CASE.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeComponents C-Win 
PROCEDURE InitializeComponents :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF DEFINED(AdvGuiWin) &THEN
DO WITH FRAME {&FRAME-NAME}:
/*
    oreg_dato = NEW JBoxDevExDateEdit(THIS-PROCEDURE,reg_dato:HANDLE,0).
    oreg_dato:RegisterWithJukeBox(YES) NO-ERROR.
    oreg_dato:CreateDisplayLink(hFieldMap,"reg_dato") NO-ERROR.
  */  
END.
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject C-Win 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Create any dynamic objects, initialize drop-down lists etc
  Parameters:  <none>
  Notes:       The dynamic query object must be linked to the THIS-PROCEDURE
------------------------------------------------------------------------------*/

RUN enable_UI.
DO WITH FRAME {&FRAME-NAME}:
  DYNAMIC-FUNCTION("NewObject",THIS-PROCEDURE:CURRENT-WINDOW,THIS-PROCEDURE,"procedure").
  hQuery = DYNAMIC-FUNCTION("NewQuery",1,
                            "",
                            "npshsyst"
                            ,"where false"
                            ,"").
  
  hFieldMap = DYNAMIC-FUNCTION("NewFieldMap",
                             hQuery,
                             FRAME {&FRAME-NAME}:HANDLE,
                             "systembetegnelse,koblings_alternativ,prim_effekt,sek_effekt,prim_temp_inn,sek_temp_inn,prim_temp_ut,sek_temp_ut,prim_kapasitet,sek_kapasitet,beregnet_anvendelse,ms_shuntventil_i_leveranse,ms_ventiltype,type,shunt_dimmensjon"
                             ,"",
                             "systemnr,tillegg_montasje,tillegg_kapsling,system_kode,ventil_type"
                             ,""
                             ,"btnReset"). 

  hToolbar = DYNAMIC-FUNCTION("NewToolBar",
                    rectToolBar:HANDLE,             /* Rectangle to define coordinates for toolbar */
                    "File",                         /* Corresponding menu label - no menu if blank */
                    "edit,new,undo,delete,save,Beregn"
                    ,"maxborder").                  /* Misc - enable, maxborder.. */
  
  DYNAMIC-FUNCTION("CreateObjectLink",hQuery,hFieldMap).
  DYNAMIC-FUNCTION("CreateObjectLink",hFieldMap,hToolbar).
  DYNAMIC-FUNCTION("CreateObjectLink",hQuery,hToolbar).
  
  DYNAMIC-FUNCTION("setAttribute",hFieldMap,"PrimaryKeyFields","anleggsnr,systemnr").
  DYNAMIC-FUNCTION("setAttribute",hFieldMap,"customCreateProc","crt_npshsyst.p").
  DYNAMIC-FUNCTION("setAttribute",hFieldMap,"customUpdateValProc","=upd_npshsyst.p").
  /*DYNAMIC-FUNCTION("setAttribute",hFieldMap,"bufferExtraFields","iJBoxCompanyId,iLeverandorId").*/
  DYNAMIC-FUNCTION("setAttribute",hFieldMap,"fieldNameDeleteWarning","SystemNr").

  DYNAMIC-FUNCTION("setAttribute",hFieldMap,"CustomDeleteValProc","=dlt_npshsyst.p").
  DYNAMIC-FUNCTION("setAttribute",hFieldMap,"PostUpdateProc","postupd_npshsyst.p").

  ASSIGN
    TYPE:DELIMITER = '|'
    TYPE:RADIO-BUTTONS = 'FM|FM|MS|MS'
    ms_ventiltype:DELIMITER = '|'
    ms_ventiltype:LIST-ITEM-PAIRS = DYNAMIC-FUNCTION("getFieldList","npshventiltype;ventiltype|fabrikat;ventiltype","WHERE VentiltypeAktiv BY ventiltype")
    beregnet_anvendelse:DELIMITER = '|'
    beregnet_anvendelse:RADIO-BUTTONS = "Varme|Varme|Lavtemperatur|Lavtemperatur|Lavtemp/Kaldt medium|Lavtemp/Kaldt medium|Kjøle|Kjøle|Fryse|Fryse|Varmegjenvinning|Varmegjenvinning"
    koblings_alternativ:DELIMITER = '|'
    koblings_alternativ:LIST-ITEM-PAIRS = DYNAMIC-FUNCTION("getFieldList","npshkobl;koblingsalternativ|betegnelse;koblingsalternativ","WHERE true BY betegnelse")
  .

/*  DYNAMIC-FUNCTION("CreateOneToOneLink",hQuery,JBoxRelation:instance:BaseQueryHdl('SHSystem'),"anleggsnr,systemnr").*/
/*  RUN InvokeMethod(JBoxRelation:instance:BaseQueryHdl('SHSystem'),"DisplayRecord").                                 */
  
  RUN InitializeComponents.
  
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveOfFieldHandle C-Win 
PROCEDURE LeaveOfFieldHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM ihObject AS HANDLE NO-UNDO.

  hButton = DYNAMIC-FUNCTION('getToolbarButtonHandle',hToolbar,'Edit').
  IF NOT hButton:SENSITIVE THEN LEAVE.

  DO WITH FRAME {&FRAME-NAME}:
    CASE ihObject:NAME:
      WHEN 'prim_temp_inn' THEN
      DO:
        IF koblings_alternativ:SCREEN-VALUE = '6' THEN RETURN NO-APPLY.
      END.
      WHEN 'sek_effekt' THEN
      DO:
        prim_effekt:SCREEN-VALUE = sek_effekt:SCREEN-VALUE.
        RUN beregnSek.  
      END.
      WHEN 'sek_temp_inn' THEN
      DO:
        CASE koblings_alternativ:SCREEN-VALUE:
           WHEN '1' OR WHEN '2' OR WHEN '3' OR WHEN '4' OR WHEN '7A' THEN
           DO:
              prim_temp_inn:SCREEN-VALUE = sek_temp_inn:SCREEN-VALUE.
           END. 
         WHEN '6' THEN
          DO:
            prim_temp_ut:SCREEN-VALUE = sek_temp_inn:SCREEN-VALUE.
         END.
       END CASE.
       RUN BeregnSek.
      END.
      WHEN 'sek_temp_ut' THEN
      DO:
        IF CAN-DO('1,2,3,4,5,7,7A',koblings_alternativ:SCREEN-VALUE) THEN
             prim_temp_ut:SCREEN-VALUE = sek_temp_ut:SCREEN-VALUE.
        ELSE IF CAN-DO('6',koblings_alternativ:SCREEN-VALUE) THEN
               prim_temp_inn:SCREEN-VALUE = sek_temp_ut:SCREEN-VALUE.
        RUN BeregnSek.
      END.
      WHEN 'sek_kapasitet' THEN
      DO:
        RUN BeregnSek.
        CASE koblings_alternativ:SCREEN-VALUE:
            WHEN  '5' or  WHEN  '7' THEN
                DO:
                  IF sek_effekt:SCREEN-VALUE = '0'   THEN
                      DO:
                        APPLY 'ENTRY' TO prim_kapasitet.
                        RETURN NO-APPLY.
                      END.
                END.
          OTHERWISE
    /*          IF NPSHSYST.sek_effekt:SCREEN-VALUE = '0'   THEN*/
                  DO:
                     prim_kapasitet = DECIMAL(sek_kapasitet:SCREEN-VALUE).
                     DISPLAY prim_kapasitet WITH FRAME ENDRE-SYSTEM.
                END.
          END.

      /*  CASE NPSHSYST.koblings_alternativ:SCREEN-VALUE:
            WHEN  '5' or  WHEN  '7' THEN
                DO:
                  IF NPSHSYST.sek_effekt:SCREEN-VALUE = '0'   THEN
                      DO:
                        APPLY 'ENTRY' TO NPSHSYST.prim_kapasitet.
                        RETURN NO-APPLY.
                      END.
                END.
          OTHERWISE
              IF NPSHSYST.sek_effekt:SCREEN-VALUE = '0'   THEN
                  DO:
                     NPSHSYST.prim_kapasitet = DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE).
                     DISPLAY NPSHSYST.prim_kapasitet WITH FRAME ENDRE-SYSTEM.
                END.
          END.*/

      END.
      WHEN 'type' THEN
      DO:

        DEFINE VAR c_kapasitet AS DEC  NO-UNDO.
        DEFINE VAR c_grunnlag  AS CHAR NO-UNDO.

        IF DEC(prim_kapasitet:SCREEN-VALUE) = 0.0 AND DEC(sek_kapasitet:SCREEN-VALUE) = 0.0 THEN
        DO:
          MESSAGE 'Shuntdimmensjon kan ikke beregnes når kapasitet er 0'.
          APPLY "ENTRY" TO sek_effekt.
          RETURN NO-APPLY.
        END.
        CASE koblings_alternativ:SCREEN-VALUE:
          WHEN '5' OR WHEN '6' OR WHEN '7'  THEN
          DO:
              c_kapasitet = DECIMAL(sek_kapasitet:SCREEN-VALUE).
              c_grunnlag = 'Sekundærkrets'.
          END.
          OTHERWISE
          DO:
              c_kapasitet = DECIMAL(prim_kapasitet:SCREEN-VALUE).
              c_grunnlag = 'Primærkrets'.
          END.
        END CASE.
        CASE type:SCREEN-VALUE:
          WHEN  'FM' THEN RUN VELGFMDM.W (INPUT-OUTPUT  dDimmVerdi, INPUT c_kapasitet, INPUT c_grunnlag).                       
          WHEN  'MS' THEN RUN VELGMSDM.W (INPUT-OUTPUT  dDimmVerdi, INPUT c_kapasitet, INPUT c_grunnlag).                       
        END CASE.
        ASSIGN shunt_dimmensjon:SCREEN-VALUE = STRING(dDimmVerdi).
      END.
    END CASE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop C-Win 
PROCEDURE MoveToTop :
/*------------------------------------------------------------------------------
  Purpose:     Mak
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FRAME {&FRAME-NAME}:MOVE-TO-TOP().
/*
&IF DEFINED(UIB_is_Running) NE 0 &THEN
  IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN RUN ShowForm("").
&ENDIF
{&WINDOW-NAME}:WINDOW-STATE = 3.
{&WINDOW-NAME}:MOVE-TO-TOP().
DYNAMIC-FUNCTION("DoLockWindow",?).
  */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewRecord C-Win 
PROCEDURE NewRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN SUPER.
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN 
    ms_ventiltype:SENSITIVE              = true /*hFieldMap:BUFFER-FIELD("type"):BUFFER-VALUE = 'MS'*/ 
    ms_ventiltype:MODIFIED               = FALSE
    ms_shuntventil_i_leveranse:SENSITIVE = true /*hFieldMap:BUFFER-FIELD("type"):BUFFER-VALUE = 'MS'*/ 
    ms_shuntventil_i_leveranse:MODIFIED  = FALSE
  .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_hastighet C-Win 
PROCEDURE prc_hastighet :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var v_prim as decimal format ">>>9,999999".
define var v_sek as decimal format ">>>9,999999".
define var pi as decimal initial 3.14.
DEF VAR cReturn AS CHAR NO-UNDO.
DEF VAR cDim AS CHAR NO-UNDO.
DEF VAR dIndreDiam AS DECIMAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  cReturn = DYNAMIC-FUNCTION('getFieldValues','indrediam','WHERE indrediam.dimm = ' + QUOTER(shunt_dimmensjon:SCREEN-VALUE),'dimm,indre_diameter').
  IF cReturn NE ? THEN
  ASSIGN 
    cDim       = ENTRY(1,cReturn)
    dIndreDiam = DEC(ENTRY(2,cReturn))
  .

  if cReturn NE ? then
  do:
      v_prim = prim_kapasitet * 1000 /  ((dIndreDiam * dIndreDiam * pi) / 4).
      v_sek = sek_kapasitet * 1000 /   ((dIndreDiam * dIndreDiam * pi) / 4).
      
      ASSIGN 
        dPrimHastighet = v_prim
        dSekHastighet  = v_sek
      .
  end.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR cReturnValue AS CHAR NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:    
    RUN prc_hastighet.
    /* Dersom MS-Ventil er valgt, må ventiltype velges */  
    IF TYPE:SCREEN-VALUE = 'MS' AND ms_ventiltype:SCREEN-VALUE = "" THEN
    DO:
      MESSAGE 'Når MS-Ventil er valgt, må også ventiltype velges' VIEW-AS ALERT-BOX TITLE 'Registreringsfeil'.
      RETURN NO-APPLY.
    END.
  
    /* Dersom MS-Ventil er valgt, skjekk om NPSHMKVS har denne kombinasjonen av 
      ventiltype og shuntdimmensjon */
    IF TYPE:SCREEN-VALUE = 'MS' THEN  
    DO:
      cReturnValue = DYNAMIC-FUNCTION('getFieldValues','npshmkvs','WHERE npshmkvs.ventiltype = ' + quoter(ms_ventiltype:SCREEN-VALUE) + ' AND npshmkvs.shunt_dimmensjon = ' + quoter(STRING(dDimmVerdi)) ,'ventiltype').
      IF cReturnValue = ? THEN
      DO:
        MESSAGE 'I Bergningdata er det ikke definert KVS- Verdi for ventiltype ' + ms_ventiltype:SCREEN-VALUE + ' med dimmensjon ' + STRING(dDimmVerdi) + '.' VIEW-AS ALERT-BOX TITLE 'Registreringsfeil'.
        RETURN NO-APPLY.
      END.
    END.
  END.

RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValueChangedField C-Win 
PROCEDURE ValueChangedField :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF INPUT PARAM icFieldName  AS CHAR NO-UNDO.

  DEF VAR cFieldValues AS CHAR NO-UNDO.
  DEF VAR tegningBMP   AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    CASE icFieldName:
      WHEN 'koblings_alternativ' THEN
      DO:
        cFieldValues = DYNAMIC-FUNCTION("getFieldValues","npshkobl","WHERE npshkobl.koblingsalternativ = " + quoter(koblings_alternativ:SCREEN-VALUE),"betegnelse,anvendelse,sek_konst_var,prim_konst_var,reguleringsventil,ventil_type").
        IF cFieldValues NE ? THEN
          ASSIGN 
            anvendelse:SCREEN-VALUE        = ENTRY(1,cFieldValues,'|')
            prim_konst_var:SCREEN-VALUE    = ENTRY(2,cFieldValues,'|')
            sek_konst_var:SCREEN-VALUE     = ENTRY(3,cFieldValues,'|')
            reguleringsventil:SCREEN-VALUE = ENTRY(4,cFieldValues,'|')
            ventil_type:SCREEN-VALUE       = ENTRY(5,cFieldValues,'|')
            tegningBMP = 'bmp/kobling' + koblings_alternativ:SCREEN-VALUE + '.bmp'
          .
          IF koblings_alternativ = '6' THEN beregnet_anvendelse:SCREEN-VALUE = 'Varmegjenvinning'.
          bOK = SHUNTTEGNING:LOAD-IMAGE (tegningBmp,0,0,140,202).
/*          IF bOk THEN DISPLAY shunttegning WITH FRAME {&FRAME-NAME}.*/
      END.
      WHEN 'type' THEN
      DO:
        IF TYPE:SCREEN-VALUE = 'MS' THEN
        DO:
          ASSIGN 
            ms_ventiltype:SENSITIVE               = TRUE
             ms_shuntventil_i_leveranse:SENSITIVE = TRUE
          .
        END.
        ELSE
        DO:
          ASSIGN 
            ms_ventiltype:SENSITIVE    = FALSE
            ms_ventiltype:SCREEN-VALUE = ""
            ms_ventiltype:MODIFIED     = FALSE
            ms_shuntventil_i_leveranse:SENSITIVE = FALSE
            ms_shuntventil_i_leveranse:CHECKED   = FALSE
          .
        END.

      END.
    END CASE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE visSystem C-Win 
PROCEDURE visSystem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
MESSAGE 'inne i visSystem'
  VIEW-AS ALERT-BOX INFO BUTTONS OK.
  /*
  DO TRANSACTION:
  FIND NPSHSYST WHERE ROWID(NPSHSYST) = Current-Syst-Rec EXCLUSIVE-LOCK
   NO-ERROR NO-WAIT.
  IF AVAILABLE NPSHSYST THEN
    DO:
      DO WITH FRAME ENDRE-SYSTEM:
          DISPLAY NPSHSYST.koblings_alternativ.
          ENABLE  NPSHSYST.koblings_alternativ.
          APPLY "VALUE-CHANGED" TO NPSHSYST.koblings_alternativ.
          DISABLE  NPSHSYST.koblings_alternativ.
          DISPLAY NPSHSYST.shunt_dimmensjon.
      END.

      /* Set combo-box til feltverdi for ventiltype */
      IF NPSHSYST.type = 'MS' THEN
          DO WITH FRAME ENDRE-SYSTEM:
              DEFINE VAR ventilType AS CHAR.
              DEFINE VAR finnesIListe AS INTEGER.
            
              ventilType = NPSHSYST.ms_ventiltype.
                  finnesIListe = LOOKUP(ventilType, temp-string).
                  IF finnesIListe > 0 THEN
                      COMBO-BOX-VENTILTYPE:SCREEN-VALUE = ventilType.            
                      DISPLAY  COMBO-BOX-VENTILTYPE.
                DISPLAY NPSHSYST.ms_shuntventil_i_leveranse.
           END.
      ELSE 
      DO:
              DISABLE COMBO-BOX-VENTILTYPE.
              DISABLE NPSHSYST.ms_shuntventil_i_leveranse.
     END.

    DISPLAY
        NPSHSYST.systembetegnelse NPSHSYST.koblings_alternativ 
        NPSHSYST.sek_effekt 
        NPSHSYST.sek_temp_inn 
        NPSHSYST.sek_temp_ut 
        NPSHSYST.prim_effekt 
        NPSHSYST.prim_temp_inn 
        NPSHSYST.prim_temp_ut 
        NPSHSYST.sek_kapasitet NPSHSYST.prim_kapasitet
        NPSHSYST.beregnet_anvendelse                 
        NPSHSYST.type
      WITH FRAME ENDRE-SYSTEM.
    UPDATE  Btn_Cancel  WITH FRAME ENDRE-SYSTEM.


     END.
    ELSE
      IF LOCKED NPSHSYST THEN
         DO:
             MESSAGE 'Tabellen for shuntsystem er opptatt. Prøv senere' VIEW-AS ALERT-BOX 
                 TITLE 'Registrere nytt system'.
            RETURN.
         END.
    
END.  /* TRANSACTION */
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE visSystemKode C-Win 
PROCEDURE visSystemKode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  /*
  /* Fyll ut de felt som har data - resten med ?? */
  DEFINE VAR c_kode AS CHAR.
  /* Type */
  IF  type <> "" THEN
      c_kode = type.
  ELSE
      c_kode = '??'.
  /* Dimm */
  IF  shunt_dimmensjon <> "" THEN
      c_kode = c_kode  + TRIM(shunt_dimmensjon).
  ELSE
      c_kode = c_kode + '??'.
  /* Legg til ventiltype ved MS */
  IF type = 'MS' THEN
      c_kode = c_kode + '/' + ms_ventiltype.   
  /* KVS Hovedport (2-1)  og ventilkarakteristikk */
  IF  hFieldMap:buffer-field('kvs_hovedport'):BUFFER-VALUE > 0 THEN
      DO:
          c_kode = c_kode + '-Kvs' + hFieldMap:buffer-field('kvs_hovedport'):STRING-VALUE.
          c_kode = c_kode + ' ' + hFieldMap:buffer-field('ventil_karakteristikk_hoved'):STRING-VALUE.
      END.        
  ELSE
      c_kode = TRIM(c_kode) + '- Kvs' + '??-??'.
  IF type = 'FM' THEN
  DO:
  /* KVS Shuntport (3-1) og ventilkarakteristikk */
  IF  hFieldMap:buffer-field('kvs_shuntport'):BUFFER-VALUE > 0 THEN
      DO:
          c_kode = c_kode + '/Kvs' + hFieldMap:buffer-field('kvs_shuntport'):STRING-VALUE.
          c_kode = c_kode + ' ' + hFieldMap:buffer-field('ventil_karakteristikk_shunt'):STRING-VALUE.
      END.        
  END.
  /* Koblingsalternativ */
  c_kode = c_kode + '-' + hFieldMap:buffer-field('koblings_alternativ'):STRING-VALUE .
  /* Beregnet anvendelse */
  CASE beregnet_anvendelse:
      WHEN 'Varme' THEN
          c_kode = c_kode + '-V'.
      WHEN 'Lavtemperatur' THEN
          c_kode = c_kode + '-L'.
      WHEN 'Kj›le' THEN
          c_kode = c_kode + '-K'.
      WHEN 'Fryse' THEN
          c_kode = c_kode + '-F'.
      WHEN 'Varmegjenvinning' THEN
          c_kode = c_kode + '-VG'.
       WHEN "Lavtemp/Kaldt medium" THEN 
          c_kode = c_kode + '-L/K'.
  END CASE.
  /* Reguleringsmotor */
  IF hFieldMap:buffer-field('tillegg_forstilling'):BUFFER-VALUE = 'Ingen' THEN
      c_kode = c_kode + '-0'.
  ELSE
      c_kode = c_kode + '-<' + hFieldMap:buffer-field('tillegg_forstilling'):STRING-VALUE + '>'.
  
  /* Strupeventil type og dimmensjon */
  IF hFieldMap:buffer-field('tillegg_strupe'):BUFFER-VALUE THEN
      DO:
      CASE koblings_alternativ:SCREEN-VALUE:
          WHEN '1' OR WHEN '7A' THEN
              /* prim‘r og sekund‘r er like */
              DO:
                  IF  hFieldMap:buffer-field('strupe_dimmensjon_sek'):BUFFER-VALUE <> "" THEN
                      c_kode = c_kode + '-' + hFieldMap:buffer-field('fabrikat'):STRING-VALUE + hFieldMap:buffer-field('strupe_dimmensjon_sek'):STRING-VALUE + '/' +  
                          hFieldMap:buffer-field('fabrikat'):STRING-VALUE + hFieldMap:buffer-field('strupe_dimmensjon_sek'):STRING-VALUE.
                  ELSE
                      c_kode = c_kode + '- 0/0'.
              END.
          WHEN '2' OR WHEN '3' OR WHEN '6' THEN
              /* kun sekund‘rside */
              DO:
                  IF  hFieldMap:buffer-field('strupe_dimmensjon_sek'):BUFFER-VALUE <> "" THEN
                      c_kode = c_kode + '-KUL' + hFieldMap:buffer-field('strupe_dimmensjon_sek'):STRING-VALUE + '/' + hFieldMap:buffer-field('fabrikat'):STRING-VALUE + hFieldMap:buffer-field('strupe_dimmensjon_sek'):STRING-VALUE.
                  ELSE
                      c_kode = c_kode + '-0/0'.
              END.
          WHEN '4' THEN
              /* kun prim‘rside */
              DO:
                  IF  hFieldMap:buffer-field('strupe_dimmensjon_prim'):BUFFER-VALUE <> "" THEN
                      c_kode = c_kode + '-' +  hFieldMap:buffer-field('fabrikat'):STRING-VALUE + hFieldMap:buffer-field('strupe_dimmensjon_prim'):STRING-VALUE + '/KUL' + hFieldMap:buffer-field('strupe_dimmensjon_prim'):STRING-VALUE.
                  ELSE
                      c_kode = c_kode + '-0/0'.
              END.
          WHEN '5' OR WHEN '7' THEN
              /* b†de prim‘rside or sekund‘rside */
              DO:
                  IF  hFieldMap:buffer-field('strupe_dimmensjon_prim'):BUFFER-VALUE <> "" THEN
                      c_kode = c_kode + '- ' +  hFieldMap:buffer-field('fabrikat'):STRING-VALUE + hFieldMap:buffer-field('strupe_dimmensjon_prim'):STRING-VALUE + '/' +
                          hFieldMap:buffer-field('fabrikat'):STRING-VALUE + hFieldMap:buffer-field('strupe_dimmensjon_sek'):STRING-VALUE.
                  ELSE
                      c_kode = c_kode + '0/0'.
              END.
          END CASE.
      END.
  ELSE
      c_kode = c_kode + '-0/0'.
  
      /* Stengeventil type og dimmensjon */
      /* Koblingsalternativ uaktuelt - styres ved registrering av tillegg */
      CASE koblings_alternativ:
          WHEN '5' OR WHEN '7 '  THEN
          DO:
              IF hFieldMap:buffer-field('tillegg_stengeventil_type_prim'):BUFFER-VALUE = 'Kule' THEN
                  DO:
                      IF hFieldMap:buffer-field('illegg_kuleventil_prim'):BUFFER-VALUE THEN
                        c_kode = c_kode + '-KUL' + hFieldMap:buffer-field('strupe_dimmensjon_prim'):STRING-VALUE + '/'.
                      ELSE
                        c_kode = c_kode + '-0/'.            
                  END.
              ELSE IF hFieldMap:buffer-field('tillegg_stengeventil_type_prim'):BUFFER-VALUE = 'Spjeld' THEN
                  DO:
                      IF hFieldMap:buffer-field('tillegg_spjeldventil_prim'):BUFFER-VALUE THEN
                        c_kode = c_kode + '-SPJ' + hFieldMap:buffer-field('strupe_dimmensjon_prim'):STRING-VALUE + '/'.
                      ELSE
                        c_kode = c_kode + '-0/'.            
                  END.
              IF hFieldMap:buffer-field('tillegg_stengeventil_type_sek'):BUFFER-VALUE = 'Kule' THEN
                  DO:                
                      IF hFieldMap:buffer-field('tillegg_kuleventil_sek'):BUFFER-VALUE THEN
                        c_kode = c_kode + 'KUL' + hFieldMap:buffer-field('strupe_dimmensjon_sek'):BUFFER-VALUE.
                      ELSE
                        c_kode = c_kode + '0'.
                 END.
              ELSE IF hFieldMap:buffer-field('tillegg_stengeventil_type_sek'):BUFFER-VALUE = 'Spjeld' THEN
                  DO:
                      IF hFieldMap:buffer-field('tillegg_spjeldventil_sek'):BUFFER-VALUE THEN
                        c_kode = c_kode + '-SPJ' + hFieldMap:buffer-field('strupe_dimmensjon_sek'):BUFFER-VALUE.
                      ELSE
                        c_kode = c_kode + '0'.            
                 END.
          END.
      OTHERWISE
          DO:
             IF hFieldMap:buffer-field('tillegg_kuleventil_sek'):BUFFER-VALUE THEN
               c_kode = c_kode + '-KUL' + hFieldMap:buffer-field('strupe_dimmensjon_prim'):BUFFER-VALUE + '/' +  
                'KUL' + hFieldMap:buffer-field('strupe_dimmensjon_sek'):BUFFER-VALUE.
             ELSE IF hFieldMap:buffer-field('tillegg_spjeldventil_sek'):BUFFER-VALUE THEN
                c_kode = c_kode + '-SPJ' + hFieldMap:buffer-field('strupe_dimmensjon_prim'):BUFFER-VALUE + '/' +  
                 'SPJ' + hFieldMap:buffer-field('strupe_dimmensjon_sek'):BUFFER-VALUE.
             ELSE
                c_kode = c_kode + '-0/0'.
          END.
      END CASE.
          
  /* Pumpe */
  IF  hFieldMap:buffer-field('tillegg_pumpe_fabrikat'):BUFFER-VALUE = "Ingen" THEN
      c_kode = c_kode + '-0'.
  ELSE
      c_kode = c_kode + '-P'.
       
  /* Montasje */
  IF  hFieldMap:buffer-field('tillegg_montasje'):BUFFER-VALUE <> "" THEN
      c_kode = c_kode + '-' + SUBSTRING(hFieldMap:buffer-field('tillegg_montasje'):STRING-VALUE, 1, 1).
  ELSE
      c_kode = c_kode + '- ??'.
  
  /*  Kapsling */
  IF  tillegg_kapsling <> "Kapsling, Ingen" THEN
      c_kode = c_kode + '-' + SUBSTRING(tillegg_kapsling, 10, 11).
  
  system_kode:SCREEN-VALUE = c_kode.          
*/
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION InitializeResize C-Win 
FUNCTION InitializeResize RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: This function is invoked automatically from the viewer or tabfolder object before
           InitializeObject and also before the suppressed window is resized to fit the size of the 
           graphics placeholder.
  Notes:   Note that if the suppressed window contains a searchfield or toolbar object
           the placeholders for these must have resize settings here since the objects themselves have not been 
           initialized. (When a searchfield or tabfolder is created the resize is automatically taken care of).
           
           This function is not mandatory but is called if it exists
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    DYNAMIC-FUNCTION("setNoResizeX", THIS-PROCEDURE:CURRENT-WINDOW, FRAME {&FRAME-NAME}:HANDLE,"rectOppsett,rectInfo"). /* nrx */
    DYNAMIC-FUNCTION("setNoResizeY", THIS-PROCEDURE:CURRENT-WINDOW, FRAME {&FRAME-NAME}:HANDLE,"rectOppsett,rectInfo"). /* nry */

    DYNAMIC-FUNCTION("setOrgWinSize",THIS-PROCEDURE:CURRENT-WINDOW,800,800,0,550).
  END.
  
RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

