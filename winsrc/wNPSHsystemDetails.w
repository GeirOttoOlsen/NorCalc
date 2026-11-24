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
def var Dimm_verdi as decimal no-undo.
def var kvs_hovedport as dec no-undo.
def var ventil_karakteristikk_hoved as dec no-undo.

/*** Start instance property definitions for JBoxBrowse object oBrwNPSHSYST ***/
DEF VAR oBrwNPSHSYST AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHSYST
    FIELD anleggsnr AS integer
    FIELD systemnr AS integer
    FIELD systembetegnelse AS character
    FIELD autoritet AS decimal
    FIELD beregnet_anvendelse AS character
    FIELD fabrikat AS character
    FIELD forhaands_struping AS decimal
    FIELD forhaands_struping_prim AS decimal
    FIELD forhaands_struping_sek AS decimal
    FIELD glykol AS character
    FIELD inngaende_trykk AS decimal
    FIELD koblings_alternativ AS character
    FIELD konsentrasjon AS character
    FIELD kvs_hovedport AS decimal
    FIELD kvs_shuntport AS decimal
    FIELD ledig_drivtrykk_prim AS decimal
    FIELD maks_pumpetrykk AS decimal
    FIELD med_i_ordre AS logical
    FIELD minste_pumpetrykk AS decimal
    FIELD minste_pumpetrykk_prim AS decimal
    FIELD motstand_objekt AS decimal
    FIELD motstand_objekt_avtrekk AS decimal
    FIELD motstand_objekt_innblaasning AS decimal
    FIELD motstand_prim_krets AS decimal
    FIELD motstand_ror_bend AS decimal
    FIELD motstand_ror_bend_avtrekk AS decimal
    FIELD motstand_ror_bend_innblaasning AS decimal
    FIELD motstand_ror_bend_prim AS decimal
    FIELD motstand_ror_bend_sek AS decimal
    FIELD motstand_sek_krets AS decimal
    FIELD motstand_strupeventil AS decimal
    FIELD motstand_strupeventil_prim AS decimal
    FIELD motstand_strupeventil_sek AS decimal
    FIELD ms_automatikk_fabrikat AS character
    FIELD ms_shuntventil_i_leveranse AS logical
    FIELD ms_ventiltype AS character
    FIELD ny_record AS logical
    FIELD prim_effekt AS integer
    FIELD prim_hastighet AS decimal
    FIELD prim_kapasitet AS decimal
    FIELD prim_temp_inn AS decimal
    FIELD prim_temp_ut AS decimal
    FIELD prod_nr AS character
    FIELD sek_effekt AS integer
    FIELD sek_hastighet AS decimal
    FIELD sek_kapasitet AS decimal
    FIELD sek_temp_inn AS decimal
    FIELD sek_temp_ut AS decimal
    FIELD shunthus_varenr AS character
    FIELD shuntkvs_varenr AS character
    FIELD shunt_dimmensjon AS character
    FIELD shunt_dimmensjon_num AS integer
    FIELD sikkerhet AS decimal
    FIELD standardpris AS decimal
    FIELD strupe_dimmensjon_prim AS character
    FIELD strupe_dimmensjon_sek AS character
    FIELD system_kode AS character
    FIELD tegning_bmp AS character
    FIELD tillegg AS decimal
    FIELD tillegg_brakett_overgang AS character
    FIELD tillegg_ekspansjonskar AS logical
    FIELD tillegg_el_amp AS character
    FIELD tillegg_el_hz AS character
    FIELD tillegg_el_volt AS character
    FIELD tillegg_ferdigkoblet_prim AS logical
    FIELD tillegg_ferdigkoblet_sek AS logical
    FIELD tillegg_fm_brakett_overgang AS character
    FIELD tillegg_forstilling AS character
    FIELD tillegg_frekv_styr_innkl AS logical
    FIELD tillegg_gulvstativ AS logical
    FIELD tillegg_kapsling AS character
    FIELD tillegg_kuleventil_fabrikat_prim AS character
    FIELD tillegg_kuleventil_fabrikat_sek AS character
    FIELD tillegg_kuleventil_prim AS logical
    FIELD tillegg_kuleventil_sek AS logical
    FIELD tillegg_kuleventil_vnr_prim AS character
    FIELD tillegg_kuleventil_vnr_sek AS character
    FIELD tillegg_kw AS decimal
    FIELD tillegg_montasje AS character
    FIELD tillegg_ms_brakett_overgang AS character
    FIELD tillegg_pumpetype AS character
    FIELD tillegg_pumpe_betegnelse AS character
    FIELD tillegg_pumpe_fabrikat AS character
    FIELD tillegg_pumpe_type AS character
    FIELD tillegg_spjeldventil_fabrikat_pr AS character
    FIELD tillegg_spjeldventil_fabrikat_se AS character
    FIELD tillegg_spjeldventil_prim AS logical
    FIELD tillegg_spjeldventil_sek AS logical
    FIELD tillegg_spjeldventil_vnr_prim AS character
    FIELD tillegg_spjeldventil_vnr_sek AS character
    FIELD tillegg_stengeventil AS character
    FIELD tillegg_stengeventil_type_prim AS character
    FIELD tillegg_stengeventil_type_sek AS character
    FIELD tillegg_strupe AS logical
    FIELD trykk_for_shunt_ventil AS decimal
    FIELD type AS character
    FIELD ventilmotstand AS decimal
    FIELD ventilmotstand_port_2-1 AS decimal
    FIELD ventilmotstand_port_2-1_prim AS decimal
    FIELD ventilmotstand_port_2-1_sek AS decimal
    FIELD ventilmotstand_port_3-1 AS decimal
    FIELD ventilmotstand_port_3-1_prim AS decimal
    FIELD ventilmotstand_port_3-1_sek AS decimal
    FIELD ventil_blande_fordeling AS character
    FIELD ventil_karakteristikk_hoved AS character
    FIELD ventil_karakteristikk_shunt AS character
    FIELD ventil_type AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSHSYST FOR TEMP-TABLE NPSHSYST.


FUNCTION getBuffersAndFieldsBrwNPSHSYST RETURNS CHARACTER():
  RETURN
    'NPSHSYST'
     + ';anleggsnr'
     + ';systemnr'
     + ';systembetegnelse'
     + ';autoritet'
     + ';beregnet_anvendelse'
     + ';fabrikat'
     + ';forhaands_struping'
     + ';forhaands_struping_prim'
     + ';forhaands_struping_sek'
     + ';glykol'
     + ';inngaende_trykk'
     + ';koblings_alternativ'
     + ';konsentrasjon'
     + ';kvs_hovedport'
     + ';kvs_shuntport'
     + ';ledig_drivtrykk_prim'
     + ';maks_pumpetrykk'
     + ';med_i_ordre'
     + ';minste_pumpetrykk'
     + ';minste_pumpetrykk_prim'
     + ';motstand_objekt'
     + ';motstand_objekt_avtrekk'
     + ';motstand_objekt_innblaasning'
     + ';motstand_prim_krets'
     + ';motstand_ror_bend'
     + ';motstand_ror_bend_avtrekk'
     + ';motstand_ror_bend_innblaasning'
     + ';motstand_ror_bend_prim'
     + ';motstand_ror_bend_sek'
     + ';motstand_sek_krets'
     + ';motstand_strupeventil'
     + ';motstand_strupeventil_prim'
     + ';motstand_strupeventil_sek'
     + ';ms_automatikk_fabrikat'
     + ';ms_shuntventil_i_leveranse'
     + ';ms_ventiltype'
     + ';ny_record'
     + ';prim_effekt'
     + ';prim_hastighet'
     + ';prim_kapasitet'
     + ';prim_temp_inn'
     + ';prim_temp_ut'
     + ';prod_nr'
     + ';sek_effekt'
     + ';sek_hastighet'
     + ';sek_kapasitet'
     + ';sek_temp_inn'
     + ';sek_temp_ut'
     + ';shunthus_varenr'
     + ';shuntkvs_varenr'
     + ';shunt_dimmensjon'
     + ';shunt_dimmensjon_num'
     + ';sikkerhet'
     + ';standardpris'
     + ';strupe_dimmensjon_prim'
     + ';strupe_dimmensjon_sek'
     + ';system_kode'
     + ';tegning_bmp'
     + ';tillegg'
     + ';tillegg_brakett_overgang'
     + ';tillegg_ekspansjonskar'
     + ';tillegg_el_amp'
     + ';tillegg_el_hz'
     + ';tillegg_el_volt'
     + ';tillegg_ferdigkoblet_prim'
     + ';tillegg_ferdigkoblet_sek'
     + ';tillegg_fm_brakett_overgang'
     + ';tillegg_forstilling'
     + ';tillegg_frekv_styr_innkl'
     + ';tillegg_gulvstativ'
     + ';tillegg_kapsling'
     + ';tillegg_kuleventil_fabrikat_prim'
     + ';tillegg_kuleventil_fabrikat_sek'
     + ';tillegg_kuleventil_prim'
     + ';tillegg_kuleventil_sek'
     + ';tillegg_kuleventil_vnr_prim'
     + ';tillegg_kuleventil_vnr_sek'
     + ';tillegg_kw'
     + ';tillegg_montasje'
     + ';tillegg_ms_brakett_overgang'
     + ';tillegg_pumpetype'
     + ';tillegg_pumpe_betegnelse'
     + ';tillegg_pumpe_fabrikat'
     + ';tillegg_pumpe_type'
     + ';tillegg_spjeldventil_fabrikat_pr'
     + ';tillegg_spjeldventil_fabrikat_se'
     + ';tillegg_spjeldventil_prim'
     + ';tillegg_spjeldventil_sek'
     + ';tillegg_spjeldventil_vnr_prim'
     + ';tillegg_spjeldventil_vnr_sek'
     + ';tillegg_stengeventil'
     + ';tillegg_stengeventil_type_prim'
     + ';tillegg_stengeventil_type_sek'
     + ';tillegg_strupe'
     + ';trykk_for_shunt_ventil'
     + ';type'
     + ';ventilmotstand'
     + ';ventilmotstand_port_2-1'
     + ';ventilmotstand_port_2-1_prim'
     + ';ventilmotstand_port_2-1_sek'
     + ';ventilmotstand_port_3-1'
     + ';ventilmotstand_port_3-1_prim'
     + ';ventilmotstand_port_3-1_sek'
     + ';ventil_blande_fordeling'
     + ';ventil_karakteristikk_hoved'
     + ';ventil_karakteristikk_shunt'
     + ';ventil_type'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHSYST RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR otbNPSHSYST AS JBoxToolbar NO-UNDO.
DEF VAR oFmNPSHSYST AS JBoxFieldMap NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHSYST

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHSYST

/* Definitions for BROWSE BrwNPSHSYST                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHSYST NPSHSYST.anleggsnr ~
NPSHSYST.systemnr NPSHSYST.systembetegnelse NPSHSYST.autoritet ~
NPSHSYST.beregnet_anvendelse NPSHSYST.fabrikat NPSHSYST.forhaands_struping ~
NPSHSYST.forhaands_struping_prim NPSHSYST.forhaands_struping_sek ~
NPSHSYST.glykol NPSHSYST.inngaende_trykk NPSHSYST.koblings_alternativ ~
NPSHSYST.konsentrasjon NPSHSYST.kvs_hovedport NPSHSYST.kvs_shuntport ~
NPSHSYST.ledig_drivtrykk_prim NPSHSYST.maks_pumpetrykk NPSHSYST.med_i_ordre ~
NPSHSYST.minste_pumpetrykk NPSHSYST.minste_pumpetrykk_prim ~
NPSHSYST.motstand_objekt NPSHSYST.motstand_objekt_avtrekk ~
NPSHSYST.motstand_objekt_innblaasning NPSHSYST.motstand_prim_krets ~
NPSHSYST.motstand_ror_bend NPSHSYST.motstand_ror_bend_avtrekk ~
NPSHSYST.motstand_ror_bend_innblaasning NPSHSYST.motstand_ror_bend_prim ~
NPSHSYST.motstand_ror_bend_sek NPSHSYST.motstand_sek_krets ~
NPSHSYST.motstand_strupeventil NPSHSYST.motstand_strupeventil_prim ~
NPSHSYST.motstand_strupeventil_sek NPSHSYST.ms_automatikk_fabrikat ~
NPSHSYST.ms_shuntventil_i_leveranse NPSHSYST.ms_ventiltype ~
NPSHSYST.ny_record NPSHSYST.prim_effekt NPSHSYST.prim_hastighet ~
NPSHSYST.prim_kapasitet NPSHSYST.prim_temp_inn NPSHSYST.prim_temp_ut ~
NPSHSYST.prod_nr NPSHSYST.sek_effekt NPSHSYST.sek_hastighet ~
NPSHSYST.sek_kapasitet NPSHSYST.sek_temp_inn NPSHSYST.sek_temp_ut ~
NPSHSYST.shunthus_varenr NPSHSYST.shuntkvs_varenr NPSHSYST.shunt_dimmensjon ~
NPSHSYST.shunt_dimmensjon_num NPSHSYST.sikkerhet NPSHSYST.standardpris ~
NPSHSYST.strupe_dimmensjon_prim NPSHSYST.strupe_dimmensjon_sek ~
NPSHSYST.system_kode NPSHSYST.tegning_bmp NPSHSYST.tillegg ~
NPSHSYST.tillegg_brakett_overgang NPSHSYST.tillegg_ekspansjonskar ~
NPSHSYST.tillegg_el_amp NPSHSYST.tillegg_el_hz NPSHSYST.tillegg_el_volt ~
NPSHSYST.tillegg_ferdigkoblet_prim NPSHSYST.tillegg_ferdigkoblet_sek ~
NPSHSYST.tillegg_fm_brakett_overgang NPSHSYST.tillegg_forstilling ~
NPSHSYST.tillegg_frekv_styr_innkl NPSHSYST.tillegg_gulvstativ ~
NPSHSYST.tillegg_kapsling NPSHSYST.tillegg_kuleventil_fabrikat_prim ~
NPSHSYST.tillegg_kuleventil_fabrikat_sek NPSHSYST.tillegg_kuleventil_prim ~
NPSHSYST.tillegg_kuleventil_sek NPSHSYST.tillegg_kuleventil_vnr_prim ~
NPSHSYST.tillegg_kuleventil_vnr_sek NPSHSYST.tillegg_kw ~
NPSHSYST.tillegg_montasje NPSHSYST.tillegg_ms_brakett_overgang ~
NPSHSYST.tillegg_pumpetype NPSHSYST.tillegg_pumpe_betegnelse ~
NPSHSYST.tillegg_pumpe_fabrikat NPSHSYST.tillegg_pumpe_type ~
NPSHSYST.tillegg_spjeldventil_fabrikat_pr ~
NPSHSYST.tillegg_spjeldventil_fabrikat_se ~
NPSHSYST.tillegg_spjeldventil_prim NPSHSYST.tillegg_spjeldventil_sek ~
NPSHSYST.tillegg_spjeldventil_vnr_prim ~
NPSHSYST.tillegg_spjeldventil_vnr_sek NPSHSYST.tillegg_stengeventil ~
NPSHSYST.tillegg_stengeventil_type_prim ~
NPSHSYST.tillegg_stengeventil_type_sek NPSHSYST.tillegg_strupe ~
NPSHSYST.trykk_for_shunt_ventil NPSHSYST.type NPSHSYST.ventilmotstand ~
NPSHSYST.ventilmotstand_port_2-1 NPSHSYST.ventilmotstand_port_2-1_prim ~
NPSHSYST.ventilmotstand_port_2-1_sek NPSHSYST.ventilmotstand_port_3-1 ~
NPSHSYST.ventilmotstand_port_3-1_prim NPSHSYST.ventilmotstand_port_3-1_sek ~
NPSHSYST.ventil_blande_fordeling NPSHSYST.ventil_karakteristikk_hoved ~
NPSHSYST.ventil_karakteristikk_shunt NPSHSYST.ventil_type 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHSYST NPSHSYST.anleggsnr 
&Scoped-define QUERY-STRING-BrwNPSHSYST FOR EACH NPSHSYST NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHSYST OPEN QUERY BrwNPSHSYST FOR EACH NPSHSYST NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHSYST NPSHSYST
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHSYST NPSHSYST


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHSYST rectOppsett SHUNTTEGNING ~
new_tbNPSHSYST edit_tbNPSHSYST copy_tbNPSHSYST undo_tbNPSHSYST ~
save_tbNPSHSYST delete_tbNPSHSYST refresh_tbNPSHSYST filter_tbNPSHSYST ~
browseconfig_tbNPSHSYST excel_tbNPSHSYST BrwNPSHSYST systemnr ~
systembetegnelse koblings_alternativ beregnet_anvendelse sek_effekt ~
prim_effekt sek_temp_inn prim_temp_inn sek_temp_ut prim_temp_ut ~
sek_kapasitet prim_kapasitet btnReset type ms_ventiltype ~
ms_shuntventil_i_leveranse tillegg_montasje tillegg_kapsling system_kode ~
lblVentilType 
&Scoped-Define DISPLAYED-OBJECTS systemnr systembetegnelse ~
koblings_alternativ anvendelse ventil_type prim_konst_var reguleringsventil ~
sek_konst_var beregnet_anvendelse sek_effekt prim_effekt sek_temp_inn ~
prim_temp_inn sek_temp_ut prim_temp_ut sek_kapasitet prim_kapasitet ~
ms_ventiltype ms_shuntventil_i_leveranse shunt_dimmensjon tillegg_montasje ~
tillegg_kapsling system_kode lblVentilType 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPSHSYST 
     IMAGE-UP FILE "bmp/table.bmp":U
     LABEL "Column setup" 
     SIZE 7.75 BY 1.94 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON btnReset 
     LABEL "&Reset" 
     SIZE 10.38 BY 1.13.

DEFINE BUTTON copy_tbNPSHSYST 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Kopier" 
     SIZE 7.75 BY 1.94 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON delete_tbNPSHSYST 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 7.75 BY 1.94 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON edit_tbNPSHSYST 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 7.75 BY 1.94 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON excel_tbNPSHSYST 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 7.75 BY 1.94 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbNPSHSYST 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 7.75 BY 1.94 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNPSHSYST 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 7.75 BY 1.94 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON refresh_tbNPSHSYST 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 7.75 BY 1.94 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPSHSYST 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 7.75 BY 1.94 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbNPSHSYST 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Angre" 
     SIZE 7.75 BY 1.94 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE koblings_alternativ AS CHARACTER FORMAT "X(2)" INITIAL "1" 
     LABEL "Kobl.alt." 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEM-PAIRS "1","1"
     DROP-DOWN-LIST
     SIZE 7 BY 1.

DEFINE VARIABLE ms_ventiltype AS CHARACTER FORMAT "X(256)":U 
     LABEL "MS-Ventiltype" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "item1","item1"
     DROP-DOWN-LIST
     SIZE 20.38 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE anvendelse AS CHARACTER FORMAT "X(15)" INITIAL "Varme/Kjøle" 
     LABEL "Anvendelse" 
     VIEW-AS FILL-IN 
     SIZE 72 BY 1.

DEFINE VARIABLE lblVentilType AS CHARACTER FORMAT "X(256)":U INITIAL "Ventil:" 
      VIEW-AS TEXT 
     SIZE 7 BY .63 NO-UNDO.

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
     SIZE 26 BY 1.

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
     SIZE 26 BY 1.

DEFINE VARIABLE sek_temp_inn AS DECIMAL FORMAT "->>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE sek_temp_ut AS DECIMAL FORMAT "->>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1.

DEFINE VARIABLE shunt_dimmensjon AS CHARACTER FORMAT "X(3)" 
     LABEL "Shuntdimmensjon" 
     VIEW-AS FILL-IN 
     SIZE 7.63 BY 1.

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

DEFINE VARIABLE tillegg_fm_brakett_overgang AS CHARACTER FORMAT "X(256)":U 
     LABEL "tillegg_fm_brakett_overgang" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

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
     SIZE 39.38 BY 11.66.

DEFINE VARIABLE beregnet_anvendelse AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "item1", "item1"
     SIZE 35.75 BY 6.91.

DEFINE VARIABLE type AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "item1", "item1"
     SIZE 41 BY 1.25.

DEFINE RECTANGLE rectOppsett
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 7.38.

DEFINE RECTANGLE tbNPSHSYST
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 177 BY 2.13.

DEFINE VARIABLE ms_shuntventil_i_leveranse AS LOGICAL INITIAL no 
     LABEL "MS - Shuntventil med i leveranse" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHSYST FOR 
      NPSHSYST SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHSYST
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHSYST C-Win _STRUCTURED
  QUERY BrwNPSHSYST NO-LOCK DISPLAY
      NPSHSYST.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSHSYST.systemnr COLUMN-LABEL "Systemnr" FORMAT ">>>>>9":U
      NPSHSYST.systembetegnelse COLUMN-LABEL "Syst.bet." FORMAT "X(40)":U
      NPSHSYST.autoritet COLUMN-LABEL "Autoritet" FORMAT ">.9999":U
      NPSHSYST.beregnet_anvendelse COLUMN-LABEL "Anvendelse" FORMAT "X(18)":U
      NPSHSYST.fabrikat COLUMN-LABEL "fabrikat" FORMAT "X(2)":U
      NPSHSYST.forhaands_struping COLUMN-LABEL "Struping" FORMAT ">>9.99":U
      NPSHSYST.forhaands_struping_prim COLUMN-LABEL "Struping" FORMAT ">>9.99":U
      NPSHSYST.forhaands_struping_sek COLUMN-LABEL "Struping" FORMAT ">>9.99":U
      NPSHSYST.glykol COLUMN-LABEL "Glykol" FORMAT "X(10)":U
      NPSHSYST.inngaende_trykk COLUMN-LABEL "Inng. trykk" FORMAT ">>9.99":U
      NPSHSYST.koblings_alternativ COLUMN-LABEL "Kobl.alt." FORMAT "X(2)":U
      NPSHSYST.konsentrasjon COLUMN-LABEL "Kons." FORMAT "X(2)":U
      NPSHSYST.kvs_hovedport COLUMN-LABEL "KVS Hovedport" FORMAT ">9.99":U
      NPSHSYST.kvs_shuntport COLUMN-LABEL "KVS Shuntport" FORMAT ">9.99":U
      NPSHSYST.ledig_drivtrykk_prim COLUMN-LABEL "Ledig drivtrykk" FORMAT ">>9.99":U
      NPSHSYST.maks_pumpetrykk COLUMN-LABEL "Maks trykk" FORMAT ">>9.99":U
      NPSHSYST.med_i_ordre COLUMN-LABEL "Ordre" FORMAT "ja/nei":U
      NPSHSYST.minste_pumpetrykk COLUMN-LABEL "Min. pump." FORMAT ">>9.99":U
      NPSHSYST.minste_pumpetrykk_prim COLUMN-LABEL "Min. pump." FORMAT ">>9.99":U
      NPSHSYST.motstand_objekt COLUMN-LABEL "Motst. obj." FORMAT ">>9.99":U
      NPSHSYST.motstand_objekt_avtrekk COLUMN-LABEL "Motstand objekt, avtrekk" FORMAT ">>9.99":U
      NPSHSYST.motstand_objekt_innblaasning COLUMN-LABEL "Motstand objekt, innblåsning" FORMAT ">>9.99":U
      NPSHSYST.motstand_prim_krets COLUMN-LABEL "Motst. prim. krets" FORMAT ">>9.99":U
      NPSHSYST.motstand_ror_bend COLUMN-LABEL "Motst. rør/bend" FORMAT ">>9.99":U
      NPSHSYST.motstand_ror_bend_avtrekk COLUMN-LABEL "Motstand rør/bend etc., avtrekk" FORMAT ">>9.99":U
      NPSHSYST.motstand_ror_bend_innblaasning COLUMN-LABEL "Motstand rør/bend etc., innblåsning" FORMAT ">>9.99":U
      NPSHSYST.motstand_ror_bend_prim COLUMN-LABEL "Motst. rør/bend etc." FORMAT ">>9.99":U
      NPSHSYST.motstand_ror_bend_sek COLUMN-LABEL "Motst. rør/bend etc." FORMAT ">>9.99":U
      NPSHSYST.motstand_sek_krets COLUMN-LABEL "Motst. sek. krets" FORMAT ">>9.99":U
      NPSHSYST.motstand_strupeventil COLUMN-LABEL "Motst. str. vent." FORMAT ">>9.99":U
      NPSHSYST.motstand_strupeventil_prim COLUMN-LABEL "Motst. str. vent." FORMAT ">>9.99":U
      NPSHSYST.motstand_strupeventil_sek COLUMN-LABEL "Motst. str. vent." FORMAT ">>9.99":U
      NPSHSYST.ms_automatikk_fabrikat COLUMN-LABEL "Aut.fabr." FORMAT "X(3)":U
      NPSHSYST.ms_shuntventil_i_leveranse COLUMN-LABEL "Shuntventil med" FORMAT "ja/nei":U
      NPSHSYST.ms_ventiltype COLUMN-LABEL "Ventiltype" FORMAT "X(20)":U
      NPSHSYST.ny_record COLUMN-LABEL "ny_record" FORMAT "ja/nei":U
      NPSHSYST.prim_effekt COLUMN-LABEL "Effekt" FORMAT ">>>>>>9":U
      NPSHSYST.prim_hastighet COLUMN-LABEL "prim_hastighet" FORMAT ">>9.999999":U
      NPSHSYST.prim_kapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSHSYST.prim_temp_inn COLUMN-LABEL "Temp. inn" FORMAT "->>9.99":U
      NPSHSYST.prim_temp_ut COLUMN-LABEL "Temp. ut" FORMAT "->>9.99":U
      NPSHSYST.prod_nr COLUMN-LABEL "Prod.nr." FORMAT "X(18)":U
      NPSHSYST.sek_effekt COLUMN-LABEL "Effekt" FORMAT ">>>>>>9":U
      NPSHSYST.sek_hastighet COLUMN-LABEL "sek_hastighet" FORMAT ">>9.999999":U
      NPSHSYST.sek_kapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSHSYST.sek_temp_inn COLUMN-LABEL "Temp. inn" FORMAT "->>9.99":U
      NPSHSYST.sek_temp_ut COLUMN-LABEL "Temp. ut" FORMAT "->>9.99":U
      NPSHSYST.shunthus_varenr COLUMN-LABEL "Vnr.shunthus" FORMAT "X(8)":U
      NPSHSYST.shuntkvs_varenr COLUMN-LABEL "Vnr.shuntkvs" FORMAT "X(8)":U
      NPSHSYST.shunt_dimmensjon COLUMN-LABEL "Shunt-dimm." FORMAT "X(3)":U
      NPSHSYST.shunt_dimmensjon_num COLUMN-LABEL "shunt_dimmensjon_num" FORMAT ">99":U
      NPSHSYST.sikkerhet COLUMN-LABEL "Sikkerhet" FORMAT ">>9.99":U
      NPSHSYST.standardpris COLUMN-LABEL "Standardpris" FORMAT ">>,>>>,>>9.99":U
      NPSHSYST.strupe_dimmensjon_prim COLUMN-LABEL "strupe_dimmensjon_prim" FORMAT "X(8)":U
      NPSHSYST.strupe_dimmensjon_sek COLUMN-LABEL "strupe_dimmensjon_sek" FORMAT "X(8)":U
      NPSHSYST.system_kode COLUMN-LABEL "Kode" FORMAT "X(255)":U
      NPSHSYST.tegning_bmp COLUMN-LABEL "tegning_bmp" FORMAT "X(30)":U
      NPSHSYST.tillegg COLUMN-LABEL "Tillegg" FORMAT ">9.9":U
      NPSHSYST.tillegg_brakett_overgang COLUMN-LABEL "Motor brakett/overg." FORMAT "X(25)":U
      NPSHSYST.tillegg_ekspansjonskar COLUMN-LABEL "Ekspansjonskar" FORMAT "ja/nei":U
      NPSHSYST.tillegg_el_amp COLUMN-LABEL "El-data,ampère" FORMAT "X(8)":U
      NPSHSYST.tillegg_el_hz COLUMN-LABEL "El-data,hz" FORMAT "X(4)":U
      NPSHSYST.tillegg_el_volt COLUMN-LABEL "El-data,volt" FORMAT "X(6)":U
      NPSHSYST.tillegg_ferdigkoblet_prim COLUMN-LABEL "Ferdigkobl.prim." FORMAT "ja/nei":U
      NPSHSYST.tillegg_ferdigkoblet_sek COLUMN-LABEL "Ferdigkobl.sek" FORMAT "ja/nei":U
      NPSHSYST.tillegg_fm_brakett_overgang COLUMN-LABEL "Motor brakett/overg." FORMAT "X(25)":U
      NPSHSYST.tillegg_forstilling COLUMN-LABEL "Forst.org." FORMAT "X(30)":U
      NPSHSYST.tillegg_frekv_styr_innkl COLUMN-LABEL "Frekv. styr. innkl." FORMAT "ja/nei":U
      NPSHSYST.tillegg_gulvstativ COLUMN-LABEL "Gulvst." FORMAT "ja/nei":U
      NPSHSYST.tillegg_kapsling COLUMN-LABEL "Kapsling" FORMAT "X(25)":U
      NPSHSYST.tillegg_kuleventil_fabrikat_prim COLUMN-LABEL "tillegg_kuleventil_fabrikat_prim" FORMAT "X(20)":U
      NPSHSYST.tillegg_kuleventil_fabrikat_sek COLUMN-LABEL "tillegg_kuleventil_fabrikat_sek" FORMAT "X(20)":U
      NPSHSYST.tillegg_kuleventil_prim COLUMN-LABEL "Kuleventil" FORMAT "ja/nei":U
      NPSHSYST.tillegg_kuleventil_sek COLUMN-LABEL "Kuleventil" FORMAT "ja/nei":U
      NPSHSYST.tillegg_kuleventil_vnr_prim COLUMN-LABEL "tillegg_kuleventil_vnr_prim" FORMAT "X(8)":U
      NPSHSYST.tillegg_kuleventil_vnr_sek COLUMN-LABEL "tillegg_kuleventil_vnr_sek" FORMAT "X(8)":U
      NPSHSYST.tillegg_kw COLUMN-LABEL "kW" FORMAT ">9.99":U
      NPSHSYST.tillegg_montasje COLUMN-LABEL "Montasje" FORMAT "X(12)":U
      NPSHSYST.tillegg_ms_brakett_overgang COLUMN-LABEL "Motor brakett/overg." FORMAT "X(25)":U
      NPSHSYST.tillegg_pumpetype COLUMN-LABEL "Pumpe Type" FORMAT "X(10)":U
      NPSHSYST.tillegg_pumpe_betegnelse COLUMN-LABEL "Pumpe betegnelse" FORMAT "X(15)":U
      NPSHSYST.tillegg_pumpe_fabrikat COLUMN-LABEL "Pumpe fabrikat" FORMAT "X(16)":U
      NPSHSYST.tillegg_pumpe_type COLUMN-LABEL "Pumpe type" FORMAT "X(10)":U
      NPSHSYST.tillegg_spjeldventil_fabrikat_pr COLUMN-LABEL "tillegg_spjeldventil_fabrikat_pr" FORMAT "X(20)":U
      NPSHSYST.tillegg_spjeldventil_fabrikat_se COLUMN-LABEL "tillegg_spjeldventil_fabrikat_se" FORMAT "X(20)":U
      NPSHSYST.tillegg_spjeldventil_prim COLUMN-LABEL "Spjeldventil" FORMAT "ja/nei":U
      NPSHSYST.tillegg_spjeldventil_sek COLUMN-LABEL "Spjeldventil" FORMAT "ja/nei":U
      NPSHSYST.tillegg_spjeldventil_vnr_prim COLUMN-LABEL "tillegg_spjeldventil_vnr_prim" FORMAT "X(8)":U
      NPSHSYST.tillegg_spjeldventil_vnr_sek COLUMN-LABEL "tillegg_spjeldventil_vnr_sek" FORMAT "X(8)":U
      NPSHSYST.tillegg_stengeventil COLUMN-LABEL "Stengev." FORMAT "X(5)":U
      NPSHSYST.tillegg_stengeventil_type_prim COLUMN-LABEL "tillegg_stengeventil_type_prim" FORMAT "X(6)":U
      NPSHSYST.tillegg_stengeventil_type_sek COLUMN-LABEL "tillegg_stengeventil_type_sek" FORMAT "X(6)":U
      NPSHSYST.tillegg_strupe COLUMN-LABEL "Strupev." FORMAT "ja/nei":U
      NPSHSYST.trykk_for_shunt_ventil COLUMN-LABEL "Trykk før shuntventil" FORMAT ">>9.99":U
      NPSHSYST.type COLUMN-LABEL "Type" FORMAT "X(2)":U
      NPSHSYST.ventilmotstand COLUMN-LABEL "Ønsk. vent. motst." FORMAT ">>9.99":U
      NPSHSYST.ventilmotstand_port_2-1 COLUMN-LABEL "Ventilmotstand port 2-1" FORMAT ">>9.99":U
      NPSHSYST.ventilmotstand_port_2-1_prim COLUMN-LABEL "Ventilmotstand port 2-1" FORMAT ">>9.99":U
      NPSHSYST.ventilmotstand_port_2-1_sek COLUMN-LABEL "Ventilmotstand port 2-1" FORMAT ">>9.99":U
      NPSHSYST.ventilmotstand_port_3-1 COLUMN-LABEL "Ventilmotstand port 3-1" FORMAT ">>9.99":U
      NPSHSYST.ventilmotstand_port_3-1_prim COLUMN-LABEL "Ventilmotstand port 3-1" FORMAT ">>9.99":U
      NPSHSYST.ventilmotstand_port_3-1_sek COLUMN-LABEL "Ventilmotstand port 3-1" FORMAT ">>9.99":U
      NPSHSYST.ventil_blande_fordeling COLUMN-LABEL "ventil_blande_fordeling" FORMAT "X(18)":U
      NPSHSYST.ventil_karakteristikk_hoved COLUMN-LABEL "ventil_karakteristikk_hoved" FORMAT "X(3)":U
      NPSHSYST.ventil_karakteristikk_shunt COLUMN-LABEL "ventil_karakteristikk_shunt" FORMAT "X(3)":U
      NPSHSYST.ventil_type COLUMN-LABEL "Ventil type" FORMAT "X(8)":U
  ENABLE
      NPSHSYST.anleggsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 39 BY 28.75 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHSYST AT ROW 1.09 COL 1.13 WIDGET-ID 4
     edit_tbNPSHSYST AT ROW 1.09 COL 9 WIDGET-ID 6
     copy_tbNPSHSYST AT ROW 1.09 COL 16.88 WIDGET-ID 8
     undo_tbNPSHSYST AT ROW 1.09 COL 24.75 WIDGET-ID 10
     save_tbNPSHSYST AT ROW 1.09 COL 32.75 WIDGET-ID 12
     delete_tbNPSHSYST AT ROW 1.09 COL 40.63 WIDGET-ID 14
     refresh_tbNPSHSYST AT ROW 1.09 COL 48.5 WIDGET-ID 16
     filter_tbNPSHSYST AT ROW 1.09 COL 56.38 WIDGET-ID 18
     browseconfig_tbNPSHSYST AT ROW 1.09 COL 64.25 WIDGET-ID 20
     excel_tbNPSHSYST AT ROW 1.09 COL 72.25 WIDGET-ID 22
     BrwNPSHSYST AT ROW 3.25 COL 2 WIDGET-ID 200
     systemnr AT ROW 3.25 COL 57 COLON-ALIGNED
     systembetegnelse AT ROW 3.25 COL 68 COLON-ALIGNED NO-LABEL
     koblings_alternativ AT ROW 3.25 COL 112 COLON-ALIGNED WIDGET-ID 92
     anvendelse AT ROW 4.75 COL 57 COLON-ALIGNED
     ventil_type AT ROW 6 COL 57 COLON-ALIGNED
     prim_konst_var AT ROW 6 COL 103 COLON-ALIGNED
     reguleringsventil AT ROW 7 COL 57 COLON-ALIGNED
     sek_konst_var AT ROW 7 COL 103 COLON-ALIGNED
     beregnet_anvendelse AT ROW 8.75 COL 99 NO-LABEL WIDGET-ID 72
     sek_effekt AT ROW 9.91 COL 70.75 COLON-ALIGNED NO-LABEL
     prim_effekt AT ROW 9.94 COL 56.38 COLON-ALIGNED
     sek_temp_inn AT ROW 10.94 COL 70.75 COLON-ALIGNED NO-LABEL
     prim_temp_inn AT ROW 11 COL 56.38 COLON-ALIGNED
     sek_temp_ut AT ROW 12.03 COL 70.75 COLON-ALIGNED NO-LABEL
     prim_temp_ut AT ROW 12.09 COL 56.38 COLON-ALIGNED
     sek_kapasitet AT ROW 13.09 COL 70.75 COLON-ALIGNED NO-LABEL
     prim_kapasitet AT ROW 13.13 COL 56.38 COLON-ALIGNED
     btnReset AT ROW 14.47 COL 80 WIDGET-ID 88
     type AT ROW 17.25 COL 47 NO-LABEL WIDGET-ID 76
     ms_ventiltype AT ROW 18.75 COL 57 COLON-ALIGNED WIDGET-ID 84
     ms_shuntventil_i_leveranse AT ROW 18.75 COL 83 WIDGET-ID 74
     shunt_dimmensjon AT ROW 19.75 COL 57 COLON-ALIGNED
     tillegg_montasje AT ROW 23.75 COL 57 COLON-ALIGNED
     tillegg_kapsling AT ROW 24.72 COL 57 COLON-ALIGNED
     system_kode AT ROW 25.66 COL 57 COLON-ALIGNED
     tillegg_fm_brakett_overgang AT ROW 27.25 COL 154 COLON-ALIGNED
     lblVentilType AT ROW 16.5 COL 44 COLON-ALIGNED NO-LABEL
     " Primær" VIEW-AS TEXT
          SIZE 10.75 BY .66 AT ROW 9.13 COL 58.38 WIDGET-ID 54
     "W" VIEW-AS TEXT
          SIZE 4.38 BY .66 AT ROW 10.03 COL 85.38 WIDGET-ID 56
     "°C" VIEW-AS TEXT
          SIZE 5.75 BY .66 AT ROW 11.03 COL 85.38 WIDGET-ID 58
     "°C" VIEW-AS TEXT
          SIZE 5.63 BY .66 AT ROW 12.31 COL 85 WIDGET-ID 60
     "l/s" VIEW-AS TEXT
          SIZE 6.25 BY .63 AT ROW 13.38 COL 85 WIDGET-ID 62
     " Sekundær" VIEW-AS TEXT
          SIZE 15 BY .66 AT ROW 9.03 COL 72.75 WIDGET-ID 52
     tbNPSHSYST AT ROW 1 COL 1 WIDGET-ID 2
     rectOppsett AT ROW 8.5 COL 46 WIDGET-ID 42
     SHUNTTEGNING AT ROW 8.25 COL 136 WIDGET-ID 70
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 177.5 BY 31.09 WIDGET-ID 100.


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
         HEIGHT             = 31.09
         WIDTH              = 177.5
         MAX-HEIGHT         = 31.09
         MAX-WIDTH          = 177.5
         VIRTUAL-HEIGHT     = 31.09
         VIRTUAL-WIDTH      = 177.5
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
&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
  IF C-Win = ? THEN
    CREATE FRAME C-Win
           ASSIGN HIDDEN = YES.
&ENDIF

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
/* BROWSE-TAB BrwNPSHSYST excel_tbNPSHSYST DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 31.09
       FRAME DEFAULT-FRAME:WIDTH            = 177.5.

/* SETTINGS FOR FILL-IN anvendelse IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       anvendelse:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       NPSHSYST.autoritet:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.beregnet_anvendelse:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.fabrikat:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.forhaands_struping:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.forhaands_struping_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.forhaands_struping_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.glykol:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.inngaende_trykk:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.koblings_alternativ:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.konsentrasjon:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.kvs_hovedport:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.kvs_shuntport:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ledig_drivtrykk_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.maks_pumpetrykk:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.med_i_ordre:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.minste_pumpetrykk:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.minste_pumpetrykk_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_objekt:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_objekt_avtrekk:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_objekt_innblaasning:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_prim_krets:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_ror_bend:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_ror_bend_avtrekk:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_ror_bend_innblaasning:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_ror_bend_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_ror_bend_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_sek_krets:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_strupeventil:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_strupeventil_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.motstand_strupeventil_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ms_automatikk_fabrikat:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ms_shuntventil_i_leveranse:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ms_ventiltype:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ny_record:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.prim_effekt:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.prim_hastighet:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.prim_kapasitet:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.prim_temp_inn:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.prim_temp_ut:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.prod_nr:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.sek_effekt:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.sek_hastighet:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.sek_kapasitet:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.sek_temp_inn:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.sek_temp_ut:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.shunthus_varenr:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.shuntkvs_varenr:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.shunt_dimmensjon:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.shunt_dimmensjon_num:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.sikkerhet:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.standardpris:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.strupe_dimmensjon_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.strupe_dimmensjon_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.system_kode:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tegning_bmp:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_brakett_overgang:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_ekspansjonskar:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_el_amp:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_el_hz:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_el_volt:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_ferdigkoblet_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_ferdigkoblet_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_fm_brakett_overgang:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_forstilling:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_frekv_styr_innkl:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_gulvstativ:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_kapsling:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_kuleventil_fabrikat_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_kuleventil_fabrikat_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_kuleventil_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_kuleventil_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_kuleventil_vnr_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_kuleventil_vnr_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_kw:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_montasje:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_ms_brakett_overgang:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_pumpetype:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_pumpe_betegnelse:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_pumpe_fabrikat:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_pumpe_type:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_spjeldventil_fabrikat_pr:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_spjeldventil_fabrikat_se:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_spjeldventil_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_spjeldventil_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_spjeldventil_vnr_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_spjeldventil_vnr_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_stengeventil:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_stengeventil_type_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_stengeventil_type_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.tillegg_strupe:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.trykk_for_shunt_ventil:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.type:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventilmotstand:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventilmotstand_port_2-1:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventilmotstand_port_2-1_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventilmotstand_port_2-1_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventilmotstand_port_3-1:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventilmotstand_port_3-1_prim:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventilmotstand_port_3-1_sek:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventil_blande_fordeling:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventil_karakteristikk_hoved:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventil_karakteristikk_shunt:VISIBLE IN BROWSE BrwNPSHSYST = FALSE
       NPSHSYST.ventil_type:VISIBLE IN BROWSE BrwNPSHSYST = FALSE.

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
ASSIGN 
       tbNPSHSYST:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,edit;Edit,copy;Kopier,undo;Angre,save;Lagre,delete;Slett,refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Eksporter til E&xcelmaxborder".

/* SETTINGS FOR FILL-IN tillegg_fm_brakett_overgang IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tillegg_fm_brakett_overgang:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

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


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHSYST
/* Query rebuild information for BROWSE BrwNPSHSYST
     _TblList          = "norcalc.NPSHSYST"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSHSYST.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHSYST.systemnr" "Systemnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "8.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHSYST.systembetegnelse" "Syst.bet." "X(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHSYST.autoritet" "Autoritet" ">.9999" "decimal" ? ? ? ? ? ? no "" no no "7.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSHSYST.beregnet_anvendelse" "Anvendelse" "X(18)" "character" ? ? ? ? ? ? no "Velg anvendelsesområde" no no "18" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSHSYST.fabrikat" "fabrikat" "X(2)" "character" ? ? ? ? ? ? no "" no no "6.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSHSYST.forhaands_struping" "Struping" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSHSYST.forhaands_struping_prim" "Struping" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSHSYST.forhaands_struping_sek" "Struping" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSHSYST.glykol" "Glykol" "X(10)" "character" ? ? ? ? ? ? no "Velg glykoltype" no no "10" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSHSYST.inngaende_trykk" "Inng. trykk" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "9.13" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSHSYST.koblings_alternativ" "Kobl.alt." "X(2)" "character" ? ? ? ? ? ? no "" no no "7" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSHSYST.konsentrasjon" "Kons." "X(2)" "character" ? ? ? ? ? ? no "Oppgi glykol konsentrasjon" no no "5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPSHSYST.kvs_hovedport" "KVS Hovedport" ">9.99" "decimal" ? ? ? ? ? ? no "" no no "13.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPSHSYST.kvs_shuntport" "KVS Shuntport" ">9.99" "decimal" ? ? ? ? ? ? no "" no no "13.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPSHSYST.ledig_drivtrykk_prim" "Ledig drivtrykk" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "12.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPSHSYST.maks_pumpetrykk" "Maks trykk" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "9.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"NPSHSYST.med_i_ordre" "Ordre" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"NPSHSYST.minste_pumpetrykk" "Min. pump." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "9.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"NPSHSYST.minste_pumpetrykk_prim" "Min. pump." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "9.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"NPSHSYST.motstand_objekt" "Motst. obj." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "9.13" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"NPSHSYST.motstand_objekt_avtrekk" "Motstand objekt, avtrekk" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "21.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > "_<CALC>"
"NPSHSYST.motstand_objekt_innblaasning" "Motstand objekt, innblåsning" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "25.25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > "_<CALC>"
"NPSHSYST.motstand_prim_krets" "Motst. prim. krets" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "15.13" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > "_<CALC>"
"NPSHSYST.motstand_ror_bend" "Motst. rør/bend" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > "_<CALC>"
"NPSHSYST.motstand_ror_bend_avtrekk" "Motstand rør/bend etc., avtrekk" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "27.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > "_<CALC>"
"NPSHSYST.motstand_ror_bend_innblaasning" "Motstand rør/bend etc., innblåsning" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "31" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > "_<CALC>"
"NPSHSYST.motstand_ror_bend_prim" "Motst. rør/bend etc." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "17.13" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > "_<CALC>"
"NPSHSYST.motstand_ror_bend_sek" "Motst. rør/bend etc." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "17.13" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > "_<CALC>"
"NPSHSYST.motstand_sek_krets" "Motst. sek. krets" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "14.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > "_<CALC>"
"NPSHSYST.motstand_strupeventil" "Motst. str. vent." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > "_<CALC>"
"NPSHSYST.motstand_strupeventil_prim" "Motst. str. vent." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > "_<CALC>"
"NPSHSYST.motstand_strupeventil_sek" "Motst. str. vent." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > "_<CALC>"
"NPSHSYST.ms_automatikk_fabrikat" "Aut.fabr." "X(3)" "character" ? ? ? ? ? ? no "" no no "7.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > "_<CALC>"
"NPSHSYST.ms_shuntventil_i_leveranse" "Shuntventil med" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "14.25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   > "_<CALC>"
"NPSHSYST.ms_ventiltype" "Ventiltype" "X(20)" "character" ? ? ? ? ? ? no "" no no "20" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[37]   > "_<CALC>"
"NPSHSYST.ny_record" "ny_record" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "8.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[38]   > "_<CALC>"
"NPSHSYST.prim_effekt" "Effekt" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "7.88" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[39]   > "_<CALC>"
"NPSHSYST.prim_hastighet" "prim_hastighet" ">>9.999999" "decimal" ? ? ? ? ? ? no "" no no "13.13" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[40]   > "_<CALC>"
"NPSHSYST.prim_kapasitet" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[41]   > "_<CALC>"
"NPSHSYST.prim_temp_inn" "Temp. inn" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[42]   > "_<CALC>"
"NPSHSYST.prim_temp_ut" "Temp. ut" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[43]   > "_<CALC>"
"NPSHSYST.prod_nr" "Prod.nr." "X(18)" "character" ? ? ? ? ? ? no "" no no "18" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[44]   > "_<CALC>"
"NPSHSYST.sek_effekt" "Effekt" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "7.88" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[45]   > "_<CALC>"
"NPSHSYST.sek_hastighet" "sek_hastighet" ">>9.999999" "decimal" ? ? ? ? ? ? no "" no no "12.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[46]   > "_<CALC>"
"NPSHSYST.sek_kapasitet" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[47]   > "_<CALC>"
"NPSHSYST.sek_temp_inn" "Temp. inn" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[48]   > "_<CALC>"
"NPSHSYST.sek_temp_ut" "Temp. ut" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[49]   > "_<CALC>"
"NPSHSYST.shunthus_varenr" "Vnr.shunthus" "X(8)" "character" ? ? ? ? ? ? no "" no no "11.88" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[50]   > "_<CALC>"
"NPSHSYST.shuntkvs_varenr" "Vnr.shuntkvs" "X(8)" "character" ? ? ? ? ? ? no "" no no "11.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[51]   > "_<CALC>"
"NPSHSYST.shunt_dimmensjon" "Shunt-dimm." "X(3)" "character" ? ? ? ? ? ? no "" no no "11.25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[52]   > "_<CALC>"
"NPSHSYST.shunt_dimmensjon_num" "shunt_dimmensjon_num" ">99" "integer" ? ? ? ? ? ? no "" no no "21.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[53]   > "_<CALC>"
"NPSHSYST.sikkerhet" "Sikkerhet" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[54]   > "_<CALC>"
"NPSHSYST.standardpris" "Standardpris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "12.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[55]   > "_<CALC>"
"NPSHSYST.strupe_dimmensjon_prim" "strupe_dimmensjon_prim" "X(8)" "character" ? ? ? ? ? ? no "" no no "22.25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[56]   > "_<CALC>"
"NPSHSYST.strupe_dimmensjon_sek" "strupe_dimmensjon_sek" "X(8)" "character" ? ? ? ? ? ? no "" no no "21.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[57]   > "_<CALC>"
"NPSHSYST.system_kode" "Kode" "X(255)" "character" ? ? ? ? ? ? no "" no no "255" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[58]   > "_<CALC>"
"NPSHSYST.tegning_bmp" "tegning_bmp" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[59]   > "_<CALC>"
"NPSHSYST.tillegg" "Tillegg" ">9.9" "decimal" ? ? ? ? ? ? no "" no no "5.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[60]   > "_<CALC>"
"NPSHSYST.tillegg_brakett_overgang" "Motor brakett/overg." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[61]   > "_<CALC>"
"NPSHSYST.tillegg_ekspansjonskar" "Ekspansjonskar" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "14.13" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[62]   > "_<CALC>"
"NPSHSYST.tillegg_el_amp" "El-data,ampère" "X(8)" "character" ? ? ? ? ? ? no "" no no "13.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[63]   > "_<CALC>"
"NPSHSYST.tillegg_el_hz" "El-data,hz" "X(4)" "character" ? ? ? ? ? ? no "" no no "9" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[64]   > "_<CALC>"
"NPSHSYST.tillegg_el_volt" "El-data,volt" "X(6)" "character" ? ? ? ? ? ? no "" no no "9.88" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[65]   > "_<CALC>"
"NPSHSYST.tillegg_ferdigkoblet_prim" "Ferdigkobl.prim." "ja/nei" "logical" ? ? ? ? ? ? no "" no no "14" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[66]   > "_<CALC>"
"NPSHSYST.tillegg_ferdigkoblet_sek" "Ferdigkobl.sek" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "12.88" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[67]   > "_<CALC>"
"NPSHSYST.tillegg_fm_brakett_overgang" "Motor brakett/overg." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[68]   > "_<CALC>"
"NPSHSYST.tillegg_forstilling" "Forst.org." "X(30)" "character" ? ? ? ? ? ? no "" no no "30" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[69]   > "_<CALC>"
"NPSHSYST.tillegg_frekv_styr_innkl" "Frekv. styr. innkl." "ja/nei" "logical" ? ? ? ? ? ? no "" no no "14.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[70]   > "_<CALC>"
"NPSHSYST.tillegg_gulvstativ" "Gulvst." "ja/nei" "logical" ? ? ? ? ? ? no "" no no "6.13" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[71]   > "_<CALC>"
"NPSHSYST.tillegg_kapsling" "Kapsling" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[72]   > "_<CALC>"
"NPSHSYST.tillegg_kuleventil_fabrikat_prim" "tillegg_kuleventil_fabrikat_prim" "X(20)" "character" ? ? ? ? ? ? no "" no no "27" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[73]   > "_<CALC>"
"NPSHSYST.tillegg_kuleventil_fabrikat_sek" "tillegg_kuleventil_fabrikat_sek" "X(20)" "character" ? ? ? ? ? ? no "" no no "26.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[74]   > "_<CALC>"
"NPSHSYST.tillegg_kuleventil_prim" "Kuleventil" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "8.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[75]   > "_<CALC>"
"NPSHSYST.tillegg_kuleventil_sek" "Kuleventil" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "8.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[76]   > "_<CALC>"
"NPSHSYST.tillegg_kuleventil_vnr_prim" "tillegg_kuleventil_vnr_prim" "X(8)" "character" ? ? ? ? ? ? no "" no no "23" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[77]   > "_<CALC>"
"NPSHSYST.tillegg_kuleventil_vnr_sek" "tillegg_kuleventil_vnr_sek" "X(8)" "character" ? ? ? ? ? ? no "" no no "22.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[78]   > "_<CALC>"
"NPSHSYST.tillegg_kw" "kW" ">9.99" "decimal" ? ? ? ? ? ? no "" no no "5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[79]   > "_<CALC>"
"NPSHSYST.tillegg_montasje" "Montasje" "X(12)" "character" ? ? ? ? ? ? no "" no no "12" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[80]   > "_<CALC>"
"NPSHSYST.tillegg_ms_brakett_overgang" "Motor brakett/overg." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[81]   > "_<CALC>"
"NPSHSYST.tillegg_pumpetype" "Pumpe Type" "X(10)" "character" ? ? ? ? ? ? no "" no no "11" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[82]   > "_<CALC>"
"NPSHSYST.tillegg_pumpe_betegnelse" "Pumpe betegnelse" "X(15)" "character" ? ? ? ? ? ? no "" no no "16.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[83]   > "_<CALC>"
"NPSHSYST.tillegg_pumpe_fabrikat" "Pumpe fabrikat" "X(16)" "character" ? ? ? ? ? ? no "" no no "16" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[84]   > "_<CALC>"
"NPSHSYST.tillegg_pumpe_type" "Pumpe type" "X(10)" "character" ? ? ? ? ? ? no "" no no "10.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[85]   > "_<CALC>"
"NPSHSYST.tillegg_spjeldventil_fabrikat_pr" "tillegg_spjeldventil_fabrikat_pr" "X(20)" "character" ? ? ? ? ? ? no "" no no "26.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[86]   > "_<CALC>"
"NPSHSYST.tillegg_spjeldventil_fabrikat_se" "tillegg_spjeldventil_fabrikat_se" "X(20)" "character" ? ? ? ? ? ? no "" no no "26.88" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[87]   > "_<CALC>"
"NPSHSYST.tillegg_spjeldventil_prim" "Spjeldventil" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "10" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[88]   > "_<CALC>"
"NPSHSYST.tillegg_spjeldventil_sek" "Spjeldventil" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "10" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[89]   > "_<CALC>"
"NPSHSYST.tillegg_spjeldventil_vnr_prim" "tillegg_spjeldventil_vnr_prim" "X(8)" "character" ? ? ? ? ? ? no "" no no "24.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[90]   > "_<CALC>"
"NPSHSYST.tillegg_spjeldventil_vnr_sek" "tillegg_spjeldventil_vnr_sek" "X(8)" "character" ? ? ? ? ? ? no "" no no "23.88" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[91]   > "_<CALC>"
"NPSHSYST.tillegg_stengeventil" "Stengev." "X(5)" "character" ? ? ? ? ? ? no "" no no "7.88" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[92]   > "_<CALC>"
"NPSHSYST.tillegg_stengeventil_type_prim" "tillegg_stengeventil_type_prim" "X(6)" "character" ? ? ? ? ? ? no "" no no "26.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[93]   > "_<CALC>"
"NPSHSYST.tillegg_stengeventil_type_sek" "tillegg_stengeventil_type_sek" "X(6)" "character" ? ? ? ? ? ? no "" no no "26" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[94]   > "_<CALC>"
"NPSHSYST.tillegg_strupe" "Strupev." "ja/nei" "logical" ? ? ? ? ? ? no "" no no "7.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[95]   > "_<CALC>"
"NPSHSYST.trykk_for_shunt_ventil" "Trykk før shuntventil" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "17.5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[96]   > "_<CALC>"
"NPSHSYST.type" "Type" "X(2)" "character" ? ? ? ? ? ? no "" no no "4.25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[97]   > "_<CALC>"
"NPSHSYST.ventilmotstand" "Ønsk. vent. motst." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "15.88" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[98]   > "_<CALC>"
"NPSHSYST.ventilmotstand_port_2-1" "Ventilmotstand port 2-1" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "20.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[99]   > "_<CALC>"
"NPSHSYST.ventilmotstand_port_2-1_prim" "Ventilmotstand port 2-1" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "20.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[100]   > "_<CALC>"
"NPSHSYST.ventilmotstand_port_2-1_sek" "Ventilmotstand port 2-1" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "20.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[101]   > "_<CALC>"
"NPSHSYST.ventilmotstand_port_3-1" "Ventilmotstand port 3-1" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "20.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[102]   > "_<CALC>"
"NPSHSYST.ventilmotstand_port_3-1_prim" "Ventilmotstand port 3-1" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "20.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[103]   > "_<CALC>"
"NPSHSYST.ventilmotstand_port_3-1_sek" "Ventilmotstand port 3-1" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "20.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[104]   > "_<CALC>"
"NPSHSYST.ventil_blande_fordeling" "ventil_blande_fordeling" "X(18)" "character" ? ? ? ? ? ? no "" no no "20.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[105]   > "_<CALC>"
"NPSHSYST.ventil_karakteristikk_hoved" "ventil_karakteristikk_hoved" "X(3)" "character" ? ? ? ? ? ? no "Velg ventilkarakteristikk" no no "23.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[106]   > "_<CALC>"
"NPSHSYST.ventil_karakteristikk_shunt" "ventil_karakteristikk_shunt" "X(3)" "character" ? ? ? ? ? ? no "Velg ventilkarakteristikk" no no "23.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[107]   > "_<CALC>"
"NPSHSYST.ventil_type" "Ventil type" "X(8)" "character" ? ? ? ? ? ? no "Velg ventiltype" no no "9.25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHSYST */
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


&Scoped-define BROWSE-NAME BrwNPSHSYST
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
&ENDIF

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  RUN disable_UI.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
{incl/wintrigg.i}
{incl/conttrigg.i oBrwNPSHSYST:BROWSE-HANDLE}
&ENDIF

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
  DISPLAY systemnr systembetegnelse koblings_alternativ anvendelse ventil_type 
          prim_konst_var reguleringsventil sek_konst_var beregnet_anvendelse 
          sek_effekt prim_effekt sek_temp_inn prim_temp_inn sek_temp_ut 
          prim_temp_ut sek_kapasitet prim_kapasitet ms_ventiltype 
          ms_shuntventil_i_leveranse shunt_dimmensjon tillegg_montasje 
          tillegg_kapsling system_kode lblVentilType 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHSYST rectOppsett SHUNTTEGNING new_tbNPSHSYST edit_tbNPSHSYST 
         copy_tbNPSHSYST undo_tbNPSHSYST save_tbNPSHSYST delete_tbNPSHSYST 
         refresh_tbNPSHSYST filter_tbNPSHSYST browseconfig_tbNPSHSYST 
         excel_tbNPSHSYST BrwNPSHSYST systemnr systembetegnelse 
         koblings_alternativ beregnet_anvendelse sek_effekt prim_effekt 
         sek_temp_inn prim_temp_inn sek_temp_ut prim_temp_ut sek_kapasitet 
         prim_kapasitet btnReset type ms_ventiltype ms_shuntventil_i_leveranse 
         tillegg_montasje tillegg_kapsling system_kode lblVentilType 
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
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
&ENDIF

DO WITH FRAME {&FRAME-NAME}:
  oBrwNPSHSYST = NEW JBoxBrowse(brwNPSHSYST:HANDLE).
  oFmNPSHsyst  = new JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSHSYST:updateFields = 'systembetegnelse,koblings_alternativ,anvendelse,beregnet_anvendelse' 
                           + ',ms_shuntventil_i_leveranse,ms_ventiltype' 
                           + ',prim_effekt,prim_kapasitet,prim_konst_var,prim_temp_inn,prim_temp_ut,reguleringsventil' 
                           + ',sek_effekt,sek_kapasitet,sek_konst_var,sek_temp_inn,sek_temp_ut'
                           + ',shunt_dimmensjon,system_kode,tillegg_kapsling,tillegg_montasje,type,ventil_type'
                           .
  oFmNPSHSYST:displayFields = 'systemnr'.
  oFmNPSHSYST:bufferExtraFields = 'anleggsnr'.
  
  oFmNPSHSYST:BROWSE-OBJECT = oBrwNPSHSYST.
  
  otbNPSHSYST = NEW JBoxToolbar(tbNPSHSYST:HANDLE).

  oBrwNPSHSYST:TOOLBAR-OBJECT = otbNPSHSYST.
  oFmNPSHSYST:TOOLBAR-OBJECT  = otbNPSHSYST.
  
  assign 
    beregnet_anvendelse:DELIMITER = '|'
    beregnet_anvendelse:RADIO-BUTTONS = 'Varme|Varme|Lavtemperatur|Lavtemperatur|Lavtemp/Kaldt medium|Lavtemp/Kaldt medium|Kjøle|Kjøle|Frys|Frys|Varemegjenvinning|Varemegjenvinning'
    type:DELIMITER     = '|'
    type:RADIO-BUTTONS = 'FM|FM|MS|MS'
    .
END.
oBrwNPSHSYST:OpenQuery().

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:initResize().
&ELSE
  DYNAMIC-FUNCTION("setASlibBehaviour",
                    "QueryLogFile|ServerQuery.log," +   
                    "TransLogFile|ServerTrans.log").
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kontroll C-Win 
PROCEDURE kontroll :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  def var hChild as handle no-undo.
  def var oNorcalcData as oo.norcalcdata no-undo.
  
  do with frame {&frame-name}:
    if not type:MODIFIED then do:
      DEFINE VAR c_kapasitet as int no-undo.
      DEFINE VAR c_grunnlag AS CHARACTER.
  
      IF prim_kapasitet:INPUT-VALUE = 0 AND sek_kapasitet:INPUT-VALUE = 0 THEN DO:
        MESSAGE 'Shuntdimmensjon kan ikke beregnes når kapasitet er 0'
          view-as alert-box.
        APPLY "ENTRY" TO sek_effekt.
        RETURN NO-APPLY.
      END.
      CASE koblings_alternativ:SCREEN-VALUE:
        WHEN '5' OR WHEN '6' OR WHEN '7'  THEN 
          assign 
            c_kapasitet = DECIMAL(sek_kapasitet:SCREEN-VALUE)
            c_grunnlag = 'Sekundærkrets'.
        OTHERWISE
          assign
            c_kapasitet = DECIMAL(prim_kapasitet:SCREEN-VALUE)
            c_grunnlag = 'Primærkrets'.
      END CASE.
      dimm_verdi = 0.
      CASE type:SCREEN-VALUE:
        WHEN  'FM' THEN do:
          RUN velgNPSHGruppe.w persistent set hChild.
          if valid-handle(hChild) then do:
            run initializeObject in hChild.
            run MoveToTop in hChild.
            run setValues('FM',c_kapasitet,c_grunnlag).
          end.             
        end.          
        WHEN  'MS' THEN do:
          RUN velgNPSHGruppe.w persistent set hChild.
          if valid-handle(hChild) then do:
            run initializeObject in hChild.
            run MoveToTop in hChild.
            run setValues('FM',c_kapasitet,c_grunnlag).
          end.                       
        end.
        WHEN  'MSE' THEN do:
          RUN velgNPSHGruppe.w persistent set hChild.
          if valid-handle(hChild) then do:
            run initializeObject in hChild.
            run MoveToTop in hChild.
            run setValues('FM',c_kapasitet,c_grunnlag).
          end.             
        end.
      END CASE.
  
      ASSIGN
        shunt_dimmensjon:screen-value = string(dimm_verdi)
        type:modified = true
        .
  END.

  /* Dersom MS-Ventil er valgt, må ventiltype velges */
  IF type:SCREEN-VALUE = 'MS' AND ventil_type:SCREEN-VALUE = "" THEN 
    undo, throw new Progress.Lang.AppError('Når MS-Ventil er valgt, må også ventiltype velges',0). 

  /* Dersom MS-Ventil er valgt, skjekk om NPSHMKVS har denne kombinasjonen av 
    ventiltype og shuntdommensjon */
  IF type:SCREEN-VALUE = 'MS' THEN DO:
  if not jboxserverapi:Instance:Find('npshmkvs',substitute('where ventiltype = "&1" and shunt_dimmensjon = "&2"',ventil_type:screen-value,dimm_verdi)) then
    undo, throw new Progress.Lang.AppError(substitute('I beregningdata er det ikke definert KVS- verdi for ventiltype: &1 med dimmensjon &2',ventil_type:screen-value,dimm_verdi),0).

/*   ASSIGN                                                                        */
/*     NPSHSYST.systembetegnelse NPSHSYST.koblings_alternativ                      */
/*        NPSHSYST.prim_effekt                                                     */
/*        NPSHSYST.sek_effekt NPSHSYST.beregnet_anvendelse                         */
/*        NPSHSYST.prim_temp_inn NPSHSYST.sek_temp_inn                             */
/*        NPSHSYST.prim_temp_ut NPSHSYST.sek_temp_ut                               */
/*        NPSHSYST.prim_kapasitet NPSHSYST.sek_kapasitet                           */
/*        NPSHSYST.type  NPSHSYST.ms_ventiltype = COMBO-BOX-VENTILTYPE:SCREEN-VALUE*/
/*        NPSHSYST.ms_shuntventil_i_leveranse                                      */
/*        NPSHSYST.shunt_dimmensjon_num = INTEGER(NPSHSYST.shunt_dimmensjon).      */
/* Beregn hastiget */

oNorcalcdata = new oo.Norcalcdata().
tillegg_fm_brakett_overgang = oNorcalcdata:getDimmOvergang(type:screen-value,shunt_dimmensjon:input-value).
/*RUN prc_hastighet.                                                          */
/*                                                                            */
/*/* Default verdier for tillegg */                                           */
/*IF type = 'FM' THEN DO:                                                     */
/*        CASE NPSHSYST.shunt_dimmensjon:                                     */
/*            WHEN '25' THEN                                                  */
/*                ASSIGN tillegg_fm_brakett_overgang = 'MB 23.5 Ø30/Ø10 SETT'.*/
/*            WHEN '50' THEN                                                  */
/*                ASSIGN tillegg_fm_brakett_overgang = 'MB 37.5 Ø30/Ø10 SETT'.*/
/*            WHEN '65' THEN                                                  */
/*                ASSIGN tillegg_fm_brakett_overgang = 'MB 56.0 Ø30/Ø10 SETT'.*/
/*        END CASE.                                                           */
/*    END.                                                                    */

 /* Default for kapsling */
tillegg_kapsling = oNorcalcData:getkapslingsAlternativ(beregnet_anvendelse:screen-value).  
/* beregnet_anvendelse:SCREEN-VALUE:                                  */
/*    WHEN  "Varme" OR WHEN "Lavtemperatur" THEN                      */
/*      ASSIGN tillegg_kapsling = "Kapsling-Rød front".               */
/*    WHEN  "Kjøle" OR WHEN "Fryse" THEN                              */
/*        ASSIGN NPSHSYST.tillegg_kapsling = "Kapsling-Blå front".    */
/*     WHEN "Varmegjenvinning" THEN                                   */
/*        ASSIGN NPSHSYST.tillegg_kapsling = "Kapsling-Grønn front".  */
/*     WHEN "Lavtemp/Kaldt medium" THEN                               */
/*        ASSIGN NPSHSYST.tillegg_kapsling = "Kapsling-Rød/Blå front".*/
/*END CASE.                                                           */

  
/* Fyll ut de felt som har data - resten med ?? */
DEFINE VAR c_kode AS CHAR.
/* Type */
IF  type:screen-value <> "" THEN
  c_kode = type:screen-value.
ELSE
  c_kode = '??'.
/* Dimm */
IF shunt_dimmensjon:screen-value <> "" THEN
  c_kode = c_kode  + TRIM(shunt_dimmensjon:screen-value).
ELSE
  c_kode = c_kode + '??'.
/* Legg til ventiltype ved MS */
IF type:screen-value = 'MS' THEN
  c_kode = c_kode + '/' + ms_ventiltype:screen-value.   
/* KVS Hovedport (2-1)  og ventilkarakteristikk */
IF kvs_hovedport > 0 THEN 
  assign 
    c_kode = c_kode + '-Kvs' + string(kvs_hovedport)
    c_kode = c_kode + ' ' + string(ventil_karakteristikk_hoved)
    .
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

  
end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDimmValue C-Win 
PROCEDURE setDimmValue :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
def input param ipDimmValue as dec no-undo.

Dimm_value = ipDimmValue. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBeregning C-Win 
PROCEDURE setBeregning :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
def input param ipKVShovedport as dec no-undo.
def input param ipventil_karakteristikk_hoved as dec no-undo.

assign 
  kvs_hovedport = ipKVShovedport
  ventil_karakteristikk_hoved = ipventil_karakteristikk_hoved
  . 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
