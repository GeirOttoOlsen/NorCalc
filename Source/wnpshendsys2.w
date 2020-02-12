&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
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
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE INPUT PARAMETER appdata AS CHARACTER.
DEFINE INPUT PARAMETER anleggsNavnParam AS CHAR.
DEFINE INPUT PARAMETER editModus AS INTEGER.
DEFINE SHARED VAR Current-Syst-Rec as ROWID.
DEFINE SHARED VAR nyRecord AS LOGICAL.
DEFINE SHARED VARIABLE anleggsnrParam LIKE NPSHANLG.anleggsnr.

DEFINE NEW SHARED VARIABLE systemnrParam LIKE NPSHSYST.systemnr.
/*DEFINE VARIABLE dimm_verdi LIKE NPSHFMGR.storrelse.*/
DEFINE VARIABLE dimm_verdi as char no-undo.
DEFINE VAR tegningBmp AS CHAR. 
DEFINE VAR tegningOK AS LOGICAL.
DEFINE VAR syst# LIKE NPSHSYST.systemnr.
DEFINE VAR c_anvendelse AS CHARACTER.
c_anvendelse = 'VK'.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE Current-Widget AS WIDGET-HANDLE.
DEFINE VAR pointer AS LOGICAL.  
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* Disse styrer MDI - simulering */
IF THIS-PROCEDURE:PERSISTENT THEN
    THIS-PROCEDURE:PRIVATE-DATA = appdata.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHKOBL

/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define FIELDS-IN-QUERY-DEFAULT-FRAME NPSHKOBL.betegnelse ~
NPSHKOBL.anvendelse NPSHKOBL.prim_konst_var NPSHKOBL.sek_konst_var ~
NPSHKOBL.ventil_type NPSHKOBL.reguleringsventil 
&Scoped-define QUERY-STRING-DEFAULT-FRAME FOR EACH NPSHKOBL SHARE-LOCK
&Scoped-define OPEN-QUERY-DEFAULT-FRAME OPEN QUERY DEFAULT-FRAME FOR EACH NPSHKOBL SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-DEFAULT-FRAME NPSHKOBL
&Scoped-define FIRST-TABLE-IN-QUERY-DEFAULT-FRAME NPSHKOBL


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHSYST.koblings_alternativ ~
NPSHSYST.systembetegnelse NPSHSYST.sek_effekt NPSHSYST.prim_effekt ~
NPSHSYST.beregnet_anvendelse NPSHSYST.sek_temp_inn NPSHSYST.prim_temp_inn ~
NPSHSYST.sek_temp_ut NPSHSYST.prim_temp_ut NPSHSYST.sek_kapasitet ~
NPSHSYST.prim_kapasitet NPSHSYST.type NPSHSYST.ms_shuntventil_i_leveranse 
&Scoped-define ENABLED-TABLES NPSHSYST
&Scoped-define FIRST-ENABLED-TABLE NPSHSYST
&Scoped-Define ENABLED-OBJECTS RECT-29 RECT-19 RECT-21 SHUNTTEGNING ~
BUTTON-reset COMBO-BOX-VENTILTYPE Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPSHSYST.koblings_alternativ ~
NPSHSYST.systembetegnelse NPSHKOBL.betegnelse NPSHKOBL.anvendelse ~
NPSHKOBL.prim_konst_var NPSHKOBL.sek_konst_var NPSHKOBL.ventil_type ~
NPSHKOBL.reguleringsventil NPSHSYST.sek_effekt NPSHSYST.prim_effekt ~
NPSHSYST.beregnet_anvendelse NPSHSYST.sek_temp_inn NPSHSYST.prim_temp_inn ~
NPSHSYST.sek_temp_ut NPSHSYST.prim_temp_ut NPSHSYST.sek_kapasitet ~
NPSHSYST.prim_kapasitet NPSHSYST.ms_shuntventil_i_leveranse ~
NPSHSYST.shunt_dimmensjon 
&Scoped-define DISPLAYED-TABLES NPSHSYST NPSHKOBL
&Scoped-define FIRST-DISPLAYED-TABLE NPSHSYST
&Scoped-define SECOND-DISPLAYED-TABLE NPSHKOBL
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-VENTILTYPE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancel":L 
     SIZE 10.4 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help":L 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&OK":L 
     SIZE 9 BY 1
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-reset 
     LABEL "&Reset" 
     SIZE 10.4 BY 1.14.

DEFINE VARIABLE COMBO-BOX-VENTILTYPE AS CHARACTER FORMAT "X(256)":U 
     LABEL "MS-Ventiltype" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20.4 BY 1
     FONT 2 NO-UNDO.

DEFINE IMAGE SHUNTTEGNING
     FILENAME "bmp\kobling1":U
     SIZE 29.4 BY 9.62.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 48.4 BY 9.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31.2 BY 10.1.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 121.8 BY 3.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY DEFAULT-FRAME FOR 
      NPSHKOBL SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     NPSHSYST.koblings_alternativ AT ROW 1.67 COL 67 COLON-ALIGNED WIDGET-ID 6
          LABEL "Kobl.alt."
          VIEW-AS COMBO-BOX INNER-LINES 8
          LIST-ITEMS "1","2","3","4","5","6","7","7A" 
          DROP-DOWN-LIST
          SIZE 8 BY 1
          FONT 2
     NPSHSYST.systembetegnelse AT ROW 1.81 COL 14.4 COLON-ALIGNED
          LABEL "Syst.bet."
          VIEW-AS FILL-IN 
          SIZE 44.2 BY 1
          FONT 2
     NPSHKOBL.betegnelse AT ROW 1.81 COL 76.6 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 46.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.anvendelse AT ROW 3.62 COL 17.6 COLON-ALIGNED
          LABEL "Anvendelse"
          VIEW-AS FILL-IN 
          SIZE 27.4 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.prim_konst_var AT ROW 3.62 COL 62 COLON-ALIGNED
          LABEL "Primærkrets"
          VIEW-AS FILL-IN 
          SIZE 16.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.sek_konst_var AT ROW 3.62 COL 99.6 COLON-ALIGNED
          LABEL "Sekundærkrets"
          VIEW-AS FILL-IN 
          SIZE 16.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.ventil_type AT ROW 4.91 COL 17.6 COLON-ALIGNED
          LABEL "Ventiltype"
          VIEW-AS FILL-IN 
          SIZE 23.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.reguleringsventil AT ROW 4.91 COL 99.4 COLON-ALIGNED
          LABEL "Reguleringsventil i"
          VIEW-AS FILL-IN 
          SIZE 21.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.sek_effekt AT ROW 8.05 COL 30.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.prim_effekt AT ROW 8.1 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.beregnet_anvendelse AT ROW 8.67 COL 55 NO-LABEL WIDGET-ID 20
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Varme", "Varme":U,
"Lavtemperatur", "Lavtemperatur":U,
"Lavtemp/Kaldt medium", "Lavtemp/Kaldt medium":U,
"Kjøle", "Kjøle":U,
"Fryse", "Fryse":U,
"Varmegjenvinning", "Varmegjenvinning":U
          SIZE 35.8 BY 6.19
     NPSHSYST.sek_temp_inn AT ROW 9.1 COL 30.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.prim_temp_inn AT ROW 9.14 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.sek_temp_ut AT ROW 10.19 COL 30.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.prim_temp_ut AT ROW 10.24 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.sek_kapasitet AT ROW 11.24 COL 30.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.prim_kapasitet AT ROW 11.29 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     BUTTON-reset AT ROW 13.38 COL 25.6 WIDGET-ID 34
     NPSHSYST.type AT ROW 16.43 COL 14.4 NO-LABEL WIDGET-ID 78
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "FM", "FM":U,
"MS", "MS":U
          SIZE 16 BY .95
          BGCOLOR 8 FGCOLOR 0 
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 127.4 BY 20.86 WIDGET-ID 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME DEFAULT-FRAME
     COMBO-BOX-VENTILTYPE AT ROW 17.62 COL 31 COLON-ALIGNED WIDGET-ID 36
     NPSHSYST.ms_shuntventil_i_leveranse AT ROW 17.91 COL 65 WIDGET-ID 38
          LABEL "MS - Shuntventil med i leveranse"
          VIEW-AS TOGGLE-BOX
          SIZE 42.8 BY .76
     Btn_OK AT ROW 19.71 COL 51.2 WIDGET-ID 32
     Btn_Cancel AT ROW 19.71 COL 61.4 WIDGET-ID 28
     Btn_Help AT ROW 19.71 COL 73.2 WIDGET-ID 30
     NPSHSYST.shunt_dimmensjon AT ROW 16.43 COL 53 COLON-ALIGNED
          LABEL "Shuntdimmensjon"
           VIEW-AS TEXT 
          SIZE 7.6 BY .62
          BGCOLOR 8 FGCOLOR 1 FONT 2
     "°C" VIEW-AS TEXT
          SIZE 5.6 BY .67 AT ROW 10.48 COL 44.6 WIDGET-ID 72
     " Primær" VIEW-AS TEXT
          SIZE 10.8 BY .67 AT ROW 7.29 COL 18 WIDGET-ID 66
     "W" VIEW-AS TEXT
          SIZE 4.4 BY .67 AT ROW 8.19 COL 45 WIDGET-ID 68
     "°C" VIEW-AS TEXT
          SIZE 5.8 BY .67 AT ROW 9.19 COL 45 WIDGET-ID 70
     " Sekundær" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 7.19 COL 32.4 WIDGET-ID 64
     "Ventil:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 16.43 COL 5 WIDGET-ID 76
     "l/s" VIEW-AS TEXT
          SIZE 6.2 BY .62 AT ROW 11.52 COL 44.6 WIDGET-ID 74
     RECT-29 AT ROW 3.19 COL 3.2 WIDGET-ID 10
     RECT-19 AT ROW 6.67 COL 3.6 WIDGET-ID 48
     RECT-21 AT ROW 6.67 COL 93.8 WIDGET-ID 50
     SHUNTTEGNING AT ROW 7 COL 95 WIDGET-ID 60
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 127.4 BY 20.86 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 20.86
         WIDTH              = 127.4
         MAX-HEIGHT         = 20.86
         MAX-WIDTH          = 127.4
         VIRTUAL-HEIGHT     = 20.86
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR FILL-IN NPSHKOBL.anvendelse IN FRAME DEFAULT-FRAME
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHKOBL.betegnelse IN FRAME DEFAULT-FRAME
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX NPSHSYST.koblings_alternativ IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.ms_shuntventil_i_leveranse IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHKOBL.prim_konst_var IN FRAME DEFAULT-FRAME
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHKOBL.reguleringsventil IN FRAME DEFAULT-FRAME
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_effekt IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_kapasitet IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHKOBL.sek_konst_var IN FRAME DEFAULT-FRAME
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_temp_inn IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_temp_ut IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
ASSIGN 
       SHUNTTEGNING:SELECTABLE IN FRAME DEFAULT-FRAME       = TRUE.

/* SETTINGS FOR FILL-IN NPSHSYST.shunt_dimmensjon IN FRAME DEFAULT-FRAME
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.systembetegnelse IN FRAME DEFAULT-FRAME
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET NPSHSYST.type IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHKOBL.ventil_type IN FRAME DEFAULT-FRAME
   NO-ENABLE EXP-LABEL                                                  */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME DEFAULT-FRAME
/* Query rebuild information for FRAME DEFAULT-FRAME
     _TblList          = "norcalc.NPSHKOBL"
     _Query            is OPENED
*/  /* FRAME DEFAULT-FRAME */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.beregnet_anvendelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.beregnet_anvendelse C-Win
ON ENTRY OF NPSHSYST.beregnet_anvendelse IN FRAME DEFAULT-FRAME /* Anvendelse */
DO:
    IF   NPSHSYST.koblings_alternativ:SCREEN-VALUE = '6' THEN
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help C-Win
ON CHOOSE OF Btn_Help IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK C-Win
ON CHOOSE OF Btn_OK IN FRAME DEFAULT-FRAME /* OK */
DO:

  /* Dersom MS-Ventil er valgt, må ventiltype velges */
  IF NPSHSYST.type:SCREEN-VALUE = 'MS' AND 
    COMBO-BOX-VENTILTYPE:SCREEN-VALUE = "" THEN
    DO:
        MESSAGE 'Når MS-Ventil er valgt, må også ventiltype velges' VIEW-AS ALERT-BOX 
            TITLE 'Registreringsfeil'.
        RETURN NO-APPLY.
    END.

  /* Dersom MS-Ventil er valgt, skjekk om NPSHMKVS har denne kombinasjonen av 
    ventiltype og shuntdimmensjon */
  IF NPSHSYST.type:SCREEN-VALUE = 'MS' THEN  
    DO:
        FIND FIRST NPSHMKVS 
            WHERE NPSHMKVS.ventiltype = COMBO-BOX-VENTILTYPE:SCREEN-VALUE        
            AND NPSHMKVS.shunt_dimmensjon = dimm_verdi NO-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE NPSHMKVS THEN
            DO:
                MESSAGE 'I Bergningdata er det ikke definert KVS- Verdi for ventiltype ' + 
                    COMBO-BOX-VENTILTYPE:SCREEN-VALUE + ' med dimmensjon ' +
                    dimm_verdi + '.' VIEW-AS ALERT-BOX TITLE 'Registreringsfeil'.
                RETURN NO-APPLY.
            END.
    END.

  DO WITH FRAME ENDRE-FRAME:
      ASSIGN 
        NPSHSYST.systembetegnelse NPSHSYST.koblings_alternativ 
        NPSHSYST.prim_effekt 
        NPSHSYST.sek_effekt NPSHSYST.beregnet_anvendelse 
        NPSHSYST.prim_temp_inn NPSHSYST.sek_temp_inn 
        NPSHSYST.prim_temp_ut NPSHSYST.sek_temp_ut 
        NPSHSYST.prim_kapasitet NPSHSYST.sek_kapasitet
        NPSHSYST.type NPSHSYST.ms_ventiltype = COMBO-BOX-VENTILTYPE:SCREEN-VALUE
        NPSHSYST.ms_shuntventil_i_leveranse
        NPSHSYST.shunt_dimmensjon_num = INTEGER(NPSHSYST.shunt_dimmensjon).

/* Beregn indre hastighet */
RUN prc_hastighet.

   /* Default verdier for tillegg */
    IF NPSHSYST.type = 'FM' THEN
    DO:
        CASE NPSHSYST.shunt_dimmensjon:
            WHEN '25' THEN   
                ASSIGN tillegg_fm_brakett_overgang = 'MB 23.5 Ø30/Ø10 SETT'.
            WHEN '50' THEN   
                ASSIGN tillegg_fm_brakett_overgang = 'MB 37.5 Ø30/Ø10 SETT'.
            WHEN '65' THEN   
                ASSIGN tillegg_fm_brakett_overgang = 'MB 56.0 Ø30/Ø10 SETT'.
        END CASE.
    END.
  
 /* Default for kapsling */
CASE NPSHSYST.beregnet_anvendelse:SCREEN-VALUE:
    WHEN  "Varme" OR WHEN "Lavtemperatur" THEN
        ASSIGN NPSHSYST.tillegg_kapsling = "Kapsling-Rød front".
    WHEN  "Kjøle" OR WHEN "Fryse" THEN
        ASSIGN NPSHSYST.tillegg_kapsling = "Kapsling-Blå front".
     WHEN "Varmegjenvinning" THEN
        ASSIGN NPSHSYST.tillegg_kapsling = "Kapsling-Grønn front".
     WHEN "Lavtemp/Kaldt medium" THEN 
        ASSIGN NPSHSYST.tillegg_kapsling = "Kapsling-Rød/Blå front".
END CASE.


/* Fyll ut de felt som har data - resten med ?? */
DEFINE VAR c_kode AS CHAR.
/* Type */
IF  NPSHSYST.type <> "" THEN
    c_kode = NPSHSYST.type.
ELSE
    c_kode = '??'.
/* Dimm */
IF  NPSHSYST.shunt_dimmensjon <> "" THEN
    c_kode = c_kode  + TRIM(NPSHSYST.shunt_dimmensjon).
ELSE
    c_kode = c_kode + '??'.
/* Legg til ventiltype ved MS */
IF NPSHSYST.type = 'MS' THEN
    c_kode = c_kode + '/' + NPSHSYST.ms_ventiltype.
/* KVS Hovedport (2-1)  og ventilkarakteristikk */
IF  NPSHSYST.kvs_hovedport > 0 THEN
    DO:
        c_kode = c_kode + '-Kvs' + STRING(NPSHSYST.kvs_hovedport).
        c_kode = c_kode + ' ' + NPSHSYST.ventil_karakteristikk_hoved.
    END.        
ELSE
    c_kode = TRIM(c_kode) + '- Kvs' + '??-??'.
IF NPSHSYST.type = 'FM' THEN
DO:
/* KVS Shuntport (3-1) og ventilkarakteristikk */
IF  NPSHSYST.kvs_shuntport > 0 THEN
    DO:
        c_kode = c_kode + '/Kvs' + STRING(NPSHSYST.kvs_shuntport).
        c_kode = c_kode + ' ' + NPSHSYST.ventil_karakteristikk_shunt.
    END.        
END.
/* Koblingsalternativ */
c_kode = c_kode + '-' + STRING(NPSHSYST.koblings_alternativ).
/* Beregnet anvendelse */
CASE NPSHSYST.beregnet_anvendelse:
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
IF NPSHSYST.tillegg_forstilling = 'Ingen' THEN
    c_kode = c_kode + '-0'.
ELSE
    c_kode = c_kode + '-<' + NPSHSYST.tillegg_forstilling + '>'.

/* Strupeventil type og dimmensjon */
IF NPSHSYST.tillegg_strupe THEN
    DO:
    CASE NPSHSYST.koblings_alternativ:
        WHEN '1' OR WHEN '7A' THEN
            /* primær og sekundær er like */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_sek <> "" THEN
                    c_kode = c_kode + '-' + NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek + '/' +  
                        NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek.
                ELSE
                    c_kode = c_kode + '- 0/0'.
            END.
        WHEN '2' OR WHEN '3' OR WHEN '6' THEN
            /* kun sekundærside */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_sek <> "" THEN
                    c_kode = c_kode + '-KUL' + NPSHSYST.strupe_dimmensjon_sek + '/' + NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek.
                ELSE
                    c_kode = c_kode + '-0/0'.
            END.
        WHEN '4' THEN
            /* kun primærside */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_prim <> "" THEN
                    c_kode = c_kode + '-' +  NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_prim + '/KUL' + NPSHSYST.strupe_dimmensjon_prim.
                ELSE
                    c_kode = c_kode + '-0/0'.
            END.
        WHEN '5' OR WHEN '7' THEN
            /* både primærside or sekundærside */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_prim <> "" THEN
                    c_kode = c_kode + '- ' +  NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_prim + '/' +
                        NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek.
                ELSE
                    c_kode = c_kode + '0/0'.
            END.
        END CASE.
    END.
ELSE
    c_kode = c_kode + '-0/0'.

    /* Stengeventil type og dimmensjon */
    /* Koblingsalternativ uaktuelt - styres ved registrering av tillegg */
    CASE NPSHSYST.koblings_alternativ:
        WHEN '5' OR WHEN '7 '  THEN
        DO:
            IF NPSHSYST.tillegg_stengeventil_type_prim = 'Kule' THEN
                DO:
                    IF NPSHSYST.tillegg_kuleventil_prim THEN
                      c_kode = c_kode + '-KUL' + NPSHSYST.strupe_dimmensjon_prim + '/'.
                    ELSE
                      c_kode = c_kode + '-0/'.            
                END.
            ELSE IF NPSHSYST.tillegg_stengeventil_type_prim = 'Spjeld' THEN
                DO:
                    IF NPSHSYST.tillegg_spjeldventil_prim THEN
                      c_kode = c_kode + '-SPJ' + NPSHSYST.strupe_dimmensjon_prim + '/'.
                    ELSE
                      c_kode = c_kode + '-0/'.            
                END.
            IF NPSHSYST.tillegg_stengeventil_type_sek = 'Kule' THEN
                DO:                
                    IF NPSHSYST.tillegg_kuleventil_sek THEN
                      c_kode = c_kode + 'KUL' + NPSHSYST.strupe_dimmensjon_sek.
                    ELSE
                      c_kode = c_kode + '0'.
               END.
            ELSE IF NPSHSYST.tillegg_stengeventil_type_sek = 'Spjeld' THEN
                DO:
                    IF NPSHSYST.tillegg_spjeldventil_sek THEN
                      c_kode = c_kode + '-SPJ' + NPSHSYST.strupe_dimmensjon_sek.
                    ELSE
                      c_kode = c_kode + '0'.            
               END.
        END.
    OTHERWISE
        DO:
           IF NPSHSYST.tillegg_kuleventil_sek THEN
             c_kode = c_kode + '-KUL' + NPSHSYST.strupe_dimmensjon_prim + '/' +  
              'KUL' + NPSHSYST.strupe_dimmensjon_sek.
           ELSE IF NPSHSYST.tillegg_spjeldventil_sek THEN
              c_kode = c_kode + '-SPJ' + NPSHSYST.strupe_dimmensjon_prim + '/' +  
               'SPJ' + NPSHSYST.strupe_dimmensjon_sek.
           ELSE
              c_kode = c_kode + '-0/0'.
        END.
    END CASE.
        
/* Pumpe */
IF  NPSHSYST.tillegg_pumpe_fabrikat = "Ingen" THEN
    c_kode = c_kode + '-0'.
ELSE
    c_kode = c_kode + '-P'.
     
/* Montasje */
IF  NPSHSYST.tillegg_montasje <> "" THEN
    c_kode = c_kode + '-' + SUBSTRING(NPSHSYST.tillegg_montasje,1 ,1).
ELSE
    c_kode = c_kode + '- ??'.

/*  Kapsling */
IF  NPSHSYST.tillegg_kapsling <> "Kapsling, Ingen" THEN
    c_kode = c_kode + '-' + SUBSTRING(NPSHSYST.tillegg_kapsling, 10, 11).

 ASSIGN NPSHSYST.system_kode = c_kode.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-reset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-reset C-Win
ON CHOOSE OF BUTTON-reset IN FRAME DEFAULT-FRAME /* Reset */
DO:
  Run reset.
  APPLY 'ENTRY' TO NPSHSYST.sek_effekt.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-VENTILTYPE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE C-Win
ON ANY-PRINTABLE OF COMBO-BOX-VENTILTYPE IN FRAME DEFAULT-FRAME /* MS-Ventiltype */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE C-Win
ON CURSOR-DOWN OF COMBO-BOX-VENTILTYPE IN FRAME DEFAULT-FRAME /* MS-Ventiltype */
DO:
  i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE C-Win
ON CURSOR-UP OF COMBO-BOX-VENTILTYPE IN FRAME DEFAULT-FRAME /* MS-Ventiltype */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.koblings_alternativ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.koblings_alternativ C-Win
ON VALUE-CHANGED OF NPSHSYST.koblings_alternativ IN FRAME DEFAULT-FRAME /* Kobl.alt. */
DO:
    FIND NPSHKOBL WHERE NPSHKOBL.koblingsalternativ = 
        NPSHSYST.koblings_alternativ:SCREEN-VALUE.
    IF AVAILABLE(NPSHKOBL) THEN
    DISPLAY 
        norcalc.NPSHKOBL.betegnelse norcalc.NPSHKOBL.anvendelse 
        norcalc.NPSHKOBL.sek_konst_var norcalc.NPSHKOBL.prim_konst_var 
        norcalc.NPSHKOBL.reguleringsventil norcalc.NPSHKOBL.ventil_type 
      WITH FRAME ENDRE-SYSTEM.

    /* Vis riktig tegning */
    CASE NPSHSYST.koblings_alternativ:SCREEN-VALUE:
        WHEN '1' THEN
                tegningBmp = 'kobling1.bmp'.
        WHEN '2' THEN
                tegningBmp = 'kobling2.bmp'.
        WHEN '3' THEN
                tegningBmp = 'kobling3.bmp'.
        WHEN '4' THEN
                tegningBmp = 'kobling4.bmp'.
        WHEN '5' THEN
                tegningBmp = 'kobling5.bmp'.
        WHEN '6' THEN
                DO:
                    tegningBmp = 'kobling6.bmp'.
                    NPSHSYST.beregnet_anvendelse = 'Varmegjenvinning'                    .
                    DISPLAY NPSHSYST.beregnet_anvendelse WITH FRAME {&FRAME-NAME}.
                END.
        WHEN '7' THEN
                tegningBmp = 'kobling7.bmp'.
        WHEN '7A' THEN
                tegningBmp = 'koblin7a.bmp'.
        WHEN 'xx' THEN
                tegningBmp = 'koblingx.bmp'.
    END CASE.
   tegningOK = SHUNTTEGNING:LOAD-IMAGE (tegningBmp,0,0,140,202).
  DISPLAY SHUNTTEGNING WITH FRAME ENDRE-SYSTEM.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.prim_effekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_effekt C-Win
ON ENTRY OF NPSHSYST.prim_effekt IN FRAME DEFAULT-FRAME /* Effekt */
DO:
    RETURN NO-APPLY. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.prim_kapasitet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_kapasitet C-Win
ON ENTRY OF NPSHSYST.prim_kapasitet IN FRAME DEFAULT-FRAME /* Kapasitet */
DO:
    CASE NPSHSYST.koblings_alternativ:SCREEN-VALUE:
        WHEN '5' OR WHEN '7' THEN
            DO:
                IF DECIMAL(NPSHSYST.prim_effekt:SCREEN-VALUE) <> 0 THEN
                RETURN NO-APPLY.
            END.
         OTHERWISE
             RETURN NO-APPLY.
      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.prim_temp_inn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_temp_inn C-Win
ON ENTRY OF NPSHSYST.prim_temp_inn IN FRAME DEFAULT-FRAME /* Temp. inn */
DO:
     CASE NPSHSYST.koblings_alternativ:SCREEN-VALUE:
          WHEN '1' OR WHEN '2' OR WHEN '3' OR WHEN '4' OR WHEN '6' OR WHEN '7A' THEN
                  RETURN NO-APPLY.
    END CASE.
    IF  (NPSHSYST.koblings_alternativ:SCREEN-VALUE = '5'
           OR NPSHSYST.koblings_alternativ:SCREEN-VALUE = '7')
           AND INTEGER(NPSHSYST.prim_effekt:SCREEN-VALUE) = 0 THEN
                  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_temp_inn C-Win
ON LEAVE OF NPSHSYST.prim_temp_inn IN FRAME DEFAULT-FRAME /* Temp. inn */
DO:
      RUN BeregnPrim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.prim_temp_ut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_temp_ut C-Win
ON ENTRY OF NPSHSYST.prim_temp_ut IN FRAME DEFAULT-FRAME /* Temp. ut */
DO:
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sek_effekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_effekt C-Win
ON LEAVE OF NPSHSYST.sek_effekt IN FRAME DEFAULT-FRAME /* Effekt */
DO:
    NPSHSYST.prim_effekt =  INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE).
    DISPLAY NPSHSYST.prim_effekt WITH FRAME ENDRE-SYSTEM.
    RUN beregnSek.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sek_kapasitet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_kapasitet C-Win
ON ENTRY OF NPSHSYST.sek_kapasitet IN FRAME DEFAULT-FRAME /* Kapasitet */
DO:
    IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE)  > 0 THEN
      RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_kapasitet C-Win
ON LEAVE OF NPSHSYST.sek_kapasitet IN FRAME DEFAULT-FRAME /* Kapasitet */
DO:
    RUN BeregnSek.
    CASE NPSHSYST.koblings_alternativ:SCREEN-VALUE:
        WHEN  '5' or  WHEN  '7' THEN
            DO:
              IF NPSHSYST.sek_effekt:SCREEN-VALUE = '0'   THEN
                  DO:
                    APPLY 'ENTRY' TO NPSHSYST.prim_kapasitet.
                    RETURN NO-APPLY.
                  END.
            END.
      OTHERWISE
/*          IF NPSHSYST.sek_effekt:SCREEN-VALUE = '0'   THEN*/
              DO:
                 NPSHSYST.prim_kapasitet = DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE).
                 DISPLAY NPSHSYST.prim_kapasitet WITH FRAME ENDRE-SYSTEM.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sek_temp_inn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_temp_inn C-Win
ON LEAVE OF NPSHSYST.sek_temp_inn IN FRAME DEFAULT-FRAME /* Temp. inn */
DO:
           CASE NPSHSYST.koblings_alternativ:SCREEN-VALUE:
          WHEN '1' OR WHEN '2' OR WHEN '3' OR WHEN '4' OR WHEN '7A' THEN
               DO:
                     NPSHSYST.prim_temp_inn = DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE).
                     DISPLAY NPSHSYST.prim_temp_inn WITH FRAME ENDRE-SYSTEM.
              END. 
           WHEN '6' THEN
                 DO:
                     NPSHSYST.prim_temp_ut = DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE).
                     DISPLAY NPSHSYST.prim_temp_ut WITH FRAME ENDRE-SYSTEM.
               END.
          END CASE.
          RUN BeregnSek.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sek_temp_ut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_temp_ut C-Win
ON LEAVE OF NPSHSYST.sek_temp_ut IN FRAME DEFAULT-FRAME /* Temp. ut */
DO:
       CASE NPSHSYST.koblings_alternativ:SCREEN-VALUE:
      WHEN '1' OR WHEN '2' OR WHEN '3'  OR WHEN '4' OR WHEN '5' OR WHEN '7' 
        OR WHEN '7A' THEN
          DO:
                NPSHSYST.prim_temp_ut = DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE).
                DISPLAY NPSHSYST.prim_temp_ut WITH FRAME ENDRE-SYSTEM.
          END.
      WHEN '6' THEN
            DO:
                NPSHSYST.prim_temp_inn = DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE).
                DISPLAY NPSHSYST.prim_temp_inn WITH FRAME ENDRE-SYSTEM.
            END.
      END CASE.
      RUN BeregnSek.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.shunt_dimmensjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.shunt_dimmensjon C-Win
ON ENTRY OF NPSHSYST.shunt_dimmensjon IN FRAME DEFAULT-FRAME /* Shuntdimmensjon */
DO:
/*    DEFINE VAR c_kapasitet  LIKE NPSHSYST.prim_kapasitet.
    DEFINE VAR c_grunnlag AS CHARACTER.

    ASSIGN
      FRAME ENDRE-SYSTEM NPSHSYST.koblings_alternativ
      FRAME ENDRE-SYSTEM  NPSHSYST.prim_kapasitet
      FRAME ENDRE-SYSTEM  NPSHSYST.sek_kapasitet.
    IF NPSHSYST.prim_kapasitet = 0 AND NPSHSYST.sek_kapasitet = 0 THEN
        DO:
            MESSAGE 'Shuntdimmensjon kan ikke beregnes når kapasitet er 0'.
            APPLY "ENTRY" TO NPSHSYST.sek_effekt.
            RETURN NO-APPLY.
       END.
    CASE koblings_alternativ:
        WHEN '5' OR WHEN '6' OR WHEN '7'  THEN
            DO:
                c_kapasitet = DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE).
                c_grunnlag = 'Sekundærkrets'.
            END.
         OTHERWISE
            DO:
                c_kapasitet = DECIMAL(NPSHSYST.prim_kapasitet:SCREEN-VALUE).
                c_grunnlag = 'Primærkrets'.
            END.
    END CASE.

    CASE  NPSHSYST.type:SCREEN-VALUE:
        WHEN  'FM' THEN
           RUN VELGFMDM.W (INPUT-OUTPUT  dimm_verdi, INPUT c_kapasitet, INPUT c_grunnlag).                       
        WHEN  'MS' THEN
        DO:
            Message('Kun Shunt-type FM er implementert') VIEW-AS ALERT-BOX.
            Return.
        END.
    END CASE.
    ASSIGN NPSHSYST.shunt_dimmensjon = dimm_verdi.
    DISPLAY NPSHSYST.shunt_dimmensjon WITH FRAME ENDRE-SYSTEM.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.type C-Win
ON LEAVE OF NPSHSYST.type IN FRAME DEFAULT-FRAME /* Type */
DO:
    DEFINE VAR c_kapasitet  LIKE NPSHSYST.prim_kapasitet.
    DEFINE VAR c_grunnlag AS CHARACTER.

    ASSIGN
      FRAME ENDRE-SYSTEM NPSHSYST.koblings_alternativ 
      FRAME ENDRE-SYSTEM  NPSHSYST.prim_kapasitet
      FRAME ENDRE-SYSTEM  NPSHSYST.sek_kapasitet.
    IF NPSHSYST.prim_kapasitet = 0 AND NPSHSYST.sek_kapasitet = 0 THEN
        DO:
            MESSAGE 'Shuntdimmensjon kan ikke beregnes når kapasitet er 0'.
            APPLY "ENTRY" TO NPSHSYST.sek_effekt.
            RETURN NO-APPLY.
       END.
    CASE koblings_alternativ:
        WHEN '5' OR WHEN '6' OR WHEN '7'  THEN
            DO:
                c_kapasitet = DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE).
                c_grunnlag = 'Sekundærkrets'.
            END.
         OTHERWISE
            DO:
                c_kapasitet = DECIMAL(NPSHSYST.prim_kapasitet:SCREEN-VALUE).
                c_grunnlag = 'Primærkrets'.
            END.
    END CASE.

/*    CASE  NPSHSYST.type:SCREEN-VALUE:                                                         */
/*        WHEN  'FM' THEN                                                                       */
/*               RUN VELGFMDM.W (INPUT-OUTPUT  dimm_verdi, INPUT c_kapasitet, INPUT c_grunnlag).*/
/*        WHEN  'MS' THEN                                                                       */
/*               RUN VELGMSDM.W (INPUT-OUTPUT  dimm_verdi, INPUT c_kapasitet, INPUT c_grunnlag).*/
/*    END CASE.                                                                                 */
    def var hProc as handle no-undo.
    run velgNPSHGruppe.w persistent set hProc.
    subscribe to 'setValues' in hProc.
    run setValues in hProc (NPSHSYST.type:screen-value,c_kapasitet,c_grunnlag).
    run InitializeObject in hProc.
    run MoveToTop in hProc.
    
    ASSIGN NPSHSYST.shunt_dimmensjon = dimm_verdi.
    DISPLAY NPSHSYST.shunt_dimmensjon WITH FRAME ENDRE-SYSTEM.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.type C-Win
ON VALUE-CHANGED OF NPSHSYST.type IN FRAME DEFAULT-FRAME /* Type */
DO:
    /* Dersom MS-Ventil er valgt, skal MS-Ventiltype enables, hvis ikke skal det som ligger i felt slettes */
    IF SELF:SCREEN-VALUE = 'MS' THEN
        DO WITH FRAME ENDRE-SYSTEM:
            DISPLAY COMBO-BOX-VENTILTYPE.
            ENABLE COMBO-BOX-VENTILTYPE.
            ENABLE NPSHSYST.ms_shuntventil_i_leveranse.
       END.
    ELSE
        DO WITH FRAME  ENDRE-SYSTEM:
            DISABLE COMBO-BOX-VENTILTYPE.
            NPSHSYST.ms_ventiltype = "".
            NPSHSYST.ms_shuntventil_i_leveranse = FALSE.
            DISABLE NPSHSYST.ms_shuntventil_i_leveranse.
       END.
  
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
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
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

  {&OPEN-QUERY-DEFAULT-FRAME}
  GET FIRST DEFAULT-FRAME.
  DISPLAY COMBO-BOX-VENTILTYPE 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  IF AVAILABLE NPSHKOBL THEN 
    DISPLAY NPSHKOBL.betegnelse NPSHKOBL.anvendelse NPSHKOBL.prim_konst_var 
          NPSHKOBL.sek_konst_var NPSHKOBL.ventil_type NPSHKOBL.reguleringsventil 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  IF AVAILABLE NPSHSYST THEN 
    DISPLAY NPSHSYST.koblings_alternativ NPSHSYST.systembetegnelse 
          NPSHSYST.sek_effekt NPSHSYST.prim_effekt NPSHSYST.beregnet_anvendelse 
          NPSHSYST.sek_temp_inn NPSHSYST.prim_temp_inn NPSHSYST.sek_temp_ut 
          NPSHSYST.prim_temp_ut NPSHSYST.sek_kapasitet NPSHSYST.prim_kapasitet 
          NPSHSYST.ms_shuntventil_i_leveranse NPSHSYST.shunt_dimmensjon 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-29 RECT-19 RECT-21 SHUNTTEGNING NPSHSYST.koblings_alternativ 
         NPSHSYST.systembetegnelse NPSHSYST.sek_effekt NPSHSYST.prim_effekt 
         NPSHSYST.beregnet_anvendelse NPSHSYST.sek_temp_inn 
         NPSHSYST.prim_temp_inn NPSHSYST.sek_temp_ut NPSHSYST.prim_temp_ut 
         NPSHSYST.sek_kapasitet NPSHSYST.prim_kapasitet BUTTON-reset 
         NPSHSYST.type COMBO-BOX-VENTILTYPE NPSHSYST.ms_shuntventil_i_leveranse 
         Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

