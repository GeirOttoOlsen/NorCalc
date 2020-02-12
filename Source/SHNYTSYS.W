&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME NYTT-SYSTEM
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS NYTT-SYSTEM 
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
/*DEFINE INPUT PARAMETER appdata AS CHARACTER.    */

/*DEFINE INPUT PARAMETER anleggsNavnParam AS CHAR.*/
/*DEFINE SHARED VAR nyRecord AS LOGICAL.                          */
/*DEFINE SHARED VARIABLE anleggsnrParam LIKE NPSHANLG.anleggsnr.  */
/*DEFINE SHARED VARIABLE current-rec as ROWID.                    */
/*DEFINE NEW SHARED VARIABLE systemnrParam LIKE NPSHSYST.systemnr.*/

def var anleggsNavnParam like NPSHANLG.anlegg no-undo.
def var anleggsNrParam like NPSHANLG.anleggsnr no-undo.
def var systemNrParam like NPSHSYST.systemnr.
def var nyRecord as logical.
def var current-rec as rowid.
def var hParent as handle no-undo.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME NYTT-SYSTEM

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHKOBL

/* Definitions for DIALOG-BOX NYTT-SYSTEM                               */
&Scoped-define FIELDS-IN-QUERY-NYTT-SYSTEM NPSHKOBL.betegnelse ~
NPSHKOBL.anvendelse NPSHKOBL.sek_konst_var NPSHKOBL.prim_konst_var ~
NPSHKOBL.reguleringsventil NPSHKOBL.ventil_type 
&Scoped-define QUERY-STRING-NYTT-SYSTEM FOR EACH NPSHKOBL SHARE-LOCK
&Scoped-define OPEN-QUERY-NYTT-SYSTEM OPEN QUERY NYTT-SYSTEM FOR EACH NPSHKOBL SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-NYTT-SYSTEM NPSHKOBL
&Scoped-define FIRST-TABLE-IN-QUERY-NYTT-SYSTEM NPSHKOBL


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
NPSHKOBL.sek_konst_var NPSHKOBL.prim_konst_var NPSHKOBL.reguleringsventil ~
NPSHKOBL.ventil_type NPSHSYST.prim_effekt NPSHSYST.prim_temp_inn ~
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
     SIZE 11.2 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help":L 
     SIZE 11.2 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&OK":L 
     SIZE 11.2 BY 1
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-reset 
     LABEL "&Reset" 
     SIZE 9.8 BY 1.

DEFINE VARIABLE COMBO-BOX-VENTILTYPE AS CHARACTER FORMAT "X(256)":U 
     LABEL "MS-Ventiltype" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 29.4 BY 1.05
     FONT 2 NO-UNDO.

DEFINE IMAGE SHUNTTEGNING
     FILENAME "bmp\kobling1":U
     SIZE 29.6 BY 9.62.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56.2 BY 8.67.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 30.8 BY 10.14.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 123.8 BY 3.91.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY NYTT-SYSTEM FOR 
      NPSHKOBL SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME NYTT-SYSTEM
     NPSHSYST.systembetegnelse AT ROW 1.43 COL 15 COLON-ALIGNED
          LABEL "Syst.bet."
          VIEW-AS FILL-IN 
          SIZE 49.6 BY 1
          FONT 2
     NPSHSYST.koblings_alternativ AT ROW 1.38 COL 77.4 COLON-ALIGNED
          LABEL "Kobl.alt."
          VIEW-AS COMBO-BOX INNER-LINES 8
          LIST-ITEMS "1","2","3","4","5","6","7","7A" 
          DROP-DOWN-LIST
          SIZE 9 BY 1
          FONT 2
     NPSHKOBL.betegnelse AT ROW 1.38 COL 87 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.6 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.anvendelse AT ROW 3.48 COL 17 COLON-ALIGNED
          LABEL "Anvendelse"
          VIEW-AS FILL-IN 
          SIZE 22.6 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.sek_konst_var AT ROW 3.48 COL 99.8 COLON-ALIGNED
          LABEL "Sekundærside"
          VIEW-AS FILL-IN 
          SIZE 22.6 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.prim_konst_var AT ROW 3.52 COL 56 COLON-ALIGNED
          LABEL "Primærside"
          VIEW-AS FILL-IN 
          SIZE 22.6 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.reguleringsventil AT ROW 5 COL 92.6 COLON-ALIGNED
          LABEL "Reguleringsventil i"
          VIEW-AS FILL-IN 
          SIZE 29.6 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHKOBL.ventil_type AT ROW 5.05 COL 17 COLON-ALIGNED
          LABEL "Ventiltype"
          VIEW-AS FILL-IN 
          SIZE 19.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.prim_effekt AT ROW 9.24 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.8 BY 1
          FONT 2
     NPSHSYST.prim_temp_inn AT ROW 10.62 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1
          FONT 2
     NPSHSYST.prim_temp_ut AT ROW 11.95 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1
          FONT 2
     NPSHSYST.prim_kapasitet AT ROW 13.29 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
          FONT 2
     NPSHSYST.sek_effekt AT ROW 9.24 COL 31.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.8 BY 1
          FONT 2
     NPSHSYST.sek_temp_inn AT ROW 10.62 COL 31.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1
          FONT 2
     NPSHSYST.sek_temp_ut AT ROW 11.95 COL 31.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1
          FONT 2
     NPSHSYST.sek_kapasitet AT ROW 13.29 COL 31.4 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.8 BY 1
          FONT 2
     BUTTON-reset AT ROW 15 COL 27.8
     NPSHSYST.beregnet_anvendelse AT ROW 7.62 COL 61 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Varme", "Varme":U,
"Lavtemperatur", "Lavtemperatur":U,
"Lavtemp/Kaldt medium", "Lavtemp/Kaldt medium":U,
"Kjøle", "Kjøle":U,
"Fryse", "Fryse":U,
"Varmegjenvinning", "Varmegjenvinning":U
          SIZE 33.6 BY 6.38
     NPSHSYST.type AT ROW 16.67 COL 28 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "FM", "FM":U,
"MS", "MS":U
          SIZE 28.6 BY 1.24
          BGCOLOR 8 FGCOLOR 0 
     COMBO-BOX-VENTILTYPE AT ROW 17.95 COL 25.6 COLON-ALIGNED
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME NYTT-SYSTEM
     NPSHSYST.ms_shuntventil_i_leveranse AT ROW 18.1 COL 58.2
          LABEL "MS - Shuntventil med i leveranse"
          VIEW-AS TOGGLE-BOX
          SIZE 47.8 BY .95
     Btn_OK AT ROW 19.91 COL 86.8
     Btn_Cancel AT ROW 19.91 COL 100.2
     Btn_Help AT ROW 19.91 COL 113.6
     NPSHSYST.shunt_dimmensjon AT ROW 16.81 COL 81.4 COLON-ALIGNED
          LABEL "Shuntdimmensjon"
           VIEW-AS TEXT 
          SIZE 10.6 BY .86
          BGCOLOR 8 FGCOLOR 1 FONT 2
     " Primær" VIEW-AS TEXT
          SIZE 11.2 BY .81 AT ROW 8.24 COL 18
     " Sekundær" VIEW-AS TEXT
          SIZE 14.2 BY .81 AT ROW 8.24 COL 33.2
     "W" VIEW-AS TEXT
          SIZE 4 BY .81 AT ROW 9.38 COL 47.6
     "°C" VIEW-AS TEXT
          SIZE 3.6 BY .81 AT ROW 10.86 COL 47.6
     "°C" VIEW-AS TEXT
          SIZE 3.6 BY .81 AT ROW 12.19 COL 47.6
     "l/s" VIEW-AS TEXT
          SIZE 4.2 BY .76 AT ROW 13.62 COL 47.6
     "Ventil:" VIEW-AS TEXT
          SIZE 10 BY .76 AT ROW 16.95 COL 16
     RECT-19 AT ROW 7.62 COL 2.4
     RECT-21 AT ROW 7.1 COL 95
     RECT-29 AT ROW 2.95 COL 2.2
     SHUNTTEGNING AT ROW 7.29 COL 96
     SPACE(1.99) SKIP(4.27)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "":L
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX NYTT-SYSTEM
   NOT-VISIBLE UNDERLINE Custom                                         */
ASSIGN 
       FRAME NYTT-SYSTEM:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN NPSHKOBL.anvendelse IN FRAME NYTT-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHKOBL.betegnelse IN FRAME NYTT-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX NPSHSYST.koblings_alternativ IN FRAME NYTT-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.ms_shuntventil_i_leveranse IN FRAME NYTT-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHKOBL.prim_konst_var IN FRAME NYTT-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHKOBL.reguleringsventil IN FRAME NYTT-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_effekt IN FRAME NYTT-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_kapasitet IN FRAME NYTT-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHKOBL.sek_konst_var IN FRAME NYTT-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_temp_inn IN FRAME NYTT-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_temp_ut IN FRAME NYTT-SYSTEM
   EXP-LABEL                                                            */
ASSIGN 
       SHUNTTEGNING:SELECTABLE IN FRAME NYTT-SYSTEM       = TRUE.

/* SETTINGS FOR FILL-IN NPSHSYST.shunt_dimmensjon IN FRAME NYTT-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.systembetegnelse IN FRAME NYTT-SYSTEM
   EXP-LABEL                                                            */
/* SETTINGS FOR RADIO-SET NPSHSYST.type IN FRAME NYTT-SYSTEM
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHKOBL.ventil_type IN FRAME NYTT-SYSTEM
   NO-ENABLE EXP-LABEL                                                  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX NYTT-SYSTEM
/* Query rebuild information for DIALOG-BOX NYTT-SYSTEM
     _TblList          = "norcalc.NPSHKOBL"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX NYTT-SYSTEM */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME NPSHSYST.beregnet_anvendelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.beregnet_anvendelse NYTT-SYSTEM
ON ENTRY OF NPSHSYST.beregnet_anvendelse IN FRAME NYTT-SYSTEM /* Anvendelse */
DO:
  IF   NPSHSYST.koblings_alternativ:SCREEN-VALUE = '6' THEN
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel NYTT-SYSTEM
ON CHOOSE OF Btn_Cancel IN FRAME NYTT-SYSTEM /* Cancel */
DO:
    nyRecord = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help NYTT-SYSTEM
ON CHOOSE OF Btn_Help IN FRAME NYTT-SYSTEM /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK NYTT-SYSTEM
ON CHOOSE OF Btn_OK IN FRAME NYTT-SYSTEM /* OK */
DO:
  if not npshsys.type:MODIFIED then run onLeaveOf_type.
  current-rec = ROWID(NPSHSYST).
/*  nyRecord = TRUE.*/ /*Er allerede satt ved oppstart...*/
  dynamic-function('setCurrentRec' in hParent,current-rec).
  
  /* Dersom MS-Ventil er valgt, må ventiltype velges */
  IF NPSHSYST.type:SCREEN-VALUE = 'MS' AND COMBO-BOX-VENTILTYPE:SCREEN-VALUE = "" THEN
    DO:
        MESSAGE 'Når MS-Ventil er valgt, må også ventiltype velges' VIEW-AS ALERT-BOX 
            TITLE 'Registreringsfeil'.
        RETURN NO-APPLY.
    END.

  /* Dersom MS-Ventil er valgt, skjekk om NPSHMKVS har denne kombinasjonen av 
    ventiltype og shuntdommensjon */
  IF NPSHSYST.type:SCREEN-VALUE = 'MS' THEN  
    DO:
        FIND FIRST NPSHMKVS WHERE NPSHMKVS.ventiltype = COMBO-BOX-VENTILTYPE:SCREEN-VALUE        
                              AND NPSHMKVS.shunt_dimmensjon = dimm_verdi NO-LOCK NO-ERROR NO-WAIT.
        IF NOT AVAILABLE NPSHMKVS THEN
            DO:
                MESSAGE 'I Bergningdata er det ikke definert KVS- Verdi for ventiltype ' + 
                    COMBO-BOX-VENTILTYPE:SCREEN-VALUE + ' med dimmensjon ' +
                    dimm_verdi + '.' VIEW-AS ALERT-BOX TITLE 'Registreringsfeil'.
                RETURN NO-APPLY.
            END.
    END.


 ASSIGN
        NPSHSYST.systembetegnelse NPSHSYST.koblings_alternativ 
        NPSHSYST.prim_effekt 
        NPSHSYST.sek_effekt NPSHSYST.beregnet_anvendelse 
        NPSHSYST.prim_temp_inn NPSHSYST.sek_temp_inn 
        NPSHSYST.prim_temp_ut NPSHSYST.sek_temp_ut 
        NPSHSYST.prim_kapasitet NPSHSYST.sek_kapasitet
        NPSHSYST.type  NPSHSYST.ms_ventiltype = COMBO-BOX-VENTILTYPE:SCREEN-VALUE
        NPSHSYST.ms_shuntventil_i_leveranse
        NPSHSYST.shunt_dimmensjon_num = INTEGER(NPSHSYST.shunt_dimmensjon).
/* Beregn hastiget */
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
    WHEN 'Kjøle' THEN
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
            /* prim‘r og sekund‘r er like */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_sek <> "" THEN
                    c_kode = c_kode + '-' + NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek + '/' +  
                        NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek.
                ELSE
                    c_kode = c_kode + '- 0/0'.
            END.
        WHEN '2' OR WHEN '3' OR WHEN '6' THEN
            /* kun sekund‘rside */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_sek <> "" THEN
                    c_kode = c_kode + '-KUL' + NPSHSYST.strupe_dimmensjon_sek + '/' + NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek.
                ELSE
                    c_kode = c_kode + '-0/0'.
            END.
        WHEN '4' THEN
            /* kun prim‘rside */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_prim <> "" THEN
                    c_kode = c_kode + '-' +  NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_prim + '/KUL' + NPSHSYST.strupe_dimmensjon_prim.
                ELSE
                    c_kode = c_kode + '-0/0'.
            END.
        WHEN '5' OR WHEN '7' THEN
            /* b†de prim‘rside or sekund‘rside */
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
    c_kode = c_kode + '-' + SUBSTRING(NPSHSYST.tillegg_montasje,1,1).
ELSE
    c_kode = c_kode + '- ??'.

/*  Kapsling */
IF  NPSHSYST.tillegg_kapsling <> "Kapsling, Ingen" THEN
    c_kode = c_kode + '-' + SUBSTRING(NPSHSYST.tillegg_kapsling, 10, 11).

 ASSIGN NPSHSYST.system_kode = c_kode.

 /* Sett defaultverdier for beregning */
 CASE NPSHSYST.beregnet_anvendelse:
     WHEN 'Varme' OR WHEN 'Lavtemperatur' THEN
         ASSIGN NPSHSYST.motstand_objekt = 10
             NPSHSYST.motstand_objekt_avtrekk =10
             NPSHSYST.motstand_objekt_innblaasning  = 10
             NPSHSYST.motstand_ror_bend = 5
             NPSHSYST.motstand_ror_bend_avtrekk = 5
             NPSHSYST.motstand_ror_bend_innblaasning = 5
             NPSHSYST.motstand_ror_bend_prim = 5
             NPSHSYST.motstand_ror_bend_sek = 5
             NPSHSYST.glykol = 'Ingen'
             NPSHSYST.tillegg_pumpetype = 'Våtløper'.
     WHEN 'Kjøle' THEN
         ASSIGN NPSHSYST.motstand_objekt = 25
             NPSHSYST.motstand_objekt_avtrekk =25
             NPSHSYST.motstand_objekt_innblaasning  = 25
             NPSHSYST.motstand_ror_bend = 5
             NPSHSYST.motstand_ror_bend_avtrekk = 5
             NPSHSYST.motstand_ror_bend_innblaasning = 5
             NPSHSYST.motstand_ror_bend_prim = 5
             NPSHSYST.motstand_ror_bend_sek = 5
             NPSHSYST.glykol = 'Ingen'
             NPSHSYST.tillegg_pumpetype = 'Tørrløper'
             NPSHSYST.tillegg_pumpe_fabrikat = 'Kolmeks (Flygt)'.
     WHEN 'Fryse' THEN
         ASSIGN NPSHSYST.motstand_objekt = 25
             NPSHSYST.motstand_objekt_avtrekk =25
             NPSHSYST.motstand_objekt_innblaasning  = 25
             NPSHSYST.motstand_ror_bend = 5
             NPSHSYST.motstand_ror_bend_avtrekk = 5
             NPSHSYST.motstand_ror_bend_innblaasning = 5
             NPSHSYST.motstand_ror_bend_prim = 5
             NPSHSYST.motstand_ror_bend_sek = 5
             NPSHSYST.glykol = 'Ingen'
             NPSHSYST.tillegg_pumpetype = 'Tørrløper'
             NPSHSYST.tillegg_pumpe_fabrikat = 'Kolmeks (Flygt)'.
     WHEN 'Varmegjenvinning' THEN
         ASSIGN NPSHSYST.motstand_objekt_innblaasning = 45
             NPSHSYST.motstand_objekt_avtrekk =45
             NPSHSYST.motstand_ror_bend = 10
             NPSHSYST.motstand_ror_bend_avtrekk = 5
             NPSHSYST.motstand_ror_bend_innblaasning = 3
             NPSHSYST.motstand_ror_bend_prim = 10
             NPSHSYST.motstand_ror_bend_sek = 10
             NPSHSYST.glykol = 'Ingen'
             NPSHSYST.tillegg_pumpetype = 'Tørrløper'
             NPSHSYST.tillegg_pumpe_fabrikat = 'Kolmeks (Flygt)'.
     END CASE.
  MESSAGE NPSHSYST.anleggsnr skip NPSHSYST.systemnr NPSHSYST.prod_nr
  VIEW-AS ALERT-BOX.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-reset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-reset NYTT-SYSTEM
ON CHOOSE OF BUTTON-reset IN FRAME NYTT-SYSTEM /* Reset */
DO:
  Run reset.
  APPLY 'ENTRY' TO NPSHSYST.sek_effekt.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-VENTILTYPE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE NYTT-SYSTEM
ON ANY-PRINTABLE OF COMBO-BOX-VENTILTYPE IN FRAME NYTT-SYSTEM /* MS-Ventiltype */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE NYTT-SYSTEM
ON CURSOR-DOWN OF COMBO-BOX-VENTILTYPE IN FRAME NYTT-SYSTEM /* MS-Ventiltype */
DO:
  i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE NYTT-SYSTEM
ON CURSOR-UP OF COMBO-BOX-VENTILTYPE IN FRAME NYTT-SYSTEM /* MS-Ventiltype */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE NYTT-SYSTEM
ON VALUE-CHANGED OF COMBO-BOX-VENTILTYPE IN FRAME NYTT-SYSTEM /* MS-Ventiltype */
DO:
  IF SELF:SCREEN-VALUE = ? THEN
    DO WITH FRAME {&FRAME-NAME}:
        DEFINE VAR cType AS CHAR.
         
        cType =  COMBO-BOX-VENTILTYPE:ENTRY (1).
        COMBO-BOX-VENTILTYPE:SCREEN-VALUE = cType.
    END.        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.koblings_alternativ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.koblings_alternativ NYTT-SYSTEM
ON VALUE-CHANGED OF NPSHSYST.koblings_alternativ IN FRAME NYTT-SYSTEM /* Kobl.alt. */
DO:
    FIND NPSHKOBL WHERE NPSHKOBL.koblingsalternativ = 
        NPSHSYST.koblings_alternativ:SCREEN-VALUE.
    IF AVAILABLE(NPSHKOBL) THEN
    DISPLAY 
        norcalc.NPSHKOBL.betegnelse norcalc.NPSHKOBL.anvendelse 
        norcalc.NPSHKOBL.sek_konst_var norcalc.NPSHKOBL.prim_konst_var 
        norcalc.NPSHKOBL.reguleringsventil norcalc.NPSHKOBL.ventil_type 
      WITH FRAME NYTT-SYSTEM.

    /* Vis riktig tegning */
    CASE NPSHSYST.koblings_alternativ:SCREEN-VALUE:
        WHEN '1' THEN
            DO:
                tegningBmp = 'kobling1.bmp'.
                /* Reset ev. valg av kobling 6 */
                NPSHSYST.beregnet_anvendelse = 'Varme'.
                DISPLAY NPSHSYST.beregnet_anvendelse WITH FRAME {&FRAME-NAME}.
            END.
        WHEN '2' THEN
            DO:
                tegningBmp = 'kobling2.bmp'.
                /* Reset ev. valg av kobling 6 */
                NPSHSYST.beregnet_anvendelse = 'Varme'.
                DISPLAY NPSHSYST.beregnet_anvendelse WITH FRAME {&FRAME-NAME}.
            END.
        WHEN '3' THEN
            DO:
                tegningBmp = 'kobling3.bmp'.
                /* Reset ev. valg av kobling 6 */
                NPSHSYST.beregnet_anvendelse = 'Varme'.
                DISPLAY NPSHSYST.beregnet_anvendelse WITH FRAME {&FRAME-NAME}.
            END.
        WHEN '4' THEN
            DO:
                tegningBmp = 'kobling4.bmp'.
                /* Reset ev. valg av kobling 6 */
                NPSHSYST.beregnet_anvendelse = 'Varme'.
                DISPLAY NPSHSYST.beregnet_anvendelse WITH FRAME {&FRAME-NAME}.
            END.
        WHEN '5' THEN
            DO:
                tegningBmp = 'kobling5.bmp'.
                /* Reset ev. valg av kobling 6 */
                NPSHSYST.beregnet_anvendelse = 'Varme'.
                DISPLAY NPSHSYST.beregnet_anvendelse WITH FRAME {&FRAME-NAME}.
            END.
        WHEN '6' THEN
            DO:
                tegningBmp = 'kobling6.bmp'.
                /* Kun varmegjenvinning er mulig */
                NPSHSYST.beregnet_anvendelse = 'Varmegjenvinning'.
                DISPLAY NPSHSYST.beregnet_anvendelse WITH FRAME {&FRAME-NAME}.
            END.
        WHEN '7' THEN
            DO:
                tegningBmp = 'kobling7.bmp'.
                /* Reset ev. valg av kobling 6 */
                NPSHSYST.beregnet_anvendelse = 'Varme'.
                DISPLAY NPSHSYST.beregnet_anvendelse WITH FRAME {&FRAME-NAME}.
            END.
        WHEN '7A' THEN
            DO:
                tegningBmp = 'koblin7a.bmp'.
                /* Reset ev. valg av kobling 6 */
                NPSHSYST.beregnet_anvendelse = 'Varme'.
                DISPLAY NPSHSYST.beregnet_anvendelse WITH FRAME {&FRAME-NAME}.
            END.
        WHEN 'xx' THEN
            DO:
                tegningBmp = 'koblingx.bmp'.
                /* Reset ev. valg av kobling 6 */
                NPSHSYST.beregnet_anvendelse = 'Varme'.
                DISPLAY NPSHSYST.beregnet_anvendelse WITH FRAME {&FRAME-NAME}.
            END.
    END CASE.
   tegningOK = SHUNTTEGNING:LOAD-IMAGE (tegningBmp,0,0,140,202).
  DISPLAY SHUNTTEGNING WITH FRAME NYTT-SYSTEM.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.prim_effekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_effekt NYTT-SYSTEM
ON ENTRY OF NPSHSYST.prim_effekt IN FRAME NYTT-SYSTEM /* Effekt */
DO:
    RETURN NO-APPLY. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.prim_kapasitet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_kapasitet NYTT-SYSTEM
ON ENTRY OF NPSHSYST.prim_kapasitet IN FRAME NYTT-SYSTEM /* Kapasitet */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_temp_inn NYTT-SYSTEM
ON ENTRY OF NPSHSYST.prim_temp_inn IN FRAME NYTT-SYSTEM /* Temp. inn */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_temp_inn NYTT-SYSTEM
ON LEAVE OF NPSHSYST.prim_temp_inn IN FRAME NYTT-SYSTEM /* Temp. inn */
DO:
      RUN BeregnPrim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.prim_temp_ut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.prim_temp_ut NYTT-SYSTEM
ON ENTRY OF NPSHSYST.prim_temp_ut IN FRAME NYTT-SYSTEM /* Temp. ut */
DO:
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sek_effekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_effekt NYTT-SYSTEM
ON LEAVE OF NPSHSYST.sek_effekt IN FRAME NYTT-SYSTEM /* Effekt */
DO:
    NPSHSYST.prim_effekt =  INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE).
    DISPLAY NPSHSYST.prim_effekt WITH FRAME NYTT-SYSTEM.
    RUN beregnSek.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sek_kapasitet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_kapasitet NYTT-SYSTEM
ON ENTRY OF NPSHSYST.sek_kapasitet IN FRAME NYTT-SYSTEM /* Kapasitet */
DO:
    IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE)  > 0 
        AND DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE) > 0 
        AND DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE) > 0 THEN
      RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_kapasitet NYTT-SYSTEM
ON LEAVE OF NPSHSYST.sek_kapasitet IN FRAME NYTT-SYSTEM /* Kapasitet */
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
                 DISPLAY NPSHSYST.prim_kapasitet WITH FRAME NYTT-SYSTEM.
            END.
      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sek_temp_inn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_temp_inn NYTT-SYSTEM
ON LEAVE OF NPSHSYST.sek_temp_inn IN FRAME NYTT-SYSTEM /* Temp. inn */
DO:
           CASE NPSHSYST.koblings_alternativ:SCREEN-VALUE:
          WHEN '1' OR WHEN '2' OR WHEN '3' OR WHEN '4' OR WHEN '7A' THEN
               DO:
                     NPSHSYST.prim_temp_inn = DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE).
                     DISPLAY NPSHSYST.prim_temp_inn WITH FRAME NYTT-SYSTEM.
              END. 
           WHEN '6' THEN
                 DO:
                     NPSHSYST.prim_temp_ut = DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE).
                     DISPLAY NPSHSYST.prim_temp_ut WITH FRAME NYTT-SYSTEM.
               END.
          END CASE.
          RUN BeregnSek.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sek_temp_ut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sek_temp_ut NYTT-SYSTEM
ON LEAVE OF NPSHSYST.sek_temp_ut IN FRAME NYTT-SYSTEM /* Temp. ut */
DO:
     CASE NPSHSYST.koblings_alternativ:SCREEN-VALUE:
      WHEN '1' OR WHEN '2' OR WHEN '3'  OR WHEN '4' OR WHEN '5' OR WHEN '7' 
        OR WHEN '7A' THEN
          DO:
                NPSHSYST.prim_temp_ut = DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE).
                DISPLAY NPSHSYST.prim_temp_ut WITH FRAME NYTT-SYSTEM.
          END.
      WHEN '6' THEN
            DO:
                NPSHSYST.prim_temp_inn = DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE).
                DISPLAY NPSHSYST.prim_temp_inn WITH FRAME NYTT-SYSTEM.
            END.
      END CASE.
      RUN BeregnSek.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.shunt_dimmensjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.shunt_dimmensjon NYTT-SYSTEM
ON ENTRY OF NPSHSYST.shunt_dimmensjon IN FRAME NYTT-SYSTEM /* Shuntdimmensjon */
DO:
/*    DEFINE VAR c_kapasitet  LIKE NPSHSYST.prim_kapasitet.
    DEFINE VAR c_grunnlag AS CHARACTER.

    ASSIGN
      FRAME NYTT-SYSTEM NPSHSYST.koblings_alternativ
      FRAME NYTT-SYSTEM  NPSHSYST.prim_kapasitet
      FRAME NYTT-SYSTEM  NPSHSYST.sek_kapasitet.
    IF NPSHSYST.prim_kapasitet = 0 AND NPSHSYST.sek_kapasitet = 0 THEN
        DO:
            MESSAGE 'Shuntdimmensjon kan ikke beregnes når kapasitet er 0'.
            APPLY "ENTRY" TO NPSHSYST.sek_effekt.
            RETURN NO-APPLY.
       END.
    CASE koblings_alternativ:
        WHEN '5' OR WHEN '6' OR WHEN '7'   THEN
            DO:
                c_kapasitet = DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE).
                c_grunnlag = 'Sekund‘rkrets'.
            END.
         OTHERWISE
            DO:
                c_kapasitet = DECIMAL(NPSHSYST.prim_kapasitet:SCREEN-VALUE).
                c_grunnlag = 'Prim‘rkrets'.
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
    DISPLAY NPSHSYST.shunt_dimmensjon WITH FRAME NYTT-SYSTEM.
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.type NYTT-SYSTEM
ON LEAVE OF NPSHSYST.type IN FRAME NYTT-SYSTEM /* Type */
DO:
  run onLeaveOf_type.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.type NYTT-SYSTEM
ON VALUE-CHANGED OF NPSHSYST.type IN FRAME NYTT-SYSTEM /* Type */
DO:
    /* Dersom MS-Ventil er valgt, skal MS-Ventiltype enables, hvis ikke skal det som ligger i felt slettes */
    IF SELF:SCREEN-VALUE = 'MS' THEN
        DO WITH FRAME NYTT-SYSTEM:
            ENABLE COMBO-BOX-VENTILTYPE.            
            ENABLE NPSHSYST.ms_shuntventil_i_leveranse.
       END.
    ELSE
        DO WITH FRAME  NYTT-SYSTEM:            
            DISABLE COMBO-BOX-VENTILTYPE.
            NPSHSYST.ms_ventiltype = "".
            NPSHSYST.ms_shuntventil_i_leveranse = FALSE.
            DISABLE NPSHSYST.ms_shuntventil_i_leveranse.
       END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK NYTT-SYSTEM 


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
   /* Disse styrer MDI - simulering */

  hParent = source-procedure.
  IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:PRIVATE-DATA.
  anleggsnrparam = int(dynamic-function('getAttribute',hParent,'anleggsnrParam')).
  anleggsnavnparam = dynamic-function('getAttribute',hParent,'anleggsnavnParam').
  systemNrParam    = int(dynamic-function('getAttribute',hParent,'systemNrParam')).   
  FRAME {&FRAME-NAME}:TITLE = 'Nytt Shuntsystem for anlegg: ' + anleggsNavnParam.
  RUN enable_UI.
  SESSION:SET-WAIT-STATE("").
   
  RUN fyll_ventiltype_combo.
  RUN nyttSystem.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnPrim NYTT-SYSTEM 
PROCEDURE beregnPrim :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VAR teller AS DECIMAL.
    DEFINE VAR nevner AS DECIMAL.
    
    DO WITH FRAME NYTT-SYSTEM:
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnSek NYTT-SYSTEM 
PROCEDURE beregnSek :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VAR teller AS DECIMAL.
    DEFINE VAR nevner AS DECIMAL.
    DEFINE VAR register AS DECIMAL.

    DO WITH FRAME NYTT-SYSTEM:
        IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE) > 0 
            AND DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE) <>  0
            AND DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE)  <>  0 THEN
           /* Kapasitet er ikke kjent */
           /* FORMEL: KAPASITET = (A * 0.86) / (B - C) /  3600  */
            DO:
                teller = DECIMAL(sek_effekt:SCREEN-VALUE)  * 0.86.
                nevner = DECIMAL(sek_temp_inn:SCREEN-VALUE)  - DECIMAL(sek_temp_ut:SCREEN-VALUE).
                ASSIGN NPSHSYST.sek_kapasitet = ABSOLUTE((teller  /  nevner)  /  3600).
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
           /* Formel: EFFEKT = (D*  3600) * (B - C) / 0.86 */
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
                DISPLAY  NPSHSYST.sek_temp_ut.
                ASSIGN  NPSHSYST.prim_temp_ut = NPSHSYST.sek_temp_ut.
                DISPLAY  NPSHSYST.prim_temp_ut.
            END.                      
    END.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI NYTT-SYSTEM  _DEFAULT-DISABLE
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
  HIDE FRAME NYTT-SYSTEM.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI NYTT-SYSTEM  _DEFAULT-ENABLE
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
      WITH FRAME NYTT-SYSTEM.
  IF AVAILABLE NPSHKOBL THEN 
    DISPLAY NPSHKOBL.betegnelse NPSHKOBL.anvendelse NPSHKOBL.sek_konst_var 
          NPSHKOBL.prim_konst_var NPSHKOBL.reguleringsventil 
          NPSHKOBL.ventil_type 
      WITH FRAME NYTT-SYSTEM.
  IF AVAILABLE NPSHSYST THEN 
    DISPLAY NPSHSYST.systembetegnelse NPSHSYST.koblings_alternativ 
          NPSHSYST.prim_effekt NPSHSYST.prim_temp_inn NPSHSYST.prim_temp_ut 
          NPSHSYST.prim_kapasitet NPSHSYST.sek_effekt NPSHSYST.sek_temp_inn 
          NPSHSYST.sek_temp_ut NPSHSYST.sek_kapasitet 
          NPSHSYST.beregnet_anvendelse NPSHSYST.ms_shuntventil_i_leveranse 
          NPSHSYST.shunt_dimmensjon 
      WITH FRAME NYTT-SYSTEM.
  ENABLE NPSHSYST.systembetegnelse NPSHSYST.koblings_alternativ 
         NPSHSYST.prim_effekt NPSHSYST.prim_temp_inn NPSHSYST.prim_temp_ut 
         NPSHSYST.prim_kapasitet NPSHSYST.sek_effekt NPSHSYST.sek_temp_inn 
         NPSHSYST.sek_temp_ut NPSHSYST.sek_kapasitet BUTTON-reset 
         NPSHSYST.beregnet_anvendelse NPSHSYST.type COMBO-BOX-VENTILTYPE 
         NPSHSYST.ms_shuntventil_i_leveranse Btn_OK Btn_Cancel Btn_Help RECT-19 
         RECT-21 RECT-29 SHUNTTEGNING 
      WITH FRAME NYTT-SYSTEM.
  {&OPEN-BROWSERS-IN-QUERY-NYTT-SYSTEM}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_ventiltype_combo NYTT-SYSTEM 
PROCEDURE fyll_ventiltype_combo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*    temp-string = "".                                                    */
/*    FOR EACH NPSHVENTILTYPE:                                             */
/*         IF temp-string = ""                                             */
/*        THEN temp-string = NPSHVENTILTYPE.ventiltype.                    */
/*        ELSE temp-string = temp-string + "," + NPSHVENTILTYPE.ventiltype.*/
/*    END.                                                                 */
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      NPSHSYST.type:RADIO-BUTTONS = replace(JBoxServerAPI:Instance:FieldList('NPSHGruppeType;NPSHGruppeTypeNavn;NPSHGruppeTypeNavn','where true'),'|',',')
      COMBO-BOX-VENTILTYPE:LIST-ITEM-pairs = replace(JBoxServerAPI:Instance:FieldList('NPSHVentiltype;Ventiltype;Ventiltype','where true'),'|',',')
    .
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyttSystem NYTT-SYSTEM 
PROCEDURE nyttSystem :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DO TRANSACTION:
  FIND LAST NPSHSYST WHERE NPSHSYST.anleggsnr = anleggsnrParam NO-LOCK NO-ERROR NO-WAIT.
  IF AVAILABLE(NPSHSYST) THEN
      /* Det er opprettet system for dette anlegget tidligere */
          syst# = NPSHSYST.systemnr  + 1.
  ELSE DO:
     IF LOCKED NPSHSYST THEN
     DO:
        /* Andre registrerer shuntsystem på dette anlegget nå */
         MESSAGE 'Andre registrerer shuntsystem på dette anlegget nå. Prøv igjen senere' VIEW-AS ALERT-BOX 
             TITLE 'STOPP'.
        RETURN.
     END.
    ELSE            
      syst# = 1.  
    END.
  CREATE NPSHSYST.
  NPSHSYST.anleggsnr  = anleggsnrParam.
  NPSHSYST.systemnr = syst#.
  systemnrParam = syst#.
  
  DO WITH FRAME NYTT-SYSTEM:
      DISPLAY NPSHSYST.koblings_alternativ.
      ENABLE  NPSHSYST.koblings_alternativ.
      APPLY "VALUE-CHANGED" TO NPSHSYST.koblings_alternativ.
      ENABLE BUTTON-reset.
      /* MS-Ventiltype skal initielt v‘re disablet. */
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
      WITH FRAME NYTT-SYSTEM.
END. /* TRANSACTION */      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onLeaveOf_type NYTT-SYSTEM 
PROCEDURE onLeaveOf_type :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    DEFINE VAR c_kapasitet  LIKE NPSHSYST.prim_kapasitet.
    DEFINE VAR c_grunnlag AS CHARACTER.

    ASSIGN
      FRAME NYTT-SYSTEM NPSHSYST.koblings_alternativ
      FRAME NYTT-SYSTEM  NPSHSYST.prim_kapasitet
      FRAME NYTT-SYSTEM  NPSHSYST.sek_kapasitet.
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
    END CASE.
    IF type:SCREEN-VALUE = 'MS' THEN APPLY 'VALUE-CHANGED' TO COMBO-BOX-VENTILTYPE.
    ASSIGN NPSHSYST.shunt_dimmensjon = dimm_verdi.
    DISPLAY NPSHSYST.shunt_dimmensjon WITH FRAME NYTT-SYSTEM.
    npshsyst.type:modified = true.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_hastighet NYTT-SYSTEM 
PROCEDURE prc_hastighet :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var v_prim as decimal format ">>>9,999999".
define var v_sek as decimal format ">>>9,999999".
define var pi as decimal initial 3.14.

find  NPIndrediam where dimm = NPSHSYST.shunt_dimmensjon no-lock no-error.
if available NPIndrediam then
    do:
        v_prim = NPSHSYST.prim_kapasitet * 1000 /  ((indre_diameter * indre_diameter * pi) / 4).
        v_sek = NPSHSYST.sek_kapasitet * 1000 /   ((indre_diameter * indre_diameter * pi) / 4).
        ASSIGN 
            NPSHSYST.prim_hastighet = v_prim
            NPSHSYST.sek_hastighet = v_sek.
    end.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset NYTT-SYSTEM 
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
      WITH FRAME NYTT-SYSTEM.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

