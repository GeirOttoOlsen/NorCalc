&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES NPSPVARELISTE
&Scoped-define FIRST-EXTERNAL-TABLE NPSPVARELISTE


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR NPSPVARELISTE.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSPVARELISTE.varenr NPSPVARELISTE.pris ~
NPSPVARELISTE.produktnavn NPSPVARELISTE.nrf_nr NPSPVARELISTE.ror_dim ~
NPSPVARELISTE.kv_verdi NPSPVARELISTE.anslutning NPSPVARELISTE.dimmensjon ~
NPSPVARELISTE.materialkvaliteter NPSPVARELISTE.innmat ~
NPSPVARELISTE.avstand_flotor NPSPVARELISTE.vegg_tykkelse ~
NPSPVARELISTE.kuleventil NPSPVARELISTE.H NPSPVARELISTE.H1 NPSPVARELISTE.H2 ~
NPSPVARELISTE.avt_plugg NPSPVARELISTE.hurtigventil NPSPVARELISTE.h_0 ~
NPSPVARELISTE.h_2 NPSPVARELISTE.l_lufteventil NPSPVARELISTE.L ~
NPSPVARELISTE.LF NPSPVARELISTE.h_1 NPSPVARELISTE.diameter ~
NPSPVARELISTE.df_diameter NPSPVARELISTE.volum NPSPVARELISTE.utv_volum ~
NPSPVARELISTE.vekt NPSPVARELISTE.kapasitet NPSPVARELISTE.hoyde ~
NPSPVARELISTE.bredde NPSPVARELISTE.dybde NPSPVARELISTE.max_trykk ~
NPSPVARELISTE.max_temp NPSPVARELISTE.service_plass_over ~
NPSPVARELISTE.service_plass_under NPSPVARELISTE.tegnings_ref ~
NPSPVARELISTE.fast_tekst 
&Scoped-define ENABLED-TABLES NPSPVARELISTE
&Scoped-define FIRST-ENABLED-TABLE NPSPVARELISTE
&Scoped-define DISPLAYED-TABLES NPSPVARELISTE
&Scoped-define FIRST-DISPLAYED-TABLE NPSPVARELISTE
&Scoped-Define ENABLED-OBJECTS RECT-37 
&Scoped-Define DISPLAYED-FIELDS NPSPVARELISTE.varenr NPSPVARELISTE.pris ~
NPSPVARELISTE.produktnavn NPSPVARELISTE.nrf_nr NPSPVARELISTE.ror_dim ~
NPSPVARELISTE.kv_verdi NPSPVARELISTE.anslutning NPSPVARELISTE.dimmensjon ~
NPSPVARELISTE.materialkvaliteter NPSPVARELISTE.innmat ~
NPSPVARELISTE.avstand_flotor NPSPVARELISTE.vegg_tykkelse ~
NPSPVARELISTE.kuleventil NPSPVARELISTE.H NPSPVARELISTE.H1 NPSPVARELISTE.H2 ~
NPSPVARELISTE.avt_plugg NPSPVARELISTE.hurtigventil NPSPVARELISTE.h_0 ~
NPSPVARELISTE.h_2 NPSPVARELISTE.l_lufteventil NPSPVARELISTE.L ~
NPSPVARELISTE.LF NPSPVARELISTE.h_1 NPSPVARELISTE.diameter ~
NPSPVARELISTE.df_diameter NPSPVARELISTE.volum NPSPVARELISTE.utv_volum ~
NPSPVARELISTE.vekt NPSPVARELISTE.kapasitet NPSPVARELISTE.hoyde ~
NPSPVARELISTE.bredde NPSPVARELISTE.dybde NPSPVARELISTE.max_trykk ~
NPSPVARELISTE.max_temp NPSPVARELISTE.service_plass_over ~
NPSPVARELISTE.service_plass_under NPSPVARELISTE.tegnings_ref ~
NPSPVARELISTE.fast_tekst 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 124.6 BY 15.52.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     NPSPVARELISTE.varenr AT ROW 1.38 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 13.2 BY 1.24
          BGCOLOR 15 
     NPSPVARELISTE.pris AT ROW 1.38 COL 107 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 15.2 BY 1.24
          BGCOLOR 15 
     NPSPVARELISTE.produktnavn AT ROW 1.48 COL 46 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Spirotop","SpiroVent","SpiroVent Hi-Flow","SpiroCombi","SpiroCombi Hi-Flow","SpiroCombi Demonterbar","SpiroCombi Demonterbar Hi-Flow","SpiroCombi Magnet","SpiroTrap","SpiroTrap Demonterbar","SpiroTrap Hi-Flow","SpiroTrap Magnet","SpiroTrap Demonterbar Hi-Flow","Spirovent Air Superior 6-Heating","Spirovent Air Superior 6-Cooling","Spirovent Air Superior S6A","Spirovent Air Superior S6A-R","Spirovent Air Superior S6A-2P","Spirovent Air Superior S3","Spirovent Air Superior S3A","Spirovent Air Superior S3A-R","Spirovent Air Superior S4A","Spirovent Air Superior S4A-R","Spirovent Refill","Kanalvarmere","Spirotube","SpiroCross" 
          DROP-DOWN-LIST
          SIZE 54.6 BY 1
     NPSPVARELISTE.nrf_nr AT ROW 2.71 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 11.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.ror_dim AT ROW 2.71 COL 111.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 10.4 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.kv_verdi AT ROW 2.76 COL 43.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 12.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.anslutning AT ROW 2.76 COL 75 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Flens DIN2632","Flens DIN2633","Sveisestuss","Gjenget","Union" 
          DROP-DOWN-LIST
          SIZE 25.4 BY 1
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.dimmensjon AT ROW 4.14 COL 16 COLON-ALIGNED
          LABEL "Dimm."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "1/2"" BSP INNV","1/2"" BSP INNV M/1/2"" BSP UTV GJ LUFTEVENTIL","3/4"" BSP INNV","22MM","22MM VERTIKAL","3/4"" BSP INNV VERTIKAL","1"" BSP INNV","1"" BSP INNV VERTIKAL","1 1/4"" BSP INNV","1 1/2"" BSP INNV","DN 40","DN 50","DN 65","DN 80","DN100","DN125","DN150","DN200","DN250","DN300","DN350","DN400","DN450","DN500","DN550","DN600" 
          DROP-DOWN-LIST
          SIZE 38 BY 1
          BGCOLOR 15 
     NPSPVARELISTE.materialkvaliteter AT ROW 4.14 COL 72.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Standard ihht brosjyre","ST.37.2","MESSING","AISI 304","AISI 316","Spesial" 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.innmat AT ROW 5.52 COL 16 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","Gitterrør Fortinnet Cu","Gitterør AISI 316","Gitterrør AISI 304","Rustfri" 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
          BGCOLOR 15 
     NPSPVARELISTE.avstand_flotor AT ROW 5.52 COL 76.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.2 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.vegg_tykkelse AT ROW 5.52 COL 103.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.kuleventil AT ROW 6.81 COL 87.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","1/2""","3/4""","1""","1 1/4" 
          DROP-DOWN-LIST
          SIZE 12.8 BY 1
          BGCOLOR 15 FGCOLOR 0 
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     NPSPVARELISTE.H AT ROW 6.95 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.H1 AT ROW 6.95 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.H2 AT ROW 6.95 COL 42.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.avt_plugg AT ROW 6.95 COL 64.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.hurtigventil AT ROW 7 COL 105.8
          VIEW-AS TOGGLE-BOX
          SIZE 18.4 BY .95
          FGCOLOR 0 
     NPSPVARELISTE.h_0 AT ROW 8.24 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.h_2 AT ROW 8.24 COL 42.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.l_lufteventil AT ROW 8.24 COL 67.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 4.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.L AT ROW 8.24 COL 77.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.2 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.LF AT ROW 8.24 COL 92.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.h_1 AT ROW 8.33 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.diameter AT ROW 9.57 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.df_diameter AT ROW 9.57 COL 35.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.volum AT ROW 9.57 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.8 BY 1.24
     NPSPVARELISTE.utv_volum AT ROW 9.57 COL 80.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 10.4 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.vekt AT ROW 9.57 COL 109 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 13.2 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.kapasitet AT ROW 10.81 COL 109 COLON-ALIGNED
          LABEL "Kap."
          VIEW-AS FILL-IN NATIVE 
          SIZE 13.2 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.hoyde AT ROW 10.91 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.bredde AT ROW 10.91 COL 35.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.dybde AT ROW 10.91 COL 53.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.max_trykk AT ROW 10.91 COL 75.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.2 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME F-Main
     NPSPVARELISTE.max_temp AT ROW 10.91 COL 95.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.2 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.service_plass_over AT ROW 12.19 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.service_plass_under AT ROW 12.19 COL 41 COLON-ALIGNED
          LABEL "under"
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.tegnings_ref AT ROW 12.19 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 61 BY 1.24
          BGCOLOR 15 FGCOLOR 0 
     NPSPVARELISTE.fast_tekst AT ROW 13.62 COL 18 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
          SIZE 105 BY 2.86
          BGCOLOR 15 FGCOLOR 0 
     RECT-37 AT ROW 1.19 COL 1.2
     "Fasttekst:" VIEW-AS TEXT
          SIZE 12 BY .76 AT ROW 13.62 COL 5
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 2.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: norcalc.NPSPVARELISTE
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 15.81
         WIDTH              = 124.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX NPSPVARELISTE.dimmensjon IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSPVARELISTE.kapasitet IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSPVARELISTE.service_plass_under IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "NPSPVARELISTE"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "NPSPVARELISTE"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "NPSPVARELISTE"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

