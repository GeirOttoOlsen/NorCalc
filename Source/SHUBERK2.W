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
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE var appdata AS CHARACTER.
DEFINE var editModus AS INTEGER.
def var hParent as handle no-undo.
def var current-rec as rowid no-undo.
DEFINE VARIABLE kpa_verdi LIKE NPKPA_Table.w_kpa INITIAL 0.0.
DEFINE VARIABLE kvs_verdi LIKE NPKPA_Table.w_kvs INITIAL 0.0.
DEFINE VARIABLE autoritetParam LIKE NPKPA_Table.w_autoritet INITIAL 0.0.

/* Local Variable Definitions ---                                       */
DEFINE VAR parameter1 AS DECIMAL INITIAL 0.
DEFINE VAR parameter2 AS DECIMAL INITIAL 0.
DEFINE VAR  c_strupe_kvs AS DECIMAL.
DEFINE VAR  c_delta_Pstr  AS DECIMAL.
DEFINE VAR  c_dimm LIKE NPSHSDIM.dimmensjon.
DEFINE VAR c_kap_sek AS DECIMAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DLGOKCAN

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHSYST.trykk_for_shunt_ventil ~
NPSHSYST.motstand_objekt NPSHSYST.glykol NPSHSYST.motstand_ror_bend ~
NPSHSYST.konsentrasjon NPSHSYST.ventilmotstand_port_2-1 NPSHSYST.sikkerhet ~
NPSHSYST.fabrikat NPSHSYST.motstand_strupeventil_sek ~
NPSHSYST.forhaands_struping NPSHSYST.ventil_karakteristikk_hoved ~
NPSHSYST.ventil_karakteristikk_shunt 
&Scoped-define ENABLED-TABLES NPSHSYST
&Scoped-define FIRST-ENABLED-TABLE NPSHSYST
&Scoped-define DISPLAYED-TABLES NPSHSYST
&Scoped-define FIRST-DISPLAYED-TABLE NPSHSYST
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel Btn_Help RECT-22 RECT-25 
&Scoped-Define DISPLAYED-FIELDS NPSHSYST.trykk_for_shunt_ventil ~
NPSHSYST.motstand_objekt NPSHSYST.glykol NPSHSYST.motstand_ror_bend ~
NPSHSYST.konsentrasjon NPSHSYST.ventilmotstand_port_2-1 NPSHSYST.sikkerhet ~
NPSHSYST.fabrikat NPSHSYST.minste_pumpetrykk ~
NPSHSYST.motstand_strupeventil_sek NPSHSYST.forhaands_struping ~
NPSHSYST.ventil_karakteristikk_hoved NPSHSYST.motstand_sek_krets ~
NPSHSYST.ventil_karakteristikk_shunt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 16.8 BY 1.43
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Hjelp":L 
     SIZE 16.8 BY 1.43
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK":L 
     SIZE 16.8 BY 1.43
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 44 BY 3.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 105.6 BY 14.24.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70 BY 2.62
     BGCOLOR 0 FGCOLOR 0 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGOKCAN
     NPSHSYST.trykk_for_shunt_ventil AT ROW 2.95 COL 39 COLON-ALIGNED
          LABEL "Trykk før SHG"
          VIEW-AS FILL-IN NATIVE 
          SIZE 9.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.motstand_objekt AT ROW 5.67 COL 38.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.glykol AT ROW 5.67 COL 81 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 4
          LIST-ITEMS "Ingen","Etylen","Propylen","Annet" 
          DROP-DOWN-LIST
          SIZE 19.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.motstand_ror_bend AT ROW 7 COL 38.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.konsentrasjon AT ROW 7 COL 81 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "0","5","10","30","50" 
          DROP-DOWN-LIST
          SIZE 8.6 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.ventilmotstand_port_2-1 AT ROW 8.38 COL 39 COLON-ALIGNED
          LABEL "Ventilmotstand port 2-1/3-1"
          VIEW-AS FILL-IN NATIVE 
          SIZE 9.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.sikkerhet AT ROW 8.43 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.fabrikat AT ROW 9.81 COL 40.8 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "HM", "HM":U,
"TA", "TA":U,
"DA","DA"
          SIZE 23.2 BY 1.24
     NPSHSYST.minste_pumpetrykk AT ROW 9.81 COL 81 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.8 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.motstand_strupeventil_sek AT ROW 11.1 COL 38.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.forhaands_struping AT ROW 12.52 COL 38.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHSYST.ventil_karakteristikk_hoved AT ROW 12.57 COL 83.4 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "LIN":U, "LIN":U,
"LOG":U, "LOG":U
          SIZE 20.4 BY 1.05
     NPSHSYST.motstand_sek_krets AT ROW 13.81 COL 38.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.8 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.ventil_karakteristikk_shunt AT ROW 13.81 COL 83.4 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "LIN":U, "LIN":U,
"LOG":U, "LOG":U
          SIZE 20.4 BY 1.05
     Btn_OK AT ROW 17.29 COL 22.2
     Btn_Cancel AT ROW 17.29 COL 43.2
     Btn_Help AT ROW 17.29 COL 70.8
     RECT-9 AT ROW 16.67 COL 19.4
     RECT-22 AT ROW 12.14 COL 61.8
     RECT-25 AT ROW 1.43 COL 2.2
     " Primærside" VIEW-AS TEXT
          SIZE 16 BY .81 AT ROW 1.81 COL 25
          BGCOLOR 1 FGCOLOR 15 
     "kPa" VIEW-AS TEXT
          SIZE 5 BY .81 AT ROW 10.19 COL 93.6
     "kPa" VIEW-AS TEXT
          SIZE 5 BY .81 AT ROW 11.57 COL 52
     "Ventilkarakteristikk" VIEW-AS TEXT
          SIZE 25.4 BY .81 AT ROW 11.71 COL 70.8
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME DLGOKCAN
     "Hovedport 2-1:" VIEW-AS TEXT
          SIZE 19.4 BY .81 AT ROW 12.67 COL 62.8
     "kPa" VIEW-AS TEXT
          SIZE 5 BY .81 AT ROW 12.86 COL 52
     "Shuntport 3-1:" VIEW-AS TEXT
          SIZE 18.4 BY .81 AT ROW 13.81 COL 63.8
     "kPa" VIEW-AS TEXT
          SIZE 5 BY .81 AT ROW 14.19 COL 52
     "kPa" VIEW-AS TEXT
          SIZE 5 BY .81 AT ROW 3.38 COL 52.2
     " Sekundærside" VIEW-AS TEXT
          SIZE 19.8 BY .81 AT ROW 4.52 COL 22.8
          BGCOLOR 1 FGCOLOR 15 
     "kPa" VIEW-AS TEXT
          SIZE 5 BY .81 AT ROW 6.1 COL 52
     "kPa" VIEW-AS TEXT
          SIZE 5 BY .81 AT ROW 7.57 COL 52
     "%" VIEW-AS TEXT
          SIZE 3.4 BY .81 AT ROW 7.57 COL 94.6
     "%" VIEW-AS TEXT
          SIZE 3.4 BY .81 AT ROW 8.62 COL 94.6
     "kPa" VIEW-AS TEXT
          SIZE 5 BY .81 AT ROW 8.95 COL 52
     "Fabrikat strupeventil:" VIEW-AS TEXT
          SIZE 28.2 BY .81 AT ROW 10.05 COL 12.4
     SPACE(70.08) SKIP(9.61)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "Beregning, Kobling 2":L
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DLGOKCAN
   UNDERLINE                                                            */
ASSIGN 
       FRAME DLGOKCAN:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN NPSHSYST.minste_pumpetrykk IN FRAME DLGOKCAN
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.motstand_sek_krets IN FRAME DLGOKCAN
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-9 IN FRAME DLGOKCAN
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.trykk_for_shunt_ventil IN FRAME DLGOKCAN
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.ventilmotstand_port_2-1 IN FRAME DLGOKCAN
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help DLGOKCAN
ON CHOOSE OF Btn_Help IN FRAME DLGOKCAN /* Hjelp */
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
  /* Test om ventilmotstand og motstand strupeventil er satt */
    IF  DECIMAL(NPSHSYST.ventilmotstand_port_2-1:SCREEN-VALUE) = 0 THEN
        DO:
            MESSAGE 'Ventilmotstand må være større enn 0' VIEW-AS ALERT-BOX ERROR TITLE 'FEIL'.
            APPLY 'ENTRY' TO NPSHSYST.ventilmotstand_port_2-1.
            RETURN NO-APPLY.
        END.
    IF  DECIMAL(NPSHSYST.motstand_strupeventil_sek:SCREEN-VALUE) = 0 THEN
        DO:
            MESSAGE 'Strupeventilmotstand må være større enn 0' VIEW-AS ALERT-BOX ERROR TITLE 'FEIL'.
            APPLY 'ENTRY' TO NPSHSYST.motstand_strupeventil_sek.
            RETURN NO-APPLY.
        END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.forhaands_struping
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.forhaands_struping DLGOKCAN
ON LEAVE OF NPSHSYST.forhaands_struping IN FRAME DLGOKCAN /* Forhåndsstruping */
DO:
  DEFINE VAR c_sekund_sum AS DECIMAL.
  c_sekund_sum = 
                  DECIMAL(NPSHSYST.ventilmotstand_port_2-1:SCREEN-VALUE) +
                  DECIMAL(NPSHSYST.motstand_objekt:SCREEN-VALUE) +                            
                  DECIMAL(NPSHSYST.forhaands_struping:SCREEN-VALUE) +
                  DECIMAL(NPSHSYST.motstand_ror_bend :SCREEN-VALUE) +
                  DECIMAL(NPSHSYST.motstand_strupeventil_sek:SCREEN-VALUE).
  ASSIGN NPSHSYST.motstand_sek_krets = c_sekund_sum.
  DISPLAY NPSHSYST.motstand_sek_krets WITH FRAME DLGOKCAN.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.glykol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.glykol DLGOKCAN
ON VALUE-CHANGED OF NPSHSYST.glykol IN FRAME DLGOKCAN /* Glykol */
DO:
  CASE NPSHSYST.glykol:
      WHEN 'Etylen' OR WHEN 'Propylen' THEN
        IF NPSHSYST.konsentrasjon = '0' THEN
          NPSHSYST.konsentrasjon = '30'.
      OTHERWISE
        IF NPSHSYST.konsentrasjon = '0' THEN
          NPSHSYST.konsentrasjon = '0'.
   END CASE.
   DISPLAY NPSHSYST.konsentrasjon WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.motstand_strupeventil_sek
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.motstand_strupeventil_sek DLGOKCAN
ON ENTRY OF NPSHSYST.motstand_strupeventil_sek IN FRAME DLGOKCAN /* Motstand strupeventil */
DO:
         c_kap_sek = NPSHSYST.sek_kapasitet. 

/*     IF NPSHSYST.fabrikat:SCREEN-VALUE = 'TA' THEN */
/*         RUN STRUP_TA.W (INPUT 'Sek', INPUT c_kap_sek, OUTPUT c_strupe_kvs, OUTPUT c_delta_Pstr, */
/*             OUTPUT c_dimm). */
/*     ELSE */
/*         RUN STRUP_HM.W (INPUT 'Sek',  INPUT c_kap_sek, OUTPUT c_strupe_kvs, OUTPUT c_delta_Pstr, */
/*             OUTPUT c_dimm). */
     case npshsys.fabrikat:screen-value:
       when 'TA' then RUN STRUP_TA.W (INPUT 'Sek', INPUT c_kap_sek, OUTPUT c_strupe_kvs, OUTPUT c_delta_Pstr, 
            OUTPUT c_dimm).
       when 'HM' then RUN STRUP_HM.W (INPUT 'Sek',  INPUT c_kap_sek, OUTPUT c_strupe_kvs, OUTPUT c_delta_Pstr, 
            OUTPUT c_dimm).
       when 'DA' then RUN STRUP_DA.W (INPUT 'Sek',  INPUT c_kap_sek, OUTPUT c_strupe_kvs, OUTPUT c_delta_Pstr, 
            OUTPUT c_dimm).
     end case.

     ASSIGN NPSHSYST.motstand_strupeventil_prim = c_delta_Pstr
            NPSHSYST.motstand_strupeventil_sek = c_delta_Pstr.
     DISPLAY NPSHSYST.motstand_strupeventil_sek WITH FRAME DLGOKCAN.

     ASSIGN NPSHSYST.strupe_dimmensjon_prim = c_dimm
         NPSHSYST.strupe_dimmensjon_sek = c_dimm.                   

                IF INTEGER(NPSHSYST.strupe_dimmensjon_sek) <= 50 THEN
                    DO:
                        ASSIGN NPSHSYST.tillegg_stengeventil_type_sek = 'Kule'
                            NPSHSYST.tillegg_kuleventil_prim = TRUE
                            NPSHSYST.tillegg_kuleventil_sek = TRUE
                            NPSHSYST.tillegg_spjeldventil_prim = FALSE
                            NPSHSYST.tillegg_spjeldventil_sek = FALSE
                            NPSHSYST.tillegg_spjeldventil_fabrikat_pr = ""
                            NPSHSYST.tillegg_spjeldventil_fabrikat_se = "".
                    END.
                ELSE
                    DO:
                        ASSIGN NPSHSYST.tillegg_stengeventil_type_sek = 'Spjeld'
                            NPSHSYST.tillegg_kuleventil_prim = FALSE
                            NPSHSYST.tillegg_kuleventil_sek = FALSE
                            NPSHSYST.tillegg_spjeldventil_prim = TRUE
                            NPSHSYST.tillegg_spjeldventil_sek = TRUE
                            NPSHSYST.tillegg_kuleventil_fabrikat_prim = ""
                            NPSHSYST.tillegg_kuleventil_fabrikat_sek = "".
                    END.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.sikkerhet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.sikkerhet DLGOKCAN
ON LEAVE OF NPSHSYST.sikkerhet IN FRAME DLGOKCAN /* Sikkerhet */
DO:
   DEFINE VAR c_sub_sum  AS DECIMAL.
   DEFINE VAR c_min_sum AS DECIMAL.
   DEFINE VAR c_glycol AS DECIMAL.
   DEFINE VAR  c_sikkerhet AS DECIMAL.
    
  c_sub_sum = DECIMAL(NPSHSYST.ventilmotstand_port_2-1:SCREEN-VALUE) +
/*                            DECIMAL(NPSHSYST.motstand_objekt:SCREEN-VALUE) +                            */
                            DECIMAL(NPSHSYST.forhaands_struping:SCREEN-VALUE) +
                            DECIMAL(NPSHSYST.motstand_ror_bend :SCREEN-VALUE) +
                            DECIMAL(NPSHSYST.motstand_strupeventil_sek:SCREEN-VALUE).

   /* Legg til glycol */
   IF NPSHSYST.glykol:SCREEN-VALUE <> 'Ingen' THEN
       DO:
           CASE NPSHSYST.konsentrasjon:SCREEN-VALUE:
               WHEN '0' THEN
                    c_glycol = 0.
               WHEN '5' THEN
                    c_glycol = 2.5.           
               WHEN '10' THEN
                    c_glycol = 5.           
               WHEN '30' THEN
                    c_glycol = 15.    
               WHEN '50' THEN
                    c_glycol = 25.
            END CASE.
            c_sub_sum = c_sub_sum  + ((c_sub_sum * c_glycol) / 100).
    END.
   /* Legg til sikkerhet */
    c_sikkerhet = ((c_sub_sum * DECIMAL(NPSHSYST.sikkerhet:SCREEN-VALUE)) / 100).
   c_min_sum =  c_sub_sum + c_sikkerhet + DECIMAL(NPSHSYST.motstand_objekt:SCREEN-VALUE).
.
    
    ASSIGN NPSHSYST.minste_pumpetrykk = c_min_sum.
    DISPLAY NPSHSYST.minste_pumpetrykk WITH FRAME DLGOKCAN.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHSYST.ventilmotstand_port_2-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHSYST.ventilmotstand_port_2-1 DLGOKCAN
ON ENTRY OF NPSHSYST.ventilmotstand_port_2-1 IN FRAME DLGOKCAN /* Ventilmotstand port 2-1/3-1 */
DO:
  parameter1 = DECIMAL(NPSHSYST.trykk_for_shunt_ventil:SCREEN-VALUE).
  RUN VELG_KPA.W (INPUT parameter1, parameter2, 'Ventilmotstand Port 2-1/3-1',2).
  ASSIGN NPSHSYST.ventilmotstand_port_2-1 = kpa_verdi.
  ASSIGN NPSHSYST.kvs_hovedport = kvs_verdi.
  ASSIGN NPSHSYST.ventilmotstand_port_3-1 = kpa_verdi.
  ASSIGN NPSHSYST.kvs_shuntport = kvs_verdi
      NPSHSYST.autoritet = autoritetParam.
  DISPLAY ventilmotstand_port_2-1 WITH FRAME DLGOKCAN.
   RETURN NO-APPLY.
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
   current-rec = dynamic-function('getCurrentRec' in hParent).
   editModus = dynamic-function('getEditModus' in hParent).
    /*Snarvei for å slippe å gjøre så mye i subprogram...*/
    JBoxRelation:instance:addParameter(this-procedure,'editModus',string(editModus)).
    JBoxRelation:instance:addParameter(this-procedure,'currentRec',string(current-rec)).
   RUN start_UI.

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
  IF AVAILABLE NPSHSYST THEN 
    DISPLAY NPSHSYST.trykk_for_shunt_ventil NPSHSYST.motstand_objekt 
          NPSHSYST.glykol NPSHSYST.motstand_ror_bend NPSHSYST.konsentrasjon 
          NPSHSYST.ventilmotstand_port_2-1 NPSHSYST.sikkerhet NPSHSYST.fabrikat 
          NPSHSYST.minste_pumpetrykk NPSHSYST.motstand_strupeventil_sek 
          NPSHSYST.forhaands_struping NPSHSYST.ventil_karakteristikk_hoved 
          NPSHSYST.motstand_sek_krets NPSHSYST.ventil_karakteristikk_shunt 
      WITH FRAME DLGOKCAN.
  ENABLE NPSHSYST.trykk_for_shunt_ventil NPSHSYST.motstand_objekt 
         NPSHSYST.glykol NPSHSYST.motstand_ror_bend NPSHSYST.konsentrasjon 
         NPSHSYST.ventilmotstand_port_2-1 NPSHSYST.sikkerhet NPSHSYST.fabrikat 
         NPSHSYST.motstand_strupeventil_sek NPSHSYST.forhaands_struping 
         NPSHSYST.ventil_karakteristikk_hoved 
         NPSHSYST.ventil_karakteristikk_shunt Btn_OK Btn_Cancel Btn_Help 
         RECT-22 RECT-25 
      WITH FRAME DLGOKCAN.
  {&OPEN-BROWSERS-IN-QUERY-DLGOKCAN}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE start_UI DLGOKCAN 
PROCEDURE start_UI :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
/*FIND NPSHSYST                                                             */
/*      WHERE NPSHSYST.anleggsnr = anleggsnrParam                           */
/*    AND NPSHSYST.systemnr = systemnrParam EXCLUSIVE-LOCK NO-WAIT NO-ERROR.*/
 find npshsyst where rowid(npshsyst) = current-rec exclusive-lock no-wait no-error. 

  IF AVAILABLE norcalc.NPSHSYST THEN 
    /* Vis felt som ikke skal oppdateres direkte */
    DO:
        DISPLAY
             NPSHSYST.minste_pumpetrykk  NPSHSYST.motstand_sek_krets                       
             WITH FRAME DLGOKCAN.
           ENABLE NPSHSYST.glykol WITH FRAME DLGOKCAN.
          APPLY "VALUE-CHANGED" TO glykol.

         IF editModus = 1 THEN
      UPDATE
        norcalc.NPSHSYST.trykk_for_shunt_ventil
        norcalc.NPSHSYST.motstand_objekt 
        norcalc.NPSHSYST.motstand_ror_bend 
         NPSHSYST.ventilmotstand_port_2-1 
        norcalc.NPSHSYST.fabrikat 
         NPSHSYST.motstand_strupeventil_sek   
        norcalc.NPSHSYST.forhaands_struping 
        norcalc.NPSHSYST.glykol 
        norcalc.NPSHSYST.konsentrasjon 
        norcalc.NPSHSYST.sikkerhet 
        norcalc.NPSHSYST.ventil_karakteristikk_hoved 
        norcalc.NPSHSYST.ventil_karakteristikk_shunt 
        Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME DLGOKCAN.
ELSE
    DO:
      DISABLE NPSHSYST.glykol WITH FRAME DLGOKCAN.
      DISPLAY
        norcalc.NPSHSYST.trykk_for_shunt_ventil
        norcalc.NPSHSYST.motstand_objekt 
        norcalc.NPSHSYST.motstand_ror_bend 
         NPSHSYST.ventilmotstand_port_2-1 
        norcalc.NPSHSYST.fabrikat 
         NPSHSYST.motstand_strupeventil_sek   
        norcalc.NPSHSYST.forhaands_struping 
        norcalc.NPSHSYST.glykol 
        norcalc.NPSHSYST.konsentrasjon 
        norcalc.NPSHSYST.sikkerhet 
        norcalc.NPSHSYST.ventil_karakteristikk_hoved 
        norcalc.NPSHSYST.ventil_karakteristikk_shunt 
      WITH FRAME DLGOKCAN.
       UPDATE
         Btn_Cancel
      WITH FRAME DLGOKCAN.
    END.
  END.
  ELSE
        DO:
            MESSAGE 'Beregning for dette system pågår. Prøv senere.' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN.
        END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

