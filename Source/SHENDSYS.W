&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME ENDRE-SYSTEM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS ENDRE-SYSTEM 
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
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
def var hParent as handle no-undo.
def var anleggsNavnParam like npshanlg.anlegg.
def var anleggsNrParam like NPSHANLG.anleggsnr.
def var nyRecord as logical no-undo.
def var AnleggLaast as logical no-undo.
def var current-rec as rowid no-undo.
def var systemNrParam like NPSHSYST.systemnr.

DEFINE VARIABLE dimm_verdi as char no-undo.
DEFINE VAR tegningBmp AS CHAR. 
DEFINE VAR tegningOK AS LOGICAL.
DEFINE VAR syst# LIKE NPSHSYST.systemnr.
DEFINE VAR c_anvendelse AS CHARACTER.
c_anvendelse = 'VK'.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE Current-Widget AS WIDGET-HANDLE.
DEFINE VAR pointer AS LOGICAL.  
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME ENDRE-SYSTEM

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHKOBL

/* Definitions for DIALOG-BOX ENDRE-SYSTEM                              */
&Scoped-define FIELDS-IN-QUERY-ENDRE-SYSTEM NPSHKOBL.betegnelse ~
NPSHKOBL.anvendelse NPSHKOBL.prim_konst_var NPSHKOBL.sek_konst_var ~
NPSHKOBL.ventil_type NPSHKOBL.reguleringsventil 
&Scoped-define QUERY-STRING-ENDRE-SYSTEM FOR EACH NPSHKOBL SHARE-LOCK
&Scoped-define OPEN-QUERY-ENDRE-SYSTEM OPEN QUERY ENDRE-SYSTEM FOR EACH NPSHKOBL SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-ENDRE-SYSTEM NPSHKOBL
&Scoped-define FIRST-TABLE-IN-QUERY-ENDRE-SYSTEM NPSHKOBL


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHSYST.systembetegnelse ~
NPSHSYST.koblings_alternativ NPSHSYST.prim_effekt NPSHSYST.prim_temp_inn ~
NPSHSYST.prim_temp_ut NPSHSYST.prim_kapasitet NPSHSYST.sek_effekt ~
NPSHSYST.sek_temp_inn NPSHSYST.sek_temp_ut NPSHSYST.sek_kapasitet ~
NPSHSYST.beregnet_anvendelse NPSHSYST.type ~
NPSHSYST.ms_shuntventil_i_leveranse 
&Scoped-define ENABLED-TABLES NPSHSYST
&Scoped-define FIRST-ENABLED-TABLE NPSHSYST
&Scoped-Define ENABLED-OBJECTS BUTTON-reset COMBO-BOX-VENTILTYPE Btn_OK ~
Btn_Cancel Btn_Help RECT-19 RECT-21 RECT-29 SHUNTTEGNING 
&Scoped-Define DISPLAYED-FIELDS NPSHSYST.systembetegnelse ~
NPSHSYST.koblings_alternativ NPSHKOBL.betegnelse NPSHKOBL.anvendelse ~
NPSHKOBL.prim_konst_var NPSHKOBL.sek_konst_var NPSHKOBL.ventil_type ~
NPSHKOBL.reguleringsventil NPSHSYST.prim_effekt NPSHSYST.prim_temp_inn ~
NPSHSYST.prim_temp_ut NPSHSYST.prim_kapasitet NPSHSYST.sek_effekt ~
NPSHSYST.sek_temp_inn NPSHSYST.sek_temp_ut NPSHSYST.sek_kapasitet ~
NPSHSYST.beregnet_anvendelse NPSHSYST.ms_shuntventil_i_leveranse ~
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

/* Define a dialog box                                                  */

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
     SIZE 32.4 BY 1
     FONT 2 NO-UNDO.

DEFINE IMAGE SHUNTTEGNING
     FILENAME "bmp\kobling1":U
     SIZE 29.4 BY 9.62.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 7.62.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31.2 BY 10.1.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 134 BY 3.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY ENDRE-SYSTEM FOR 
      NPSHKOBL SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME ENDRE-SYSTEM
     NPSHSYST.systembetegnelse AT ROW 1.95 COL 19 COLON-ALIGNED
          LABEL "Syst.bet."
          VIEW-AS FILL-IN 
          SIZE 44.2 BY 1
          FONT 2
     NPSHSYST.koblings_alternativ AT ROW 1.95 COL 79 COLON-ALIGNED
          LABEL "Kobl.alt."
          VIEW-AS COMBO-BOX INNER-LINES 8
          LIST-ITEMS "1","2","3","4","5","6","7","7A" 
          DROP-DOWN-LIST
          SIZE 8 BY 1
          FONT 2
     NPSHKOBL.betegnelse AT ROW 1.95 COL 89 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 46.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.anvendelse AT ROW 3.38 COL 19 COLON-ALIGNED
          LABEL "Anvendelse"
          VIEW-AS FILL-IN 
          SIZE 27.4 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.prim_konst_var AT ROW 3.62 COL 69 COLON-ALIGNED
          LABEL "Primærkrets"
          VIEW-AS FILL-IN 
          SIZE 16.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.sek_konst_var AT ROW 3.62 COL 109.2 COLON-ALIGNED
          LABEL "Sekundærkrets"
          VIEW-AS FILL-IN 
          SIZE 16.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.ventil_type AT ROW 4.67 COL 19 COLON-ALIGNED
          LABEL "Ventiltype"
          VIEW-AS FILL-IN 
          SIZE 23.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.reguleringsventil AT ROW 4.91 COL 109 COLON-ALIGNED
          LABEL "Reguleringsventil i"
          VIEW-AS FILL-IN 
          SIZE 21.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.prim_effekt AT ROW 8.14 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.prim_temp_inn AT ROW 9.19 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.prim_temp_ut AT ROW 10.29 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.prim_kapasitet AT ROW 11.33 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.sek_effekt AT ROW 8.1 COL 33.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.sek_temp_inn AT ROW 9.14 COL 33.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.sek_temp_ut AT ROW 10.24 COL 33.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     NPSHSYST.sek_kapasitet AT ROW 11.29 COL 33.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY 1
          FONT 2
     BUTTON-reset AT ROW 12.91 COL 43
     NPSHSYST.beregnet_anvendelse AT ROW 6.71 COL 58 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Varme", "Varme":U,
"Lavtemperatur", "Lavtemperatur":U,
"Lavtemp/Kaldt medium", "Lavtemp/Kaldt medium":U,
"Kjøle", "Kjøle":U,
"Fryse", "Fryse":U,
"Varmegjenvinning", "Varmegjenvinning":U
          SIZE 35.8 BY 7.38
     NPSHSYST.type AT ROW 15.52 COL 7 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "FM", "FM":U,
"MS", "MS":U
          SIZE 9 BY 3.81
          BGCOLOR 8 FGCOLOR 0 
     COMBO-BOX-VENTILTYPE AT ROW 17.71 COL 44 COLON-ALIGNED
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME ENDRE-SYSTEM
     NPSHSYST.ms_shuntventil_i_leveranse AT ROW 17.95 COL 79.2
          LABEL "MS - Shuntventil med i leveranse"
          VIEW-AS TOGGLE-BOX
          SIZE 49 BY .76
     Btn_OK AT ROW 19.76 COL 54.2
     Btn_Cancel AT ROW 19.76 COL 64.4
     Btn_Help AT ROW 19.76 COL 76.2
     NPSHSYST.shunt_dimmensjon AT ROW 16.76 COL 44 COLON-ALIGNED
          LABEL "Shuntdimmensjon"
           VIEW-AS TEXT 
          SIZE 7.6 BY .62
          BGCOLOR 8 FGCOLOR 1 FONT 2
     " Sekundær" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 7.24 COL 35.4
     " Primær" VIEW-AS TEXT
          SIZE 10.8 BY .67 AT ROW 7.33 COL 21
     "W" VIEW-AS TEXT
          SIZE 4.4 BY .67 AT ROW 8.24 COL 48
     "°C" VIEW-AS TEXT
          SIZE 5.8 BY .67 AT ROW 9.24 COL 48
     "°C" VIEW-AS TEXT
          SIZE 5.6 BY .67 AT ROW 10.52 COL 47.6
     "l/s" VIEW-AS TEXT
          SIZE 6.2 BY .62 AT ROW 11.57 COL 47.6
     "Ventil:" VIEW-AS TEXT
          SIZE 8 BY .62 AT ROW 14.81 COL 7
     RECT-19 AT ROW 6.71 COL 3
     RECT-21 AT ROW 6.71 COL 96.8
     RECT-29 AT ROW 3.24 COL 3
     SHUNTTEGNING AT ROW 7.05 COL 98
     SPACE(11.59) SKIP(4.56)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "Endre System":L
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX ENDRE-SYSTEM
   FRAME-NAME UNDERLINE Custom                                          */
ASSIGN 
       FRAME ENDRE-SYSTEM:SCROLLABLE       = FALSE
       FRAME ENDRE-SYSTEM:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN NPSHKOBL.anvendelse IN FRAME ENDRE-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHKOBL.betegnelse IN FRAME ENDRE-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX NPSHSYST.koblings_alternativ IN FRAME ENDRE-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.ms_shuntventil_i_leveranse IN FRAME ENDRE-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHKOBL.prim_konst_var IN FRAME ENDRE-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHKOBL.reguleringsventil IN FRAME ENDRE-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_effekt IN FRAME ENDRE-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_kapasitet IN FRAME ENDRE-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHKOBL.sek_konst_var IN FRAME ENDRE-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_temp_inn IN FRAME ENDRE-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_temp_ut IN FRAME ENDRE-SYSTEM
   EXP-LABEL                                                            */
ASSIGN 
       SHUNTTEGNING:SELECTABLE IN FRAME ENDRE-SYSTEM       = TRUE.

/* SETTINGS FOR FILL-IN NPSHSYST.shunt_dimmensjon IN FRAME ENDRE-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.systembetegnelse IN FRAME ENDRE-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET NPSHSYST.type IN FRAME ENDRE-SYSTEM
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHKOBL.ventil_type IN FRAME ENDRE-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX ENDRE-SYSTEM
/* Query rebuild information for DIALOG-BOX ENDRE-SYSTEM
     _TblList          = "norcalc.NPSHKOBL"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX ENDRE-SYSTEM */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME NPSHSYST.beregnet_anvendelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.beregnet_anvendelse ENDRE-SYSTEM
ON ENTRY OF NPSHSYST.beregnet_anvendelse IN FRAME ENDRE-SYSTEM /* Anvendelse */
DO:
    IF   NPSHSYST.koblings_alternativ:SCREEN-VALUE = '6' THEN
    RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help ENDRE-SYSTEM
ON CHOOSE OF Btn_Help IN FRAME ENDRE-SYSTEM /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK ENDRE-SYSTEM
ON CHOOSE OF Btn_OK IN FRAME ENDRE-SYSTEM /* OK */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-reset ENDRE-SYSTEM
ON CHOOSE OF BUTTON-reset IN FRAME ENDRE-SYSTEM /* Reset */
DO:
  Run reset.
  APPLY 'ENTRY' TO NPSHSYST.sek_effekt.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-VENTILTYPE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE ENDRE-SYSTEM
ON ANY-PRINTABLE OF COMBO-BOX-VENTILTYPE IN FRAME ENDRE-SYSTEM /* MS-Ventiltype */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE ENDRE-SYSTEM
ON CURSOR-DOWN OF COMBO-BOX-VENTILTYPE IN FRAME ENDRE-SYSTEM /* MS-Ventiltype */
DO:
  i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE ENDRE-SYSTEM
ON CURSOR-UP OF COMBO-BOX-VENTILTYPE IN FRAME ENDRE-SYSTEM /* MS-Ventiltype */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.koblings_alternativ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.koblings_alternativ ENDRE-SYSTEM
ON VALUE-CHANGED OF NPSHSYST.koblings_alternativ IN FRAME ENDRE-SYSTEM /* Kobl.alt. */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_effekt ENDRE-SYSTEM
ON ENTRY OF NPSHSYST.prim_effekt IN FRAME ENDRE-SYSTEM /* Effekt */
DO:
    RETURN NO-APPLY. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.prim_kapasitet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_kapasitet ENDRE-SYSTEM
ON ENTRY OF NPSHSYST.prim_kapasitet IN FRAME ENDRE-SYSTEM /* Kapasitet */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_temp_inn ENDRE-SYSTEM
ON ENTRY OF NPSHSYST.prim_temp_inn IN FRAME ENDRE-SYSTEM /* Temp. inn */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_temp_inn ENDRE-SYSTEM
ON LEAVE OF NPSHSYST.prim_temp_inn IN FRAME ENDRE-SYSTEM /* Temp. inn */
DO:
      RUN BeregnPrim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.prim_temp_ut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_temp_ut ENDRE-SYSTEM
ON ENTRY OF NPSHSYST.prim_temp_ut IN FRAME ENDRE-SYSTEM /* Temp. ut */
DO:
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sek_effekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_effekt ENDRE-SYSTEM
ON LEAVE OF NPSHSYST.sek_effekt IN FRAME ENDRE-SYSTEM /* Effekt */
DO:
    NPSHSYST.prim_effekt =  INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE).
    DISPLAY NPSHSYST.prim_effekt WITH FRAME ENDRE-SYSTEM.
    RUN beregnSek.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sek_kapasitet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_kapasitet ENDRE-SYSTEM
ON ENTRY OF NPSHSYST.sek_kapasitet IN FRAME ENDRE-SYSTEM /* Kapasitet */
DO:
    IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE)  > 0 THEN
      RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_kapasitet ENDRE-SYSTEM
ON LEAVE OF NPSHSYST.sek_kapasitet IN FRAME ENDRE-SYSTEM /* Kapasitet */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_temp_inn ENDRE-SYSTEM
ON LEAVE OF NPSHSYST.sek_temp_inn IN FRAME ENDRE-SYSTEM /* Temp. inn */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_temp_ut ENDRE-SYSTEM
ON LEAVE OF NPSHSYST.sek_temp_ut IN FRAME ENDRE-SYSTEM /* Temp. ut */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.shunt_dimmensjon ENDRE-SYSTEM
ON ENTRY OF NPSHSYST.shunt_dimmensjon IN FRAME ENDRE-SYSTEM /* Shuntdimmensjon */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.type ENDRE-SYSTEM
ON LEAVE OF NPSHSYST.type IN FRAME ENDRE-SYSTEM /* Type */
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

    CASE  NPSHSYST.type:SCREEN-VALUE:
        WHEN  'FM' THEN
               RUN VELGFMDM.W (INPUT-OUTPUT  dimm_verdi, INPUT c_kapasitet, INPUT c_grunnlag).
        WHEN  'MS' THEN
               RUN VELGMSDM.W (INPUT-OUTPUT  dimm_verdi, INPUT c_kapasitet, INPUT c_grunnlag).
        WHEN  'MSE' THEN
               RUN VELGMSEDM.W (INPUT-OUTPUT  dimm_verdi, INPUT c_kapasitet, INPUT c_grunnlag).
    END CASE.

/*    def var hProc as handle no-undo.                                           */
/*    run velgNPSHGruppe.w persistent set hProc.                                 */
/*    subscribe to 'setValues' in hProc.                                         */
/*    run setValues in hProc (NPSHSYST.type:screen-value,c_kapasitet,c_grunnlag).*/
/*    run InitializeObject in hProc.                                             */
/*    run MoveToTop in hProc.                                                    */
    
    ASSIGN NPSHSYST.shunt_dimmensjon = dimm_verdi.
    DISPLAY NPSHSYST.shunt_dimmensjon WITH FRAME ENDRE-SYSTEM.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.type ENDRE-SYSTEM
ON VALUE-CHANGED OF NPSHSYST.type IN FRAME ENDRE-SYSTEM /* Type */
DO:
    /* Dersom MS-Ventil er valgt, skal MS-Ventiltype enables, hvis ikke skal det som ligger i felt slettes */
    IF SELF:SCREEN-VALUE = 'MS' or SELF:SCREEN-VALUE = 'MSE' THEN
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK ENDRE-SYSTEM 


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
  anleggsnavnparam = dynamic-function('getAttribute',hParent,'anleggsnavnParam').
  FRAME {&FRAME-NAME}:TITLE   = 'Endre Shuntsystem for anlegg: ' + anleggsNavnParam.

  current-rec = dynamic-function('getCurrentRec' in hParent).
  AnleggLaast = logical(dynamic-function('getAttribute',hParent,'AnleggLaast')).
  
  SESSION:SET-WAIT-STATE("").
  /* Disse styrer MDI - simulering */
  IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:PRIVATE-DATA.
  RUN fyll_Objekt.
  IF AnleggLaast  THEN RUN visSystem.
  ELSE                 RUN endreSystem.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnPrim ENDRE-SYSTEM 
PROCEDURE beregnPrim :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VAR teller AS DECIMAL.
    DEFINE VAR nevner AS DECIMAL.
    
    DO WITH FRAME ENDRE-SYSTEM:
        IF INTEGER(NPSHSYST.prim_effekt:SCREEN-VALUE) <> 0 
            AND DECIMAL(NPSHSYST.prim_temp_inn:SCREEN-VALUE) <>  0 
            AND DECIMAL(NPSHSYST.prim_temp_ut:SCREEN-VALUE)  <>  0 THEN
            DO:
                teller = DECIMAL(prim_effekt:SCREEN-VALUE)  * 0.86.
                nevner = DECIMAL(prim_temp_inn:SCREEN-VALUE)  - DECIMAL(prim_temp_ut:SCREEN-VALUE).
                ASSIGN  NPSHSYST.prim_kapasitet = ABSOLUTE((teller  /  nevner) / 3600).
                DISPLAY  NPSHSYST.prim_kapasitet.
        END.
    END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnSek ENDRE-SYSTEM 
PROCEDURE beregnSek :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VAR teller AS DECIMAL.
    DEFINE VAR nevner AS DECIMAL.
    
    DO WITH FRAME ENDRE-SYSTEM:
        IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE) > 0 
            AND DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE) <>  0
            AND DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE)  <>  0 THEN
           /* Kapasitet er ikke kjent */
           /* FORMEL: KAPASITET = (A * 0.86) / (B - C) / 3600  */
            DO:
                teller = DECIMAL(sek_effekt:SCREEN-VALUE)  * 0.86.
                nevner = DECIMAL(sek_temp_inn:SCREEN-VALUE)  - DECIMAL(sek_temp_ut:SCREEN-VALUE).
                ASSIGN NPSHSYST.sek_kapasitet = ABSOLUTE((teller  /  nevner) / 3600).
                IF NPSHSYST.sek_kapasitet = ? THEN
                    ASSIGN NPSHSYST.sek_kapasitet = 0.
                DISPLAY  NPSHSYST.sek_kapasitet.
                ASSIGN  NPSHSYST.prim_kapasitet = NPSHSYST.sek_kapasitet.
                DISPLAY  NPSHSYST.prim_kapasitet.
            END.
        ELSE  IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE) = 0
            AND DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE) <>  0
            AND DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE)  <>  0
            AND DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE) > 0 THEN
            /* Effekt er ikke kjent */
           /* Formel: EFFEKT = (D* 3600) * (B - C) / 0.86 */
            DO:
                teller = (DECIMAL(sek_kapasitet:SCREEN-VALUE)  * 3600) *
                    (DECIMAL(sek_temp_inn:SCREEN-VALUE)  - 
                    DECIMAL(sek_temp_ut:SCREEN-VALUE)).
                nevner = 0.86.
                ASSIGN NPSHSYST.sek_effekt = ABSOLUTE((teller  /  nevner)).
                IF NPSHSYST.sek_effekt = ? THEN
                    ASSIGN NPSHSYST.sek_effekt = 0.
                DISPLAY  NPSHSYST.sek_effekt.
                ASSIGN  NPSHSYST.prim_effekt = NPSHSYST.sek_effekt.
                DISPLAY  NPSHSYST.prim_effekt.
            END.
        ELSE  IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE) > 0
            AND DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE) = 0 
            AND DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE)  >  0
            AND DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE) > 0 THEN
            /* Temperatur inn er ikke kjent */
            /* FORMEL: TEMPERATUR INN = C + (A * 0.86) / (D* 3600) */
            DO:
                teller = DECIMAL(sek_effekt:SCREEN-VALUE)  *   0.86.
                nevner =  DECIMAL(sek_kapasitet:SCREEN-VALUE)   * 3600. 
                ASSIGN NPSHSYST.sek_temp_inn =  
                    DECIMAL(sek_temp_ut:SCREEN-VALUE) + (teller  /  nevner).
                IF NPSHSYST.sek_temp_inn = ? THEN
                    ASSIGN NPSHSYST.sek_temp_inn = 0.
                DISPLAY  NPSHSYST.sek_temp_inn.
                ASSIGN  NPSHSYST.prim_temp_inn = NPSHSYST.sek_temp_inn.
                DISPLAY  NPSHSYST.prim_temp_inn.
            END.                      
        ELSE  IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE) > 0
            AND DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE) > 0 
            AND DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE)  =  0
            AND DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE) > 0 THEN
            /* Temperatur ut er ikke kjent */
            /* FORMEL: TEMPERATUR UT = B - (A * 0.86) / (D* 3600) */
            DO:
                teller = DECIMAL(sek_effekt:SCREEN-VALUE)  *   0.86.
                nevner =  DECIMAL(sek_kapasitet:SCREEN-VALUE)   * 3600. 
                ASSIGN NPSHSYST.sek_temp_ut =  
                    DECIMAL(sek_temp_inn:SCREEN-VALUE) - (teller  /  nevner).
                IF NPSHSYST.sek_temp_ut = ? THEN
                    ASSIGN NPSHSYST.sek_temp_ut = 0.
                IF NPSHSYST.sek_temp_ut < 0 THEN
                    ASSIGN NPSHSYST.sek_temp_ut = (NPSHSYST.sek_temp_ut  *  -1).
                DISPLAY  NPSHSYST.sek_temp_ut.
                ASSIGN  NPSHSYST.prim_temp_ut = NPSHSYST.sek_temp_ut.
                DISPLAY  NPSHSYST.prim_temp_ut.
            END.                      
    END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI ENDRE-SYSTEM  _DEFAULT-DISABLE
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
  HIDE FRAME ENDRE-SYSTEM.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI ENDRE-SYSTEM  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-VENTILTYPE 
      WITH FRAME ENDRE-SYSTEM.
  IF AVAILABLE NPSHKOBL THEN 
    DISPLAY NPSHKOBL.betegnelse NPSHKOBL.anvendelse NPSHKOBL.prim_konst_var 
          NPSHKOBL.sek_konst_var NPSHKOBL.ventil_type NPSHKOBL.reguleringsventil 
      WITH FRAME ENDRE-SYSTEM.
  IF AVAILABLE NPSHSYST THEN 
    DISPLAY NPSHSYST.systembetegnelse NPSHSYST.koblings_alternativ 
          NPSHSYST.prim_effekt NPSHSYST.prim_temp_inn NPSHSYST.prim_temp_ut 
          NPSHSYST.prim_kapasitet NPSHSYST.sek_effekt NPSHSYST.sek_temp_inn 
          NPSHSYST.sek_temp_ut NPSHSYST.sek_kapasitet 
          NPSHSYST.beregnet_anvendelse NPSHSYST.ms_shuntventil_i_leveranse 
          NPSHSYST.shunt_dimmensjon 
      WITH FRAME ENDRE-SYSTEM.
  ENABLE NPSHSYST.systembetegnelse NPSHSYST.koblings_alternativ 
         NPSHSYST.prim_effekt NPSHSYST.prim_temp_inn NPSHSYST.prim_temp_ut 
         NPSHSYST.prim_kapasitet NPSHSYST.sek_effekt NPSHSYST.sek_temp_inn 
         NPSHSYST.sek_temp_ut NPSHSYST.sek_kapasitet BUTTON-reset 
         NPSHSYST.beregnet_anvendelse NPSHSYST.type COMBO-BOX-VENTILTYPE 
         NPSHSYST.ms_shuntventil_i_leveranse Btn_OK Btn_Cancel Btn_Help RECT-19 
         RECT-21 RECT-29 SHUNTTEGNING 
      WITH FRAME ENDRE-SYSTEM.
  VIEW FRAME ENDRE-SYSTEM.
  {&OPEN-BROWSERS-IN-QUERY-ENDRE-SYSTEM}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreSystem ENDRE-SYSTEM 
PROCEDURE endreSystem :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DO TRANSACTION:
  FIND NPSHSYST WHERE ROWID(NPSHSYST) = current-rec EXCLUSIVE-LOCK
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
                if can-do(combo-box-ventiltype:list-items,NPSHSYST.ms_ventiltype) then 
                  COMBO-BOX-VENTILTYPE:SCREEN-VALUE = NPSHSYST.ms_ventiltype.            
                  DISPLAY  COMBO-BOX-VENTILTYPE.
                  ENABLE COMBO-BOX-VENTILTYPE.
                  DISPLAY NPSHSYST.ms_shuntventil_i_leveranse.
                  ENABLE NPSHSYST.ms_shuntventil_i_leveranse.
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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_objekt ENDRE-SYSTEM 
PROCEDURE fyll_objekt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var cTmp as char no-undo.
  do with frame {&Frame-name}:  
  assign 
    COMBO-BOX-VENTILTYPE:list-items = replace(JBoxServerAPI:Instance:FieldList('NPSHVentilType;ventiltype','where true'),'|',',')
    NPSHSYST.type:radio-buttons = replace(JBoxServerAPI:Instance:FieldList('NPSHGruppeType;NPSHGruppeTypeNavn;NPSHGruppeTypeNavn','where true'),'|',',')
  .
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_hastighet ENDRE-SYSTEM 
PROCEDURE prc_hastighet :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var v_prim as decimal format ">>>9,999999".
define var v_sek as decimal format ">>>9,999999".
define var pi as decimal initial 3.14.

find  NPIndrediam where dimm = NPSHSYST.shunt_dimmensjon no-error.
if available NPIndrediam then
    do:
        v_prim = NPSHSYST.prim_kapasitet * 1000 /  ((indre_diameter * indre_diameter * pi) / 4).
        v_sek = NPSHSYST.sek_kapasitet * 1000 /   ((indre_diameter * indre_diameter * pi) / 4).
        ASSIGN 
            NPSHSYST.prim_hastighet = v_prim
            NPSHSYST.sek_hastighet = v_sek.
    end.
else
  MESSAGE 'Posten NPIndrediam ble ikke funnet med valgt shunt_dimmensjon: ' NPSHSYST.shunt_dimmensjon
  VIEW-AS ALERT-BOX.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset ENDRE-SYSTEM 
PROCEDURE reset :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   NPSHSYST.prim_effekt = 0.
   NPSHSYST.sek_effekt = 0.
   NPSHSYST.prim_temp_inn = 0.
   NPSHSYST.sek_temp_inn = 0.
   NPSHSYST.prim_temp_ut = 0.
   NPSHSYST.sek_temp_ut = 0.
   NPSHSYST.prim_kapasitet = 0.
   NPSHSYST.sek_kapasitet =0.

    DISPLAY 
          NPSHSYST.prim_effekt NPSHSYST.sek_effekt NPSHSYST.prim_temp_inn 
          NPSHSYST.sek_temp_inn NPSHSYST.prim_temp_ut NPSHSYST.sek_temp_ut 
          NPSHSYST.prim_kapasitet NPSHSYST.sek_kapasitet 
      WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE visSystem ENDRE-SYSTEM 
PROCEDURE visSystem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION: 
  FIND NPSHSYST WHERE ROWID(NPSHSYST) = Current-Rec EXCLUSIVE-LOCK
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
                if can-do(combo-box-ventiltype:list-items,NPSHSYST.ms_ventiltype) then 
                  COMBO-BOX-VENTILTYPE:SCREEN-VALUE = NPSHSYST.ms_ventiltype.            
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

