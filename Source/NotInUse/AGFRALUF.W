&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dilaog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dilaog-Frame 
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
DEFINE INPUT PARAMETER appdata AS CHARACTER.
DEFINE INPUT PARAMETER systemNavnParam AS CHAR.
DEFINE INPUT PARAMETER nyRecord AS LOGICAL.
DEFINE SHARED VARIABLE anleggsnrParam LIKE NPAGANLG.anleggsnr.
DEFINE SHARED VARIABLE systemnrParam LIKE NPAGFRALUFT.systemnr.
DEFINE SHARED VARIABLE delnrParam LIKE NPAGFRALUFT.del_nr.
DEFINE VAR fralufts_nr# LIKE NPAGFRALUFT.del_nr.
DEFINE VAR p_batteri_hastighet AS DECIMAL.
DEFINE VAR p_kabinett_hastighet AS DECIMAL.
DEFINE VAR p_type LIKE NPAGTYPE.aggregattype.


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE Current-Widget AS WIDGET-HANDLE.
DEFINE VAR pointer AS LOGICAL. 
DEFINE VAR i AS INTEGER.
DEFINE VAR fraluftsRec AS ROWID.
DEFINE VAR temp-string AS CHAR.
DEFINE VAR n_reduksjon AS DECIMAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dilaog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPAGFRALUFT

/* Definitions for DIALOG-BOX Dilaog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dilaog-Frame NPAGFRALUFT.nom_kapasitet ~
NPAGFRALUFT.nom_temp NPAGFRALUFT.rf NPAGFRALUFT.spes_vekt ~
NPAGFRALUFT.aktuell_kapasitet NPAGFRALUFT.vann_batteri ~
NPAGFRALUFT.el_batteri NPAGFRALUFT.batteri_stand_utb NPAGFRALUFT.rortype ~
NPAGFRALUFT.fronthast_kabinett NPAGFRALUFT.aggregattype ~
NPAGFRALUFT.fronthast_batt_flate NPAGFRALUFT.kabinett_delinger ~
NPAGFRALUFT.isolasjon NPAGFRALUFT.kabinettype NPAGFRALUFT.inspeksjon ~
NPAGFRALUFT.utv_bredde NPAGFRALUFT.utv_hoyde NPAGFRALUFT.utv_lengde ~
NPAGFRALUFT.viftetype NPAGFRALUFT.skovle_type NPAGFRALUFT.vifte_posisjon ~
NPAGFRALUFT.motor_plassering NPAGFRALUFT.fabrikat ~
NPAGFRALUFT.type_betegnelse NPAGFRALUFT.kraftoverforing ~
NPAGFRALUFT.omdreininger NPAGFRALUFT.pt NPAGFRALUFT.virknings_grad ~
NPAGFRALUFT.kraftbehov NPAGFRALUFT.fundament_type ~
NPAGFRALUFT.fundament_maal NPAGFRALUFT.materialkvalitet ~
NPAGFRALUFT.modell_variant 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dilaog-Frame ~
NPAGFRALUFT.nom_kapasitet NPAGFRALUFT.nom_temp NPAGFRALUFT.rf ~
NPAGFRALUFT.spes_vekt NPAGFRALUFT.aktuell_kapasitet ~
NPAGFRALUFT.vann_batteri NPAGFRALUFT.el_batteri ~
NPAGFRALUFT.batteri_stand_utb NPAGFRALUFT.rortype ~
NPAGFRALUFT.fronthast_kabinett NPAGFRALUFT.aggregattype ~
NPAGFRALUFT.fronthast_batt_flate NPAGFRALUFT.kabinett_delinger ~
NPAGFRALUFT.isolasjon NPAGFRALUFT.kabinettype NPAGFRALUFT.inspeksjon ~
NPAGFRALUFT.utv_bredde NPAGFRALUFT.utv_hoyde NPAGFRALUFT.utv_lengde ~
NPAGFRALUFT.viftetype NPAGFRALUFT.skovle_type NPAGFRALUFT.vifte_posisjon ~
NPAGFRALUFT.motor_plassering NPAGFRALUFT.fabrikat ~
NPAGFRALUFT.type_betegnelse NPAGFRALUFT.kraftoverforing ~
NPAGFRALUFT.omdreininger NPAGFRALUFT.pt NPAGFRALUFT.virknings_grad ~
NPAGFRALUFT.kraftbehov NPAGFRALUFT.fundament_type ~
NPAGFRALUFT.fundament_maal NPAGFRALUFT.materialkvalitet ~
NPAGFRALUFT.modell_variant 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dilaog-Frame NPAGFRALUFT
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dilaog-Frame NPAGFRALUFT

&Scoped-define FIELD-PAIRS-IN-QUERY-Dilaog-Frame~
 ~{&FP1}nom_kapasitet ~{&FP2}nom_kapasitet ~{&FP3}~
 ~{&FP1}nom_temp ~{&FP2}nom_temp ~{&FP3}~
 ~{&FP1}rf ~{&FP2}rf ~{&FP3}~
 ~{&FP1}spes_vekt ~{&FP2}spes_vekt ~{&FP3}~
 ~{&FP1}aktuell_kapasitet ~{&FP2}aktuell_kapasitet ~{&FP3}~
 ~{&FP1}fronthast_kabinett ~{&FP2}fronthast_kabinett ~{&FP3}~
 ~{&FP1}aggregattype ~{&FP2}aggregattype ~{&FP3}~
 ~{&FP1}fronthast_batt_flate ~{&FP2}fronthast_batt_flate ~{&FP3}~
 ~{&FP1}utv_bredde ~{&FP2}utv_bredde ~{&FP3}~
 ~{&FP1}utv_hoyde ~{&FP2}utv_hoyde ~{&FP3}~
 ~{&FP1}utv_lengde ~{&FP2}utv_lengde ~{&FP3}~
 ~{&FP1}type_betegnelse ~{&FP2}type_betegnelse ~{&FP3}~
 ~{&FP1}omdreininger ~{&FP2}omdreininger ~{&FP3}~
 ~{&FP1}pt ~{&FP2}pt ~{&FP3}~
 ~{&FP1}virknings_grad ~{&FP2}virknings_grad ~{&FP3}~
 ~{&FP1}kraftbehov ~{&FP2}kraftbehov ~{&FP3}~
 ~{&FP1}modell_variant ~{&FP2}modell_variant ~{&FP3}
&Scoped-define OPEN-QUERY-Dilaog-Frame OPEN QUERY Dilaog-Frame FOR EACH NPAGFRALUFT SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dilaog-Frame NPAGFRALUFT
&Scoped-define FIRST-TABLE-IN-QUERY-Dilaog-Frame NPAGFRALUFT


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPAGFRALUFT.nom_kapasitet ~
NPAGFRALUFT.nom_temp NPAGFRALUFT.rf NPAGFRALUFT.spes_vekt ~
NPAGFRALUFT.aktuell_kapasitet NPAGFRALUFT.vann_batteri ~
NPAGFRALUFT.el_batteri NPAGFRALUFT.batteri_stand_utb NPAGFRALUFT.rortype ~
NPAGFRALUFT.fronthast_kabinett NPAGFRALUFT.aggregattype ~
NPAGFRALUFT.fronthast_batt_flate NPAGFRALUFT.kabinett_delinger ~
NPAGFRALUFT.isolasjon NPAGFRALUFT.kabinettype NPAGFRALUFT.inspeksjon ~
NPAGFRALUFT.utv_bredde NPAGFRALUFT.utv_hoyde NPAGFRALUFT.utv_lengde ~
NPAGFRALUFT.viftetype NPAGFRALUFT.skovle_type NPAGFRALUFT.vifte_posisjon ~
NPAGFRALUFT.motor_plassering NPAGFRALUFT.fabrikat ~
NPAGFRALUFT.type_betegnelse NPAGFRALUFT.kraftoverforing ~
NPAGFRALUFT.omdreininger NPAGFRALUFT.pt NPAGFRALUFT.virknings_grad ~
NPAGFRALUFT.kraftbehov NPAGFRALUFT.fundament_type ~
NPAGFRALUFT.fundament_maal NPAGFRALUFT.materialkvalitet ~
NPAGFRALUFT.modell_variant 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nom_kapasitet ~{&FP2}nom_kapasitet ~{&FP3}~
 ~{&FP1}nom_temp ~{&FP2}nom_temp ~{&FP3}~
 ~{&FP1}rf ~{&FP2}rf ~{&FP3}~
 ~{&FP1}spes_vekt ~{&FP2}spes_vekt ~{&FP3}~
 ~{&FP1}aktuell_kapasitet ~{&FP2}aktuell_kapasitet ~{&FP3}~
 ~{&FP1}fronthast_kabinett ~{&FP2}fronthast_kabinett ~{&FP3}~
 ~{&FP1}aggregattype ~{&FP2}aggregattype ~{&FP3}~
 ~{&FP1}fronthast_batt_flate ~{&FP2}fronthast_batt_flate ~{&FP3}~
 ~{&FP1}utv_bredde ~{&FP2}utv_bredde ~{&FP3}~
 ~{&FP1}utv_hoyde ~{&FP2}utv_hoyde ~{&FP3}~
 ~{&FP1}utv_lengde ~{&FP2}utv_lengde ~{&FP3}~
 ~{&FP1}type_betegnelse ~{&FP2}type_betegnelse ~{&FP3}~
 ~{&FP1}omdreininger ~{&FP2}omdreininger ~{&FP3}~
 ~{&FP1}pt ~{&FP2}pt ~{&FP3}~
 ~{&FP1}virknings_grad ~{&FP2}virknings_grad ~{&FP3}~
 ~{&FP1}kraftbehov ~{&FP2}kraftbehov ~{&FP3}~
 ~{&FP1}modell_variant ~{&FP2}modell_variant ~{&FP3}
&Scoped-define ENABLED-TABLES NPAGFRALUFT
&Scoped-define FIRST-ENABLED-TABLE NPAGFRALUFT
&Scoped-Define ENABLED-OBJECTS RECT-1 Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPAGFRALUFT.nom_kapasitet ~
NPAGFRALUFT.nom_temp NPAGFRALUFT.rf NPAGFRALUFT.spes_vekt ~
NPAGFRALUFT.aktuell_kapasitet NPAGFRALUFT.vann_batteri ~
NPAGFRALUFT.el_batteri NPAGFRALUFT.batteri_stand_utb NPAGFRALUFT.rortype ~
NPAGFRALUFT.fronthast_kabinett NPAGFRALUFT.aggregattype ~
NPAGFRALUFT.fronthast_batt_flate NPAGFRALUFT.kabinett_delinger ~
NPAGFRALUFT.isolasjon NPAGFRALUFT.kabinettype NPAGFRALUFT.inspeksjon ~
NPAGFRALUFT.utv_bredde NPAGFRALUFT.utv_hoyde NPAGFRALUFT.utv_lengde ~
NPAGFRALUFT.viftetype NPAGFRALUFT.skovle_type NPAGFRALUFT.vifte_posisjon ~
NPAGFRALUFT.motor_plassering NPAGFRALUFT.fabrikat ~
NPAGFRALUFT.type_betegnelse NPAGFRALUFT.kraftoverforing ~
NPAGFRALUFT.omdreininger NPAGFRALUFT.pt NPAGFRALUFT.virknings_grad ~
NPAGFRALUFT.kraftbehov NPAGFRALUFT.fundament_type ~
NPAGFRALUFT.fundament_maal NPAGFRALUFT.materialkvalitet ~
NPAGFRALUFT.modell_variant 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 11.6 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 123.8 BY 19.19.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dilaog-Frame FOR 
      NPAGFRALUFT SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dilaog-Frame
     NPAGFRALUFT.nom_kapasitet AT ROW 1.95 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.4 BY 1
     NPAGFRALUFT.nom_temp AT ROW 1.95 COL 53.2 COLON-ALIGNED
          LABEL "v/Temp"
          VIEW-AS FILL-IN 
          SIZE 7.4 BY 1
     NPAGFRALUFT.rf AT ROW 1.95 COL 67 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 7.4 BY 1
     NPAGFRALUFT.spes_vekt AT ROW 1.95 COL 98.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.4 BY 1
     NPAGFRALUFT.aktuell_kapasitet AT ROW 3.24 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGFRALUFT.vann_batteri AT ROW 3.48 COL 49.8
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .76
     NPAGFRALUFT.el_batteri AT ROW 3.48 COL 69.2
          VIEW-AS TOGGLE-BOX
          SIZE 15.6 BY .76
     NPAGFRALUFT.batteri_stand_utb AT ROW 4.57 COL 25.2 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Standard", "batteri_standard":U,
"Utbygd", "batteri_utbygd":U,
"Ikke batteri", "ikke_batteri":U
          SIZE 50.8 BY .91
     NPAGFRALUFT.rortype AT ROW 4.57 COL 90.2 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "P3012", "P3012":U,
"P60", "P60":U
          SIZE 22.6 BY .86
     NPAGFRALUFT.fronthast_kabinett AT ROW 5.62 COL 98.4 COLON-ALIGNED
          LABEL "kabinett"
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGFRALUFT.aggregattype AT ROW 5.71 COL 23.2 COLON-ALIGNED
          LABEL "Aggregat"
          VIEW-AS FILL-IN NATIVE 
          SIZE 16.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGFRALUFT.fronthast_batt_flate AT ROW 5.71 COL 70.4 COLON-ALIGNED
          LABEL "Fronthast. batteri"
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGFRALUFT.kabinett_delinger AT ROW 6.91 COL 70.4 COLON-ALIGNED
          LABEL "Ant. delinger"
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "0","1","2","3","4","5","6","7","8","9","10" 
          SIZE 9 BY 1
     NPAGFRALUFT.isolasjon AT ROW 6.91 COL 98.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "30","50","100" 
          SIZE 11 BY 1
     NPAGFRALUFT.kabinettype AT ROW 7.19 COL 25.2 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Enhets", "Enhets":U,
"Modul", "Modul":U
          SIZE 26.8 BY .86
     NPAGFRALUFT.inspeksjon AT ROW 8.24 COL 98.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Avklares","Høyre","Venstre" 
          SIZE 16.4 BY 1
     NPAGFRALUFT.utv_bredde AT ROW 8.38 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 8.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGFRALUFT.utv_hoyde AT ROW 8.38 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 8.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGFRALUFT.utv_lengde AT ROW 8.38 COL 70.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.4 BY 1
     NPAGFRALUFT.viftetype AT ROW 9.57 COL 23.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Radialvifte","Aksialvifte","Kammervifte" 
          SIZE 33.6 BY 1
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dilaog-Frame
     NPAGFRALUFT.skovle_type AT ROW 9.57 COL 83 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Foroverbøyd","Bakoverbøyd","Spesial" 
          SIZE 26.6 BY 1.14
     NPAGFRALUFT.vifte_posisjon AT ROW 10.91 COL 23.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "  0°/225°/Høyre","  0°/225°/Venstre","  0°/225°/Sentrert","  0°/225°/Usentrert"," 90°/225°/Høyre"," 90°/225°/Venstre"," 90°/225°/Sentrert"," 90°/225°/Usentrert","180°/225°/Høyre","180°/225°/Venstre","180°/225°/Sentrert","180°/225°/Usentrert","270°/225°/Høyre","270°/225°/Venstre","270°/225°/Sentrert","270°/225°/Usentrert" 
          SIZE 33.6 BY 1
     NPAGFRALUFT.motor_plassering AT ROW 10.91 COL 83 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Linjemontert","Sidemontert","Direktemontert" 
          SIZE 26.6 BY 1
     NPAGFRALUFT.fabrikat AT ROW 12.19 COL 23.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "ABB","Nicotra","Comefri","Maserati","Chicago Blower","Punker","Meinke" 
          SIZE 33.6 BY 1
     NPAGFRALUFT.type_betegnelse AT ROW 12.19 COL 83 COLON-ALIGNED
          LABEL "Vifte betegnelse"
          VIEW-AS FILL-IN 
          SIZE 30 BY 1.24
     NPAGFRALUFT.kraftoverforing AT ROW 13.48 COL 23.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Remdrift","Flatremdrift","Direktekoblet" 
          SIZE 26.6 BY 1
     NPAGFRALUFT.omdreininger AT ROW 13.48 COL 83 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.6 BY 1.24
     NPAGFRALUFT.pt AT ROW 13.48 COL 105.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.6 BY 1.24
     NPAGFRALUFT.virknings_grad AT ROW 14.71 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY 1.24
     NPAGFRALUFT.kraftbehov AT ROW 14.71 COL 83.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY 1.24
     NPAGFRALUFT.fundament_type AT ROW 16.05 COL 23.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Hjørne","Bein","Fundament","Fundament m/bein" 
          SIZE 27.2 BY 1
     NPAGFRALUFT.fundament_maal AT ROW 16.05 COL 83 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","030","050","075","100","120","140","160","180","200" 
          SIZE 10.4 BY 1
     NPAGFRALUFT.materialkvalitet AT ROW 17.29 COL 23.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Standard ihht dokumentasjon","Galvanisert utv, grå plastbelagt front","Aluminium utv/innv","Galvanisert utv/innv","Syrefast AISI 316 innv, galvanisert utv","Syrefast AISI 304 innv, galvanisert utv","Syrefast AISI 316 innv og utv","Syrefast AISI 304 innv og utv","Plastbelagt utv og innv" 
          SIZE 44.2 BY 1
     NPAGFRALUFT.modell_variant AT ROW 18.57 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY 1.24
     Btn_OK AT ROW 21.38 COL 49
     Btn_Cancel AT ROW 21.38 COL 58.4
     Btn_Help AT ROW 21.38 COL 71.6
     "°C/" VIEW-AS TEXT
          SIZE 5 BY .62 AT ROW 2.33 COL 64
     "kw" VIEW-AS TEXT
          SIZE 4.2 BY .76 AT ROW 14.91 COL 94.8
     "%" VIEW-AS TEXT
          SIZE 3 BY .76 AT ROW 15 COL 36
     "Pa" VIEW-AS TEXT
          SIZE 4 BY .76 AT ROW 13.91 COL 116.2
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dilaog-Frame
     "o/m" VIEW-AS TEXT
          SIZE 6 BY .76 AT ROW 13.91 COL 93
     "Kabinettype:" VIEW-AS TEXT
          SIZE 15.6 BY 1.05 AT ROW 7.05 COL 8.8
     "Batteritype-ref.:" VIEW-AS TEXT
          SIZE 13 BY 1.1 AT ROW 4.48 COL 10.8
     RECT-1 AT ROW 1.33 COL 2
     "m3/t" VIEW-AS TEXT
          SIZE 6.4 BY .62 AT ROW 2.33 COL 34.6
     "Rørtype:" VIEW-AS TEXT
          SIZE 10.6 BY .62 AT ROW 4.57 COL 79
     "kg/t" VIEW-AS TEXT
          SIZE 6 BY 1 AT ROW 3.62 COL 34.8
     "% RF" VIEW-AS TEXT
          SIZE 5.2 BY .62 AT ROW 2.33 COL 78.2
     SPACE(42.99) SKIP(20.28)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Aggregatsystem - Fraluft"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dilaog-Frame
                                                                        */
ASSIGN 
       FRAME Dilaog-Frame:SCROLLABLE       = FALSE
       FRAME Dilaog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN NPAGFRALUFT.aggregattype IN FRAME Dilaog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPAGFRALUFT.fronthast_batt_flate IN FRAME Dilaog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPAGFRALUFT.fronthast_kabinett IN FRAME Dilaog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPAGFRALUFT.kabinett_delinger IN FRAME Dilaog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPAGFRALUFT.nom_temp IN FRAME Dilaog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPAGFRALUFT.rf IN FRAME Dilaog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPAGFRALUFT.type_betegnelse IN FRAME Dilaog-Frame
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dilaog-Frame
/* Query rebuild information for DIALOG-BOX Dilaog-Frame
     _TblList          = "norcalc.NPAGFRALUFT"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dilaog-Frame */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dilaog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dilaog-Frame Dilaog-Frame
ON WINDOW-CLOSE OF FRAME Dilaog-Frame /* Aggregatsystem - Fraluft */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGFRALUFT.aggregattype
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGFRALUFT.aggregattype Dilaog-Frame
ON ENTRY OF NPAGFRALUFT.aggregattype IN FRAME Dilaog-Frame /* Aggregat */
DO:
    pointer = SESSION:SET-WAIT-STATE("GENERAL").
    RUN VELG_NOR.W (INPUT NPAGFRALUFT.batteri_stand_utb:SCREEN-VALUE, 
        INPUT DECIMAL(NPAGFRALUFT.nom_kapasitet:SCREEN-VALUE), 
        INPUT 'Velg Aggregattype for fraluft', INPUT NPAGFRALUFT.rortype:SCREEN-VALUE, 
        OUTPUT p_batteri_hastighet, OUTPUT p_kabinett_hastighet, OUTPUT p_type).
    NPAGFRALUFT.aggregattype = p_type.
    NPAGFRALUFT.fronthast_batt_flate = p_batteri_hastighet.
    NPAGFRALUFT.fronthast_kabinett = p_kabinett_hastighet.
    DISPLAY NPAGFRALUFT.aggregattype  NPAGFRALUFT.fronthast_batt_flate 
        NPAGFRALUFT.fronthast_kabinett 
    WITH FRAME {&FRAME-NAME}.
    /* Oppdater bredde etc. */
    IF NPAGFRALUFT.isolasjon:SCREEN-VALUE <> ? then
        RUN visKabinettMaal.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGFRALUFT.aktuell_kapasitet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGFRALUFT.aktuell_kapasitet Dilaog-Frame
ON ENTRY OF NPAGFRALUFT.aktuell_kapasitet IN FRAME Dilaog-Frame /* Aktuell kapasitet */
DO:
    ASSIGN
        NPAGFRALUFT.aktuell_kapasitet = 
        DECIMAL(NPAGFRALUFT.nom_kapasitet:SCREEN-VALUE)
        *  DECIMAL(NPAGFRALUFT.spes_vekt:SCREEN-VALUE).
        DISPLAY NPAGFRALUFT.aktuell_kapasitet  WITH FRAME {&frame-name}.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGFRALUFT.batteri_stand_utb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGFRALUFT.batteri_stand_utb Dilaog-Frame
ON VALUE-CHANGED OF NPAGFRALUFT.batteri_stand_utb IN FRAME Dilaog-Frame /* batteri_stand_utb */
DO:
  ASSIGN NPAGFRALUFT.el_batteri.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dilaog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dilaog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dilaog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dilaog-Frame /* OK */
DO:
    RUN smbMaal.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGFRALUFT.el_batteri
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGFRALUFT.el_batteri Dilaog-Frame
ON VALUE-CHANGED OF NPAGFRALUFT.el_batteri IN FRAME Dilaog-Frame /* El. batteri */
DO:
  ASSIGN NPAGFRALUFT.el_batteri.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGFRALUFT.fronthast_batt_flate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGFRALUFT.fronthast_batt_flate Dilaog-Frame
ON ENTRY OF NPAGFRALUFT.fronthast_batt_flate IN FRAME Dilaog-Frame /* Fronthast. batteri */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGFRALUFT.fronthast_kabinett
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGFRALUFT.fronthast_kabinett Dilaog-Frame
ON ENTRY OF NPAGFRALUFT.fronthast_kabinett IN FRAME Dilaog-Frame /* kabinett */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGFRALUFT.isolasjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGFRALUFT.isolasjon Dilaog-Frame
ON VALUE-CHANGED OF NPAGFRALUFT.isolasjon IN FRAME Dilaog-Frame /* Isolasjon */
DO:
  RUN visKabinettMaal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGFRALUFT.utv_bredde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGFRALUFT.utv_bredde Dilaog-Frame
ON ENTRY OF NPAGFRALUFT.utv_bredde IN FRAME Dilaog-Frame /* Utv. bredde */
DO:
  Return No-Apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGFRALUFT.utv_hoyde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGFRALUFT.utv_hoyde Dilaog-Frame
ON ENTRY OF NPAGFRALUFT.utv_hoyde IN FRAME Dilaog-Frame /* Utv. høyde */
DO:
    Return No-Apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGFRALUFT.vann_batteri
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGFRALUFT.vann_batteri Dilaog-Frame
ON VALUE-CHANGED OF NPAGFRALUFT.vann_batteri IN FRAME Dilaog-Frame /* Vannbatteri */
DO:
  ASSIGN NPAGFRALUFT.vann_batteri.
  IF NPAGFRALUFT.vann_batteri = FALSE THEN
    DISABLE NPAGFRALUFT.rortype WITH FRAME {&FRAME-NAME}.
  ELSE
    ENABLE NPAGFRALUFT.rortype  WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dilaog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   pointer = SESSION:SET-WAIT-STATE("").
   IF nyRecord THEN
        RUN nyttSystem.
   ELSE
        RUN endreSystem.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dilaog-Frame _DEFAULT-DISABLE
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
  HIDE FRAME Dilaog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dilaog-Frame _DEFAULT-ENABLE
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

  {&OPEN-QUERY-Dilaog-Frame}
  GET FIRST Dilaog-Frame.
  IF AVAILABLE NPAGFRALUFT THEN 
    DISPLAY NPAGFRALUFT.nom_kapasitet NPAGFRALUFT.nom_temp NPAGFRALUFT.rf 
          NPAGFRALUFT.spes_vekt NPAGFRALUFT.aktuell_kapasitet 
          NPAGFRALUFT.vann_batteri NPAGFRALUFT.el_batteri 
          NPAGFRALUFT.batteri_stand_utb NPAGFRALUFT.rortype 
          NPAGFRALUFT.fronthast_kabinett NPAGFRALUFT.aggregattype 
          NPAGFRALUFT.fronthast_batt_flate NPAGFRALUFT.kabinett_delinger 
          NPAGFRALUFT.isolasjon NPAGFRALUFT.kabinettype NPAGFRALUFT.inspeksjon 
          NPAGFRALUFT.utv_bredde NPAGFRALUFT.utv_hoyde NPAGFRALUFT.utv_lengde 
          NPAGFRALUFT.viftetype NPAGFRALUFT.skovle_type 
          NPAGFRALUFT.vifte_posisjon NPAGFRALUFT.motor_plassering 
          NPAGFRALUFT.fabrikat NPAGFRALUFT.type_betegnelse 
          NPAGFRALUFT.kraftoverforing NPAGFRALUFT.omdreininger NPAGFRALUFT.pt 
          NPAGFRALUFT.virknings_grad NPAGFRALUFT.kraftbehov 
          NPAGFRALUFT.fundament_type NPAGFRALUFT.fundament_maal 
          NPAGFRALUFT.materialkvalitet NPAGFRALUFT.modell_variant 
      WITH FRAME Dilaog-Frame.
  ENABLE RECT-1 NPAGFRALUFT.nom_kapasitet NPAGFRALUFT.nom_temp NPAGFRALUFT.rf 
         NPAGFRALUFT.spes_vekt NPAGFRALUFT.aktuell_kapasitet 
         NPAGFRALUFT.vann_batteri NPAGFRALUFT.el_batteri 
         NPAGFRALUFT.batteri_stand_utb NPAGFRALUFT.rortype 
         NPAGFRALUFT.fronthast_kabinett NPAGFRALUFT.aggregattype 
         NPAGFRALUFT.fronthast_batt_flate NPAGFRALUFT.kabinett_delinger 
         NPAGFRALUFT.isolasjon NPAGFRALUFT.kabinettype NPAGFRALUFT.inspeksjon 
         NPAGFRALUFT.utv_bredde NPAGFRALUFT.utv_hoyde NPAGFRALUFT.utv_lengde 
         NPAGFRALUFT.viftetype NPAGFRALUFT.skovle_type 
         NPAGFRALUFT.vifte_posisjon NPAGFRALUFT.motor_plassering 
         NPAGFRALUFT.fabrikat NPAGFRALUFT.type_betegnelse 
         NPAGFRALUFT.kraftoverforing NPAGFRALUFT.omdreininger NPAGFRALUFT.pt 
         NPAGFRALUFT.virknings_grad NPAGFRALUFT.kraftbehov 
         NPAGFRALUFT.fundament_type NPAGFRALUFT.fundament_maal 
         NPAGFRALUFT.materialkvalitet NPAGFRALUFT.modell_variant Btn_OK 
         Btn_Cancel Btn_Help 
      WITH FRAME Dilaog-Frame.
  VIEW FRAME Dilaog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dilaog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreSystem Dilaog-Frame 
PROCEDURE endreSystem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND NPAGFRALUFT WHERE NPAGFRALUFT.anleggsnr = anleggsnrParam
    AND NPAGFRALUFT.systemnr  = systemnrParam 
    AND NPAGFRALUFT.del_nr = delnrParam EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
  IF AVAILABLE NPAGFRALUFT THEN
    DO:
        fraluftsRec = ROWID(NPAGFRALUFT).
        UPDATE 
            NPAGFRALUFT.nom_kapasitet NPAGFRALUFT.nom_temp 
            NPAGFRALUFT.rf  NPAGFRALUFT.spes_vekt 
            NPAGFRALUFT.aktuell_kapasitet  NPAGFRALUFT.vann_batteri 
            NPAGFRALUFT.el_batteri
            NPAGFRALUFT.batteri_stand_utb   NPAGFRALUFT.rortype
            NPAGFRALUFT.aggregattype
            NPAGFRALUFT.fronthast_batt_flate NPAGFRALUFT.fronthast_kabinett
             NPAGFRALUFT.kabinettype NPAGFRALUFT.kabinett_delinger
            NPAGFRALUFT.isolasjon 
            NPAGFRALUFT.utv_bredde NPAGFRALUFT.utv_hoyde 
            NPAGFRALUFT.utv_lengde 
            NPAGFRALUFT.inspeksjon     
            NPAGFRALUFT.utv_bredde NPAGFRALUFT.utv_hoyde 
            NPAGFRALUFT.utv_lengde NPAGFRALUFT.inspeksjon 
            NPAGFRALUFT.viftetype NPAGFRALUFT.skovle_type 
            NPAGFRALUFT.vifte_posisjon NPAGFRALUFT.motor_plassering 
            NPAGFRALUFT.fabrikat NPAGFRALUFT.type_betegnelse 
            NPAGFRALUFT.kraftoverforing NPAGFRALUFT.omdreininger 
            NPAGFRALUFT.pt NPAGFRALUFT.virknings_grad NPAGFRALUFT.kraftbehov    
            NPAGFRALUFT.fundament_type 
            NPAGFRALUFT.fundament_maal
            NPAGFRALUFT.materialkvalitet  
            NPAGFRALUFT.modell_variant
         Btn_OK Btn_Cancel Btn_Help
           WITH FRAME {&FRAME-NAME}.
    END.
 ELSE DO:
        MESSAGE 'KUNNE IKKE FINNE POSTEN' VIEW-AS ALERT-BOX.
         RETURN.
    END.
 END. /* TRANSACTION */      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyttSystem Dilaog-Frame 
PROCEDURE nyttSystem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND LAST NPAGFRALUFT  WHERE NPAGFRALUFT.anleggsnr = anleggsnrParam 
    AND NPAGFRALUFT.systemnr = systemnrParam NO-LOCK  NO-ERROR NO-WAIT.
  IF AVAILABLE(NPAGFRALUFT) THEN
      /* Det er opprettet fraluftsdel for dette systemet tidligere */
          fralufts_nr# = NPAGFRALUFT.del_nr  + 1.
  ELSE
    DO:
      IF LOCKED NPAGFRALUFT THEN
         DO:
            /* Andre registrerer fraluftsdel på dette systemet nå */
             MESSAGE 'Andre bruker registeret nå. Prøv igjen senere' VIEW-AS ALERT-BOX 
                 TITLE 'STOPP'.
            RETURN.
         END.
    ELSE            
      fralufts_nr# = 1.  
    END.
  CREATE NPAGFRALUFT.
  fraluftsRec = ROWID(NPAGFRALUFT).
  NPAGFRALUFT.anleggsnr  = anleggsnrParam.
  NPAGFRALUFT.systemnr = systemnrParam.
  NPAGFRALUFT.del_nr = fralufts_nr#.
  NPAGFRALUFT.spes_vekt = 1.2.
  NPAGFRALUFT.vann_batteri = TRUE.
 UPDATE 
    NPAGFRALUFT.nom_kapasitet NPAGFRALUFT.nom_temp 
    NPAGFRALUFT.rf  NPAGFRALUFT.spes_vekt 
    NPAGFRALUFT.aktuell_kapasitet  NPAGFRALUFT.vann_batteri
     NPAGFRALUFT.el_batteri
    NPAGFRALUFT.batteri_stand_utb   NPAGFRALUFT.rortype
    NPAGFRALUFT.aggregattype
    NPAGFRALUFT.fronthast_batt_flate NPAGFRALUFT.fronthast_kabinett
     NPAGFRALUFT.kabinettype NPAGFRALUFT.kabinett_delinger
    NPAGFRALUFT.isolasjon 
    NPAGFRALUFT.utv_bredde NPAGFRALUFT.utv_hoyde 
    NPAGFRALUFT.utv_lengde NPAGFRALUFT.inspeksjon 
    NPAGFRALUFT.viftetype NPAGFRALUFT.skovle_type 
    NPAGFRALUFT.vifte_posisjon NPAGFRALUFT.motor_plassering 
    NPAGFRALUFT.fabrikat NPAGFRALUFT.type_betegnelse 
    NPAGFRALUFT.kraftoverforing NPAGFRALUFT.omdreininger 
    NPAGFRALUFT.pt NPAGFRALUFT.virknings_grad NPAGFRALUFT.kraftbehov    
    NPAGFRALUFT.fundament_type NPAGFRALUFT.fundament_maal
    NPAGFRALUFT.materialkvalitet 
    NPAGFRALUFT.modell_variant
     Btn_OK Btn_Cancel Btn_Help
      WITH FRAME {&FRAME-NAME}.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE smbMaal Dilaog-Frame 
PROCEDURE smbMaal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR c_plassering AS CHAR.
DEFINE VAR n_antall_deler  AS INTEGER INITIAL 0.
DEFINE VAR n_tilluft_hoyde AS DECIMAL  INITIAL 0.
DEFINE VAR n_fraluft_hoyde AS DECIMAL INITIAL 0.

/* Sammenbindingsmål regnes ut og legge i tabell */
/* SMB er avhengig av valgt plassering */
SELECT plassering INTO c_plassering 
FROM NPAGSYST 
WHERE anleggsnr = anleggsnrParam
AND systemnr = systemnrParam.
IF c_plassering = ? OR c_plassering = "" THEN
    Return.
ELSE
    /* Hvis plassering = 'Sammenbygd': SMB = h1 +hn - (høydereduksjon * n)
                                            'Stablet'              : SMB = h1 + hn
                                            'Hver for seg'    : SMB = h */
DO:
        FIND NPAGSYST WHERE NPAGSYST.anleggsnr = anleggsnrParam 
            AND NPAGSYST.systemnr = systemnrParam NO-ERROR.
        IF AVAILABLE NPAGSYST THEN
            CASE c_plassering:
                WHEN 'Sammenbygd' THEN
                    DO:
                        FOR EACH NPAGTILLUFT 
                            WHERE NPAGTILLUFT.anleggsnr = anleggsnrParam 
                            AND NPAGTILLUFT.systemnr = systemnrParam:
                            n_antall_deler = n_antall_deler + 1.
                            n_tilluft_hoyde = n_tilluft_hoyde + NPAGTILLUFT.utv_hoyde.
                         END.
                        FOR EACH NPAGFRALUFT 
                            WHERE NPAGFRALUFT.anleggsnr = anleggsnrParam 
                            AND NPAGFRALUFT.systemnr = systemnrParam:
                            n_antall_deler = n_antall_deler + 1.
                            n_fraluft_hoyde = n_fraluft_hoyde + NPAGFRALUFT.utv_hoyde.
                         END.
                         NPAGSYST.smb_maal = (n_tilluft_hoyde + n_fraluft_hoyde) - (n_reduksjon * n_antall_deler).
                    END. 
                WHEN 'Stablet' THEN
                    DO:
                        FOR EACH NPAGTILLUFT 
                            WHERE NPAGTILLUFT.anleggsnr = anleggsnrParam 
                            AND NPAGTILLUFT.systemnr = systemnrParam:
                            n_tilluft_hoyde = n_tilluft_hoyde + NPAGTILLUFT.utv_hoyde.
                         END.
                        FOR EACH NPAGFRALUFT 
                            WHERE NPAGFRALUFT.anleggsnr = anleggsnrParam 
                            AND NPAGFRALUFT.systemnr = systemnrParam:
                            n_fraluft_hoyde = n_fraluft_hoyde + NPAGFRALUFT.utv_hoyde.
                         END.
                         NPAGSYST.smb_maal = (n_tilluft_hoyde + n_fraluft_hoyde).
                    END.
                WHEN 'Hver for seg' THEN
                    NPAGSYST.smb_maal = 0.
            END CASE.
    END.        
/* Reset record buffer til rett tilluftsrecord */
FIND NPAGFRALUFT WHERE ROWID(NPAGFRALUFT) = fraluftsRec.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE visKabinettMaal Dilaog-Frame 
PROCEDURE visKabinettMaal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Ut fra valgt aggregat og isolasjon, hent kabinettm†l */

DO WITH FRAME {&FRAME-NAME}:
    FIND NPAGKABMAAL WHERE NPAGKABMAAL.aggregattype = 
        NPAGFRALUFT.aggregattype:SCREEN-VALUE AND NPAGKABMAAL.isolasjon =
        INTEGER(NPAGFRALUFT.isolasjon:SCREEN-VALUE) NO-LOCK NO-WAIT  NO-ERROR.
    IF AVAILABLE NPAGKABMAAL THEN
        DO:    
            NPAGFRALUFT.utv_bredde = NPAGKABMAAL.bredde.
            NPAGFRALUFT.utv_hoyde = NPAGKABMAAL.hoyde.
            n_reduksjon = NPAGKABMAAL.hoydereduksjon.    
            DISPLAY 
                 NPAGFRALUFT.utv_bredde NPAGFRALUFT.utv_hoyde.
        END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


