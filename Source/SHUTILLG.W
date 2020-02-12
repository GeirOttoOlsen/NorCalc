&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
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
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
def var appdata as char no-undo. /*setter den via JboxSession:AppTitle*/
appdata = JBoxSession:Instance:AppTitle.
def var EditModus as int no-undo.
def var current-rec as rowid no-undo.

def var hParent as handle no-undo.

DEFINE  VARIABLE anleggsnrParam LIKE NPSHANLG.anleggsnr.
DEFINE  VARIABLE  systemnrParam LIKE NPSHSYST.systemnr.

/* Local Variable Definitions ---                                       */
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHSYST

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame NPSHSYST.tillegg_pumpe_fabrikat ~
NPSHSYST.fabrikat NPSHSYST.tillegg_strupe NPSHSYST.tillegg_pumpetype ~
NPSHSYST.tillegg_pumpe_betegnelse NPSHSYST.tillegg_kuleventil_fabrikat_sek ~
NPSHSYST.tillegg_kuleventil_sek NPSHSYST.maks_pumpetrykk ~
NPSHSYST.minste_pumpetrykk NPSHSYST.tillegg_spjeldventil_fabrikat_se ~
NPSHSYST.tillegg_spjeldventil_sek NPSHSYST.tillegg_el_volt ~
NPSHSYST.sek_kapasitet NPSHSYST.tillegg_el_hz NPSHSYST.tillegg_kw ~
NPSHSYST.tillegg_kuleventil_fabrikat_prim NPSHSYST.tillegg_kuleventil_prim ~
NPSHSYST.tillegg_el_amp NPSHSYST.tillegg_spjeldventil_fabrikat_pr ~
NPSHSYST.tillegg_spjeldventil_prim NPSHSYST.tillegg_kapsling ~
NPSHSYST.tillegg_montasje NPSHSYST.tillegg_forstilling ~
NPSHSYST.tillegg_ekspansjonskar NPSHSYST.tillegg_ferdigkoblet_prim ~
NPSHSYST.tillegg_fm_brakett_overgang NPSHSYST.tillegg_ferdigkoblet_sek ~
NPSHSYST.tillegg_ms_brakett_overgang NPSHSYST.tillegg_frekv_styr_innkl 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame ~
NPSHSYST.tillegg_forstilling 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame NPSHSYST
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame NPSHSYST
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH NPSHSYST SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH NPSHSYST SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame NPSHSYST
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame NPSHSYST


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHSYST.tillegg_forstilling 
&Scoped-define ENABLED-TABLES NPSHSYST
&Scoped-define FIRST-ENABLED-TABLE NPSHSYST
&Scoped-Define ENABLED-OBJECTS RECT-6 Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPSHSYST.tillegg_pumpe_fabrikat ~
NPSHSYST.fabrikat NPSHSYST.tillegg_strupe NPSHSYST.tillegg_pumpetype ~
NPSHSYST.tillegg_pumpe_betegnelse NPSHSYST.tillegg_kuleventil_fabrikat_sek ~
NPSHSYST.tillegg_kuleventil_sek NPSHSYST.maks_pumpetrykk ~
NPSHSYST.minste_pumpetrykk NPSHSYST.tillegg_spjeldventil_fabrikat_se ~
NPSHSYST.tillegg_spjeldventil_sek NPSHSYST.tillegg_el_volt ~
NPSHSYST.sek_kapasitet NPSHSYST.tillegg_el_hz NPSHSYST.tillegg_kw ~
NPSHSYST.tillegg_kuleventil_fabrikat_prim NPSHSYST.tillegg_kuleventil_prim ~
NPSHSYST.tillegg_el_amp NPSHSYST.tillegg_spjeldventil_fabrikat_pr ~
NPSHSYST.tillegg_spjeldventil_prim NPSHSYST.tillegg_kapsling ~
NPSHSYST.tillegg_montasje NPSHSYST.tillegg_forstilling ~
NPSHSYST.tillegg_ekspansjonskar NPSHSYST.tillegg_ferdigkoblet_prim ~
NPSHSYST.tillegg_fm_brakett_overgang NPSHSYST.tillegg_ferdigkoblet_sek ~
NPSHSYST.tillegg_ms_brakett_overgang NPSHSYST.tillegg_frekv_styr_innkl 
&Scoped-define DISPLAYED-TABLES NPSHSYST
&Scoped-define FIRST-DISPLAYED-TABLE NPSHSYST


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 11.2 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 11.2 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 11.2 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 26.4 BY 3.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      NPSHSYST SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     NPSHSYST.tillegg_pumpe_fabrikat AT ROW 1.71 COL 81.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 4
          LIST-ITEMS "Ingen","Grundfos","Kolmeks (Flygt)","Salmson/Hamo","Wielo","ABS","Smedegaard" 
          DROP-DOWN-LIST
          SIZE 28.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.fabrikat AT ROW 2.48 COL 33.2 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "HM", "HM":U,
"TA", "TA":U
          SIZE 18 BY 1.38
     NPSHSYST.tillegg_strupe AT ROW 2.52 COL 30.4 RIGHT-ALIGNED
          LABEL "&Strupeventil"
          VIEW-AS TOGGLE-BOX
          SIZE 20.8 BY 1.05
     NPSHSYST.tillegg_pumpetype AT ROW 3 COL 83.2 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Tørrløper", "Tørrløper":U,
"Våtløper", "Våtløper":U
          SIZE 30.2 BY 1.24
     NPSHSYST.tillegg_pumpe_betegnelse AT ROW 4.24 COL 81.2 COLON-ALIGNED
          LABEL "Pumpebet."
          VIEW-AS FILL-IN NATIVE 
          SIZE 22.6 BY 1.24
          BGCOLOR 15 FONT 2
     NPSHSYST.tillegg_kuleventil_fabrikat_sek AT ROW 5.14 COL 30.8 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN NATIVE 
          SIZE 29.6 BY 1.24
          BGCOLOR 15 FONT 2
     NPSHSYST.tillegg_kuleventil_sek AT ROW 5.24 COL 10.4
          LABEL "&Kuleventil"
          VIEW-AS TOGGLE-BOX
          SIZE 18.2 BY 1.05
     NPSHSYST.maks_pumpetrykk AT ROW 5.62 COL 81.2 COLON-ALIGNED
          LABEL "Maks  trykk"
          VIEW-AS FILL-IN NATIVE 
          SIZE 11.4 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.minste_pumpetrykk AT ROW 6.43 COL 108 COLON-ALIGNED
          LABEL "Min."
          VIEW-AS FILL-IN 
          SIZE 9.6 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.tillegg_spjeldventil_fabrikat_se AT ROW 6.48 COL 30.8 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN NATIVE 
          SIZE 29.6 BY 1.24
          BGCOLOR 15 FONT 2
     NPSHSYST.tillegg_spjeldventil_sek AT ROW 6.57 COL 10.4
          LABEL "&Spjeldventil"
          VIEW-AS TOGGLE-BOX
          SIZE 20.8 BY 1.05
     NPSHSYST.tillegg_el_volt AT ROW 6.95 COL 81.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "1x230v","2x230v","3x230v","3x380","3x400v","3x440v","3x660v" 
          DROP-DOWN-LIST
          SIZE 14.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.sek_kapasitet AT ROW 7.67 COL 108 COLON-ALIGNED
          LABEL "Kap."
          VIEW-AS FILL-IN 
          SIZE 9.6 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.tillegg_el_hz AT ROW 8.19 COL 81.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "50hz","60hz" 
          DROP-DOWN-LIST
          SIZE 11.4 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.tillegg_kw AT ROW 9.43 COL 81.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9 BY 1.24
     NPSHSYST.tillegg_kuleventil_fabrikat_prim AT ROW 9.67 COL 30.8 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN NATIVE 
          SIZE 29.6 BY 1.24
          BGCOLOR 15 FONT 2
     NPSHSYST.tillegg_kuleventil_prim AT ROW 9.76 COL 10
          VIEW-AS TOGGLE-BOX
          SIZE 18.2 BY 1.05
     NPSHSYST.tillegg_el_amp AT ROW 10.81 COL 81.2 COLON-ALIGNED
          LABEL "Amp."
          VIEW-AS FILL-IN NATIVE 
          SIZE 17 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dialog-Frame
     NPSHSYST.tillegg_spjeldventil_fabrikat_pr AT ROW 11.05 COL 30.8 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN NATIVE 
          SIZE 29.6 BY 1.24
          BGCOLOR 15 FONT 2
     NPSHSYST.tillegg_spjeldventil_prim AT ROW 11.19 COL 10
          VIEW-AS TOGGLE-BOX
          SIZE 20.8 BY 1.05
     NPSHSYST.tillegg_kapsling AT ROW 12.14 COL 81.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Kapsling-Grå front","Kapsling-Rød front","Kapsling-Blå front","Kapsling-Grønn front","Kapsling-Rød/Blå front","Kapsling-Ingen" 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.tillegg_montasje AT ROW 13.43 COL 81.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Veggbrakett","Gulvstativ","Ingen" 
          DROP-DOWN-LIST
          SIZE 22.6 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.tillegg_forstilling AT ROW 15.1 COL 31.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          DROP-DOWN-LIST
          SIZE 47.8 BY 1
     NPSHSYST.tillegg_ekspansjonskar AT ROW 15.1 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 26 BY 1.05
     NPSHSYST.tillegg_ferdigkoblet_prim AT ROW 16.14 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 32 BY 1.05
     NPSHSYST.tillegg_fm_brakett_overgang AT ROW 16.43 COL 32.4 COLON-ALIGNED
          LABEL "Brakett/Overgang(FM)"
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","MB 23.5 Ø30/Ø10 SETT","MB 37.5 Ø30/Ø10 SETT","MB 56.0 Ø30/Ø10 SETT","OVERGANG LxG Ø8 SETT","OVERGANG TA Ø8 SETT" 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.tillegg_ferdigkoblet_sek AT ROW 17.19 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 27.4 BY 1.05
     NPSHSYST.tillegg_ms_brakett_overgang AT ROW 17.81 COL 32.4 COLON-ALIGNED
          LABEL "Brakett/Overgang(MS)"
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","MB 20.5 Ø35 M3/8 UNF","MB 25.0 Ø35 M3/8 UNF","MB 31.5 Ø35 M3/8 UNF","MB 37.5 Ø35 M3/8 UNF","MB 40.0 Ø35 M3/8 UNF","MB 20.5 Ø35 M6","MB 25.0 Ø35 M10","OVERGANG" 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.tillegg_frekv_styr_innkl AT ROW 18.19 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 24.4 BY .95
     Btn_OK AT ROW 19.76 COL 48.8
     Btn_Cancel AT ROW 19.76 COL 62.4
     Btn_Help AT ROW 19.76 COL 75.2
     "Sekundærside" VIEW-AS TEXT
          SIZE 53 BY .81 AT ROW 4.1 COL 10
          BGCOLOR 1 FGCOLOR 15 
     "Pumpetype:" VIEW-AS TEXT
          SIZE 16 BY .81 AT ROW 3.33 COL 67.8
     "l/s" VIEW-AS TEXT
          SIZE 4.2 BY .76 AT ROW 7.67 COL 120.8
     "kPa" VIEW-AS TEXT
          SIZE 5.6 BY .76 AT ROW 6.57 COL 120.6
     "Primærside" VIEW-AS TEXT
          SIZE 53 BY .81 AT ROW 8.67 COL 10
          BGCOLOR 1 FGCOLOR 15 
     RECT-6 AT ROW 6 COL 101.4
     SPACE(6.79) SKIP(11.95)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Shuntanlegg- Tilbehør"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR RADIO-SET NPSHSYST.fabrikat IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.maks_pumpetrykk IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.minste_pumpetrykk IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_kapasitet IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.tillegg_ekspansjonskar IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.tillegg_el_amp IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX NPSHSYST.tillegg_el_hz IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX NPSHSYST.tillegg_el_volt IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.tillegg_ferdigkoblet_prim IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.tillegg_ferdigkoblet_sek IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX NPSHSYST.tillegg_fm_brakett_overgang IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.tillegg_frekv_styr_innkl IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX NPSHSYST.tillegg_kapsling IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.tillegg_kuleventil_fabrikat_prim IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.tillegg_kuleventil_fabrikat_sek IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.tillegg_kuleventil_prim IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.tillegg_kuleventil_sek IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.tillegg_kw IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX NPSHSYST.tillegg_montasje IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX NPSHSYST.tillegg_ms_brakett_overgang IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR RADIO-SET NPSHSYST.tillegg_pumpetype IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.tillegg_pumpe_betegnelse IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR COMBO-BOX NPSHSYST.tillegg_pumpe_fabrikat IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.tillegg_spjeldventil_fabrikat_pr IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.tillegg_spjeldventil_fabrikat_se IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.tillegg_spjeldventil_prim IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.tillegg_spjeldventil_sek IN FRAME Dialog-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR TOGGLE-BOX NPSHSYST.tillegg_strupe IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-R EXP-LABEL                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "norcalc.NPSHSYST"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Shuntanlegg- Tilbehør */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    DO TRANSACTION ON STOP UNDO, LEAVE:
        DO WITH FRAME {&FRAME-NAME}:
        ASSIGN 
          NPSHSYST.tillegg_pumpe_fabrikat NPSHSYST.tillegg_strupe 
          NPSHSYST.fabrikat NPSHSYST.tillegg_pumpetype 
          NPSHSYST.tillegg_kuleventil_sek NPSHSYST.tillegg_pumpe_betegnelse 
          NPSHSYST.tillegg_kuleventil_fabrikat_sek 
          NPSHSYST.tillegg_spjeldventil_sek 
          NPSHSYST.tillegg_spjeldventil_fabrikat_se NPSHSYST.maks_pumpetrykk 
          NPSHSYST.tillegg_el_volt NPSHSYST.tillegg_el_hz NPSHSYST.tillegg_kw 
          NPSHSYST.tillegg_kuleventil_prim 
          NPSHSYST.tillegg_kuleventil_fabrikat_prim NPSHSYST.tillegg_el_amp 
          NPSHSYST.tillegg_spjeldventil_prim 
          NPSHSYST.tillegg_spjeldventil_fabrikat_pr NPSHSYST.tillegg_kapsling 
          NPSHSYST.tillegg_montasje NPSHSYST.tillegg_forstilling 
          NPSHSYST.tillegg_ekspansjonskar NPSHSYST.tillegg_ferdigkoblet_prim 
          NPSHSYST.tillegg_fm_brakett_overgang NPSHSYST.tillegg_ferdigkoblet_sek 
          NPSHSYST.tillegg_ms_brakett_overgang
          NPSHSYST.tillegg_frekv_styr_innkl.          
        END.
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.tillegg_forstilling
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_forstilling Dialog-Frame
ON ANY-PRINTABLE OF NPSHSYST.tillegg_forstilling IN FRAME Dialog-Frame /* Forstillingsorgan */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_forstilling Dialog-Frame
ON CURSOR-DOWN OF NPSHSYST.tillegg_forstilling IN FRAME Dialog-Frame /* Forstillingsorgan */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_forstilling Dialog-Frame
ON CURSOR-UP OF NPSHSYST.tillegg_forstilling IN FRAME Dialog-Frame /* Forstillingsorgan */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.tillegg_kuleventil_fabrikat_sek
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_kuleventil_fabrikat_sek Dialog-Frame
ON LEAVE OF NPSHSYST.tillegg_kuleventil_fabrikat_sek IN FRAME Dialog-Frame /* tillegg_kuleventil_fabrikat_sek */
DO:
     /* Primærside er slave og skal følge sek side (untagen når kobling = 5,7)    */
   IF NPSHSYST.koblings_alternativ <> '5' AND NPSHSYST.koblings_alternativ <> '7 ' THEN
        DO:
           NPSHSYST.tillegg_kuleventil_fabrikat_prim =   SELF:SCREEN-VALUE.
           DISPLAY NPSHSYST.tillegg_kuleventil_fabrikat_prim WITH FRAME {&FRAME-NAME}.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.tillegg_kuleventil_prim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_kuleventil_prim Dialog-Frame
ON VALUE-CHANGED OF NPSHSYST.tillegg_kuleventil_prim IN FRAME Dialog-Frame /* Kuleventil */
DO:
    IF INPUT NPSHSYST.tillegg_kuleventil_prim THEN
        DO:
           DISPLAY NPSHSYST.tillegg_kuleventil_fabrikat_pr WITH FRAME {&FRAME-NAME}.
           ENABLE NPSHSYST.tillegg_kuleventil_fabrikat_pr WITH FRAME {&FRAME-NAME}.
        END.
    ELSE
       HIDE NPSHSYST.tillegg_kuleventil_fabrikat_pri.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.tillegg_kuleventil_sek
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_kuleventil_sek Dialog-Frame
ON VALUE-CHANGED OF NPSHSYST.tillegg_kuleventil_sek IN FRAME Dialog-Frame /* Kuleventil */
DO:
    IF INPUT NPSHSYST.tillegg_kuleventil_sek THEN  /* Ventil slås på */
    DO:        
        /* Dette er avhenging av kobling */
        CASE NPSHSYST.koblings_alternativ:
            WHEN '5' OR  WHEN '7'  THEN       
                DO:
                END.
            OTHERWISE
              DO:
                 DISPLAY  NPSHSYST.tillegg_kuleventil_fabrikat_prim WITH FRAME {&FRAME-NAME}.
                 NPSHSYST.tillegg_kuleventil_prim = TRUE.
                 DISPLAY NPSHSYST.tillegg_kuleventil_prim WITH FRAME {&FRAME-NAME}.
              END.
        END.
        /* Dette skal gjøres uansett */
        ENABLE NPSHSYST.tillegg_kuleventil_fabrikat_sek WITH FRAME {&FRAME-NAME}.
        DISPLAY NPSHSYST.tillegg_kuleventil_fabrikat_sek WITH FRAME {&FRAME-NAME}.
    END.
    ELSE  /* Ventil slås av */
    DO:
        /* Dette er avhenging av kobling */
        CASE NPSHSYST.koblings_alternativ:
            WHEN '5' OR  WHEN '7 ' THEN       
                DO:
                END.
            OTHERWISE
              DO:
                   HIDE NPSHSYST.tillegg_kuleventil_fabrikat_prim.
                   NPSHSYST.tillegg_kuleventil_fabrikat_prim = "".
                  NPSHSYST.tillegg_kuleventil_prim = FALSE.    
                   DISPLAY NPSHSYST.tillegg_kuleventil_prim  WITH FRAME {&FRAME-NAME}.
              END.
          END.
        /* Dette skal gjøres uansett */
       NPSHSYST.tillegg_kuleventil_fabrikat_sek = "".
       HIDE NPSHSYST.tillegg_kuleventil_fabrikat_sek.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.tillegg_pumpe_fabrikat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_pumpe_fabrikat Dialog-Frame
ON VALUE-CHANGED OF NPSHSYST.tillegg_pumpe_fabrikat IN FRAME Dialog-Frame /* Pumpe fabrikat */
DO:
      CASE SELF:SCREEN-VALUE:
           WHEN 'Kolmeks (Flygt)' THEN  DO:
                NPSHSYST.tillegg_pumpetype = 'Tørrløper'.                 
                DISPLAY NPSHSYST.tillegg_pumpetype WITH FRAME {&FRAME-NAME}.
           END.          
      OTHERWISE  DO:
          NPSHSYST.tillegg_pumpetype = 'Våtløper'.
          DISPLAY NPSHSYST.tillegg_pumpetype WITH FRAME {&FRAME-NAME}.
      END.               
  END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.tillegg_spjeldventil_fabrikat_se
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_spjeldventil_fabrikat_se Dialog-Frame
ON LEAVE OF NPSHSYST.tillegg_spjeldventil_fabrikat_se IN FRAME Dialog-Frame /* tillegg_spjeldventil_fabrikat_se */
DO:
   /* Prim‘rside er slave og skal følge sek side (untagen når kobling = 5,7)    */
   IF NPSHSYST.koblings_alternativ <> '5' AND NPSHSYST.koblings_alternativ <> '7 ' THEN
        DO:
          NPSHSYST.tillegg_spjeldventil_fabrikat_pr = NPSHSYST.tillegg_spjeldventil_fabrikat_se:SCREEN-VALUE.
          DISPLAY NPSHSYST.tillegg_spjeldventil_fabrikat_pr WITH FRAME {&FRAME-NAME}.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.tillegg_spjeldventil_prim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_spjeldventil_prim Dialog-Frame
ON VALUE-CHANGED OF NPSHSYST.tillegg_spjeldventil_prim IN FRAME Dialog-Frame /* Spjeldventil */
DO:
    IF INPUT NPSHSYST.tillegg_spjeldventil_prim  THEN
        DO:
           DISPLAY NPSHSYST.tillegg_spjeldventil_fabrikat_pr WITH FRAME {&FRAME-NAME}.
           ENABLE NPSHSYST.tillegg_spjeldventil_fabrikat_pr WITH FRAME {&FRAME-NAME}.
        END.
    ELSE
       HIDE NPSHSYST.tillegg_spjeldventil_fabrikat_pr.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.tillegg_spjeldventil_sek
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_spjeldventil_sek Dialog-Frame
ON VALUE-CHANGED OF NPSHSYST.tillegg_spjeldventil_sek IN FRAME Dialog-Frame /* Spjeldventil */
DO:
    IF INPUT NPSHSYST.tillegg_spjeldventil_sek THEN  /* Ventil slås på */
    DO:        
        /* Dette er avhenging av kobling */
        CASE NPSHSYST.koblings_alternativ:
            WHEN '5' OR  WHEN '7'  THEN       
                DO:
                END.
            OTHERWISE
              DO:
                 DISPLAY  NPSHSYST.tillegg_spjeldventil_fabrikat_pr WITH FRAME {&FRAME-NAME}.
                 NPSHSYST.tillegg_spjeldventil_prim = TRUE.
                 DISPLAY NPSHSYST.tillegg_spjeldventil_pr WITH FRAME {&FRAME-NAME}.
              END.
        END.
        /* Dette skal gjøres uansett */
        ENABLE NPSHSYST.tillegg_spjeldventil_fabrikat_se WITH FRAME {&FRAME-NAME}.
        DISPLAY NPSHSYST.tillegg_spjeldventil_fabrikat_se WITH FRAME {&FRAME-NAME}.
    END.
    ELSE  /* Ventil slås av */
    DO:
        /* Dette er avhenging av kobling */
        CASE NPSHSYST.koblings_alternativ:
            WHEN '5' OR  WHEN '7 ' THEN       
                DO:
                END.
            OTHERWISE
              DO:
                   HIDE NPSHSYST.tillegg_spjeldventil_fabrikat_pr.
                   NPSHSYST.tillegg_spjeldventil_fabrikat_pr = "".
                  NPSHSYST.tillegg_spjeldventil_pr = FALSE.    
                   DISPLAY NPSHSYST.tillegg_spjeldventil_prim  WITH FRAME {&FRAME-NAME}.
              END.
          END.
        /* Dette skal gjøres uansett */
       NPSHSYST.tillegg_spjeldventil_fabrikat_se = "".
       HIDE NPSHSYST.tillegg_spjeldventil_fabrikat_se.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.tillegg_strupe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.tillegg_strupe Dialog-Frame
ON VALUE-CHANGED OF NPSHSYST.tillegg_strupe IN FRAME Dialog-Frame /* Strupeventil */
DO:
    IF INPUT NPSHSYST.tillegg_strupe THEN
        VIEW NPSHSYST.fabrikat.
    ELSE
       HIDE norcalc.NPSHSYST.fabrikat.
       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  hParent = source-procedure.
  current-rec = dynamic-function('getCurrentRec' in hParent).
  EditModus   = dynamic-function('getEditModus' in hParent).
   RUN enable_UI.
   RUN fyll_combo.
   RUN start_UI.
 WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-Dialog-Frame}
  GET FIRST Dialog-Frame.
  IF AVAILABLE NPSHSYST THEN 
    DISPLAY NPSHSYST.tillegg_pumpe_fabrikat NPSHSYST.fabrikat 
          NPSHSYST.tillegg_strupe NPSHSYST.tillegg_pumpetype 
          NPSHSYST.tillegg_pumpe_betegnelse 
          NPSHSYST.tillegg_kuleventil_fabrikat_sek 
          NPSHSYST.tillegg_kuleventil_sek NPSHSYST.maks_pumpetrykk 
          NPSHSYST.minste_pumpetrykk NPSHSYST.tillegg_spjeldventil_fabrikat_se 
          NPSHSYST.tillegg_spjeldventil_sek NPSHSYST.tillegg_el_volt 
          NPSHSYST.sek_kapasitet NPSHSYST.tillegg_el_hz NPSHSYST.tillegg_kw 
          NPSHSYST.tillegg_kuleventil_fabrikat_prim 
          NPSHSYST.tillegg_kuleventil_prim NPSHSYST.tillegg_el_amp 
          NPSHSYST.tillegg_spjeldventil_fabrikat_pr 
          NPSHSYST.tillegg_spjeldventil_prim NPSHSYST.tillegg_kapsling 
          NPSHSYST.tillegg_montasje NPSHSYST.tillegg_forstilling 
          NPSHSYST.tillegg_ekspansjonskar NPSHSYST.tillegg_ferdigkoblet_prim 
          NPSHSYST.tillegg_fm_brakett_overgang NPSHSYST.tillegg_ferdigkoblet_sek 
          NPSHSYST.tillegg_ms_brakett_overgang NPSHSYST.tillegg_frekv_styr_innkl 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-6 NPSHSYST.tillegg_forstilling Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_combo Dialog-Frame 
PROCEDURE fyll_combo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    temp-string = "".
    FOR EACH NPSHFORSTILLING where shForstillingAktiv by NPSHFORSTILLING.forstillingsorgan:
         IF temp-string = ""
        THEN temp-string = NPSHFORSTILLING.forstillingsorgan.
        ELSE temp-string = temp-string + "," + NPSHFORSTILLING.forstillingsorgan.
    END.
    /* Legg til en blank post */
    temp-string = temp-string + "," + " ".

    ASSIGN NPSHSYST.tillegg_forstilling:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE start_UI Dialog-Frame 
PROCEDURE start_UI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  FIND NPSHSYST WHERE NPSHSYST.anleggsnr = anleggsnrParam                   */
/*      AND NPSHSYST.systemnr = systemnrParam EXCLUSIVE-LOCK NO-WAIT NO-ERROR.*/
  find first npshsyst where rowid(npshsyst) = current-rec exclusive-lock no-error.
  IF AVAILABLE NPSHSYST THEN DO:
      /* ********* DISPLAY OG DISABLE - DEL ************/
     IF NPSHSYST.tillegg_strupe THEN  DISPLAY  NPSHSYST.tillegg_strupe NPSHSYST.fabrikat  
        WITH FRAME {&FRAME-NAME}.
    ELSE  DISABLE NPSHSYST.fabrikat.
     /* Uansett koblingsalternativ  - vis sekundærside og primærside */    
    DISPLAY  NPSHSYST.tillegg_kuleventil_sek NPSHSYST.tillegg_spjeldventil_sek 
                         NPSHSYST.tillegg_kuleventil_prim NPSHSYST.tillegg_spjeldventil_prim
             WITH FRAME {&FRAME-NAME}.
    IF NPSHSYST.tillegg_stengeventil_type_sek = 'Kule' THEN DO:
        IF NPSHSYST.tillegg_kuleventil_sek THEN DO:
            DISPLAY   NPSHSYST.tillegg_kuleventil_fabrikat_sek 
                                  NPSHSYST.tillegg_kuleventil_fabrikat_prim   WITH FRAME {&FRAME-NAME}.
            HIDE  NPSHSYST.tillegg_spjeldventil_fabrikat_se  NPSHSYST.tillegg_spjeldventil_fabrikat_pr.
        END.
        ELSE 
            HIDE NPSHSYST.tillegg_kuleventil_fabrikat_sek NPSHSYST.tillegg_kuleventil_fabrikat_prim   
                        NPSHSYST.tillegg_spjeldventil_fabrikat_se  NPSHSYST.tillegg_spjeldventil_fabrikat_pr.
    END.
   ELSE DO:
        /* Vis Spjeld - felt  på skundærside og prim side - selv om prim side er slave*/
        IF NPSHSYST.tillegg_spjeldventil_sek THEN DO:
             DISPLAY   NPSHSYST.tillegg_spjeldventil_fabrikat_se 
                                   NPSHSYST.tillegg_spjeldventil_fabrikat_pr WITH FRAME {&FRAME-NAME}.
             HIDE NPSHSYST.tillegg_kuleventil_fabrikat_sek  NPSHSYST.tillegg_kuleventil_fabrikat_prim.
        END.
        ELSE
             HIDE   NPSHSYST.tillegg_spjeldventil_fabrikat_se NPSHSYST.tillegg_spjeldventil_fabrikat_pr 
                           NPSHSYST.tillegg_kuleventil_fabrikat_sek  NPSHSYST.tillegg_kuleventil_fabrikat_prim.
  END.

 DISPLAY  NPSHSYST.tillegg_forstilling NPSHSYST.tillegg_pumpe_fabrikat  
                            NPSHSYST.tillegg_pumpetype NPSHSYST.tillegg_pumpe_betegnelse  
                            NPSHSYST.maks_pumpetrykk NPSHSYST.tillegg_el_volt norcalc.NPSHSYST.tillegg_el_hz 
                            NPSHSYST.tillegg_kw 
                            NPSHSYST.tillegg_el_amp NPSHSYST.tillegg_kapsling 
                            NPSHSYST.tillegg_montasje NPSHSYST.tillegg_ekspansjonskar                                
                            NPSHSYST.tillegg_ferdigkoblet_prim NPSHSYST.tillegg_ferdigkoblet_sek 
                            NPSHSYST.minste_pumpetrykk  NPSHSYST.sek_kapasitet NPSHSYST.tillegg_frekv_styr_innkl
                    WITH FRAME {&FRAME-NAME}.
        /* Hvis kobling = 6, vis dette */
        IF NPSHSYST.koblings_alternativ = '6' THEN
            DISPLAY  NPSHSYST.tillegg_ekspansjonskar  WITH FRAME {&FRAME-NAME}.
        ELSE
            HIDE NPSHSYST.tillegg_ekspansjonskar.

     /**************** ENABLE - DEL , Kun dersom anlegg ikke er sperret for endringer *********************/
    /* Ingen endringer kan gjøres dersom det er gitt tilbud */
    IF editModus = 0 THEN
            DISABLE ALL EXCEPT Btn_Cancel  WITH FRAME {&FRAME-NAME}.
   ELSE  DO:
       ENABLE NPSHSYST.tillegg_strupe  WITH FRAME {&FRAME-NAME}.    
       IF NPSHSYST.tillegg_stengeventil_type_sek = 'Kule' THEN 
       DO:
           /* Enable Kulefelt  */
            ENABLE  NPSHSYST.tillegg_kuleventil_sek  WITH FRAME {&FRAME-NAME}.
           IF NPSHSYST.tillegg_kuleventil_sek THEN 
                 ENABLE   NPSHSYST.tillegg_kuleventil_fabrikat_sek  WITH FRAME {&FRAME-NAME}.
       END.
       ELSE 
       DO:
          /* Enable Spjeld - felt  */
            ENABLE NPSHSYST.tillegg_spjeldventil_sek  WITH FRAME {&FRAME-NAME}.
             IF NPSHSYST.tillegg_spjeldventil_sek THEN
                    ENABLE   NPSHSYST.tillegg_spjeldventil_fabrikat_se WITH FRAME {&FRAME-NAME}.
        END.

         /* Koblingsalternativ er 5  eller 7  primær og sekundærside er uavhengige */
          IF NPSHSYST.koblings_alternativ = '5' OR NPSHSYST.koblings_alternativ = '7 ' THEN  
          DO:
              IF NPSHSYST.tillegg_stengeventil_type_sek = 'Kule' THEN
                  /* Enable Kulefelt  -sekundær */
                 DO:
                    ENABLE   NPSHSYST.tillegg_kuleventil_sek  WITH FRAME {&FRAME-NAME}.
                    IF NPSHSYST.tillegg_kuleventil_sek THEN 
                    DO:
                        DISPLAY  NPSHSYST.tillegg_kuleventil_fabrikat_sek  WITH FRAME {&FRAME-NAME}.
                        ENABLE   NPSHSYST.tillegg_kuleventil_fabrikat_sek  WITH FRAME {&FRAME-NAME}.
                    END.
                 END.
             ELSE
              /* Enable Spjeld - felt  -sekundær */
             DO:
                 ENABLE   NPSHSYST.tillegg_spjeldventil_sek  WITH FRAME {&FRAME-NAME}.
                 IF NPSHSYST.tillegg_kuleventil_sek THEN 
                 DO:
                        DISPLAY  NPSHSYST.tillegg_spjeldventil_fabrikat_se  WITH FRAME {&FRAME-NAME}.
                        ENABLE   NPSHSYST.tillegg_spjeldventil_fabrikat_se WITH FRAME {&FRAME-NAME}.
                END.
           END.
            IF NPSHSYST.tillegg_stengeventil_type_prim = 'Kule' THEN
                 /* Enable Kulefelt  - primær */
                 DO:
                    ENABLE   NPSHSYST.tillegg_kuleventil_prim  WITH FRAME {&FRAME-NAME}.
                    IF NPSHSYST.tillegg_kuleventil_prim THEN 
                    DO:
                             DISPLAY  NPSHSYST.tillegg_kuleventil_fabrikat_prim  WITH FRAME {&FRAME-NAME}.
                             ENABLE   NPSHSYST.tillegg_kuleventil_fabrikat_prim  WITH FRAME {&FRAME-NAME}.
                     END.
                END.
           ELSE
                /* Enable Spjeld - felt  - primær */
                DO:
                    ENABLE   NPSHSYST.tillegg_spjeldventil_prim  WITH FRAME {&FRAME-NAME}.
                    IF NPSHSYST.tillegg_kuleventil_prim THEN 
                    DO:
                        DISPLAY  NPSHSYST.tillegg_spjeldventil_fabrikat_pr  WITH FRAME {&FRAME-NAME}.
                        ENABLE   NPSHSYST.tillegg_spjeldventil_fabrikat_pr WITH FRAME {&FRAME-NAME}.
                    END.
                END.
         END.
          ENABLE  NPSHSYST.tillegg_forstilling WITH FRAME {&FRAME-NAME}.
         /* Braketter/Overganger */
           IF NPSHSYST.type = 'FM' THEN  DO:
               DISABLE NPSHSYST.tillegg_ms_brakett_overgang  WITH FRAME {&FRAME-NAME}.
               ENABLE NPSHSYST.tillegg_fm_brakett_overgang  WITH FRAME {&FRAME-NAME}.
               DISPLAY NPSHSYST.tillegg_fm_brakett_overgang  WITH FRAME {&FRAME-NAME}.
           END.
           ELSE DO:
               DISABLE NPSHSYST.tillegg_fm_brakett_overgang  WITH FRAME {&FRAME-NAME}.
               ENABLE NPSHSYST.tillegg_ms_brakett_overgang  WITH FRAME {&FRAME-NAME}.
               DISPLAY NPSHSYST.tillegg_ms_brakett_overgang  WITH FRAME {&FRAME-NAME}.
           END.
           ENABLE   NPSHSYST.tillegg_pumpe_fabrikat  
                     NPSHSYST.tillegg_pumpetype NPSHSYST.tillegg_pumpe_betegnelse  
                     NPSHSYST.maks_pumpetrykk NPSHSYST.tillegg_el_volt 
                     NPSHSYST.tillegg_el_hz NPSHSYST.tillegg_kw NPSHSYST.tillegg_el_amp NPSHSYST.tillegg_kapsling 
                     NPSHSYST.tillegg_montasje 
          WITH FRAME {&FRAME-NAME}.
        /* Hvis kobling = 6 */
        IF NPSHSYST.koblings_alternativ = '6' THEN
             ENABLE  NPSHSYST.tillegg_ekspansjonskar  WITH FRAME {&FRAME-NAME}.

            ENABLE                    
                     NPSHSYST.tillegg_ferdigkoblet_prim NPSHSYST.tillegg_ferdigkoblet_sek 
                     NPSHSYST.tillegg_frekv_styr_innkl  WITH FRAME {&FRAME-NAME}.
             
       ENABLE  Btn_OK Btn_Cancel Btn_Help  WITH FRAME {&FRAME-NAME}.
     END.
END.

 ELSE DO:
            MESSAGE 'Tilbehørstabellen for dette systemet er opptatt. Prøv senere.' 
                VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN.
  END.
  VIEW FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

