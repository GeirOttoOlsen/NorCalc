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
DEFINE INPUT PARAMETER appdata AS CHARACTER.
DEFINE INPUT PARAMETER anleggsNavnParam AS CHAR.
DEFINE INPUT PARAMETER  nyttSpSystem AS LOGICAL.
DEFINE SHARED VARIABLE anleggsnrParam LIKE NPSPANLG.anleggsnr.
DEFINE SHARED VARIABLE Current-Rec as ROWID.

DEFINE NEW SHARED VARIABLE systemnrParam LIKE NPSPSYST.systemnr.
DEFINE VAR tegningBmp AS CHAR. 
DEFINE VAR tegningOK AS LOGICAL.
DEFINE VAR syst# LIKE NPSPSYST.systemnr.
DEFINE VAR c_anvendelse AS CHARACTER.
c_anvendelse = 'VK'.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE Current-Widget AS WIDGET-HANDLE.
DEFINE VAR pointer AS LOGICAL. 
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.
/*DEFINE VAR rordimParam LIKE NPSPVARELISTE.ror_dim.
DEFINE VAR veggtykkParam LIKE NPSPVARELISTE.vegg_tykkelse.*/
DEFINE VAR anslutningsParam LIKE NPSPSYST.anslutning.
DEFINE VAR innl_hastParam LIKE NPSPSYST.innl_hast.
DEFINE VAR trykkfallParam LIKE NPSPSYST.trykkfall.
DEFINE VAR varenrParam LIKE NPSPVARELISTE.varenr.
DEFINE VAR nrf_nrParam LIKE NPSPVARELISTE.nrf_nr.
DEFINE VAR testListePris AS DECIMAL.
DEFINE VAR produktNavnParam LIKE NPSPSYST.produktnavn.
DEFINE VAR systembetParam LIKE NPSPSYST.systembetegnelse.

DEF VAR bOk AS LOG NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPSYST

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame NPSPSYST.systembetegnelse ~
NPSPSYST.produktnavn NPSPSYST.beregnet_anvendelse NPSPSYST.isolasjon ~
NPSPSYST.anb_max_innl_hast NPSPSYST.medietemperatur NPSPSYST.glykoltype ~
NPSPSYST.konsentrasjon NPSPSYST.faktor NPSPSYST.spiroventkapasitet ~
NPSPSYST.avstand_flotor NPSPSYST.innl_hastighet NPSPSYST.kuleventil_verdi ~
NPSPSYST.max_temp NPSPSYST.max_trykk NPSPSYST.materialkvaliteter ~
NPSPSYST.innmat NPSPSYST.trykkfall NPSPSYST.motflenser ~
NPSPSYST.utv_gjengeventil NPSPSYST.refill NPSPSYST.kuleventil_ja_nei ~
NPSPSYST.listepris NPSPSYST.antall 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame ~
NPSPSYST.systembetegnelse NPSPSYST.produktnavn NPSPSYST.beregnet_anvendelse ~
NPSPSYST.isolasjon NPSPSYST.anb_max_innl_hast NPSPSYST.medietemperatur ~
NPSPSYST.glykoltype NPSPSYST.konsentrasjon NPSPSYST.faktor ~
NPSPSYST.spiroventkapasitet NPSPSYST.avstand_flotor NPSPSYST.innl_hastighet ~
NPSPSYST.kuleventil_verdi NPSPSYST.max_temp NPSPSYST.max_trykk ~
NPSPSYST.materialkvaliteter NPSPSYST.innmat NPSPSYST.trykkfall ~
NPSPSYST.motflenser NPSPSYST.utv_gjengeventil NPSPSYST.refill ~
NPSPSYST.kuleventil_ja_nei NPSPSYST.listepris NPSPSYST.antall 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame NPSPSYST
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame NPSPSYST
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH NPSPSYST SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame NPSPSYST
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame NPSPSYST


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSPSYST.systembetegnelse ~
NPSPSYST.produktnavn NPSPSYST.beregnet_anvendelse NPSPSYST.isolasjon ~
NPSPSYST.anb_max_innl_hast NPSPSYST.medietemperatur NPSPSYST.glykoltype ~
NPSPSYST.konsentrasjon NPSPSYST.faktor NPSPSYST.spiroventkapasitet ~
NPSPSYST.avstand_flotor NPSPSYST.innl_hastighet NPSPSYST.kuleventil_verdi ~
NPSPSYST.max_temp NPSPSYST.max_trykk NPSPSYST.materialkvaliteter ~
NPSPSYST.innmat NPSPSYST.trykkfall NPSPSYST.motflenser ~
NPSPSYST.utv_gjengeventil NPSPSYST.refill NPSPSYST.kuleventil_ja_nei ~
NPSPSYST.listepris NPSPSYST.antall 
&Scoped-define ENABLED-TABLES NPSPSYST
&Scoped-define FIRST-ENABLED-TABLE NPSPSYST
&Scoped-define DISPLAYED-TABLES NPSPSYST
&Scoped-define FIRST-DISPLAYED-TABLE NPSPSYST
&Scoped-Define ENABLED-OBJECTS BUTTON-beregne FILL-IN-valgt_produkt Btn_OK ~
SYSTEMPRIS Btn_Cancel Btn_Help RECT-31 RECT-32 RECT-33 RECT-34 
&Scoped-Define DISPLAYED-FIELDS NPSPSYST.systembetegnelse ~
NPSPSYST.produktnavn NPSPSYST.beregnet_anvendelse NPSPSYST.isolasjon ~
NPSPSYST.anb_max_innl_hast NPSPSYST.medietemperatur NPSPSYST.glykoltype ~
NPSPSYST.konsentrasjon NPSPSYST.faktor NPSPSYST.spiroventkapasitet ~
NPSPSYST.avstand_flotor NPSPSYST.innl_hastighet NPSPSYST.kuleventil_verdi ~
NPSPSYST.max_temp NPSPSYST.max_trykk NPSPSYST.materialkvaliteter ~
NPSPSYST.innmat NPSPSYST.trykkfall NPSPSYST.motflenser ~
NPSPSYST.utv_gjengeventil NPSPSYST.refill NPSPSYST.kuleventil_ja_nei ~
NPSPSYST.listepris NPSPSYST.antall 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-valgt_produkt SYSTEMPRIS 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 11.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 11.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 11.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-beregne 
     LABEL "Foreta &Beregning" 
     SIZE 25 BY 1.24.

DEFINE BUTTON BUTTON-tegning 
     LABEL "&Vis tegning" 
     SIZE 16.8 BY 1.24.

DEFINE VARIABLE FILL-IN-valgt_produkt AS CHARACTER FORMAT "X(60)":U 
     LABEL "Valgt prod." 
     VIEW-AS FILL-IN NATIVE 
     SIZE 79.2 BY 1.24
     BGCOLOR 8 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE SYSTEMPRIS AS INTEGER FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Systempris" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 19.6 BY 1.24
     BGCOLOR 8 FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 122.6 BY 7.71.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 122.6 BY 6.67.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 93.6 BY 2.05.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 93.6 BY 2.29.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      NPSPSYST SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     NPSPSYST.systembetegnelse AT ROW 2.05 COL 18.6 COLON-ALIGNED
          LABEL "Syst.bet."
          VIEW-AS FILL-IN NATIVE 
          SIZE 58 BY 1.24
          FONT 2
     NPSPSYST.produktnavn AT ROW 3.38 COL 18.6 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Spirotop","Spirovent Air","Spirovent Air Hi-Flow","Spirovent Air & Dirt","Spirovent Air & Dirt Hi-Flow","Spirovent Air & Dirt Demonterbar","Spirovent Air & Dirt Demonterbar Hi-Flow","Spirovent Dirt Separator","Spirovent Dirt Separator Demonterbar","Spirovent Dirt Separator Hi-Flow","Spirovent Dirt Separator Demonterbar Hi-Flow","Spirovent Air Superior 6-Heating","Spirovent Air Superior 6-Cooling","Spirovent Air Superior S6A","Spirovent Air Superior S6A-R","Spirovent Air Superior S6A-2P","Spirovent Air Superior S3","Spirovent Air Superior S3A","Spirovent Air Superior S3A-R","Spirovent Air Superior S4A","Spirovent Air Superior S4A-R","Spirovent Refill","Kanalvarmere","Spirotube","SpiroCross" 
          DROP-DOWN-LIST
          SIZE 58.4 BY 1
          BGCOLOR 15 FGCOLOR 0 
     NPSPSYST.beregnet_anvendelse AT ROW 3.48 COL 89.2 COLON-ALIGNED
          LABEL "Anv.omr."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Varme","Lavtemperatur","Kjøle","Kulde","Varmegjenvinning","Ukjent","Drikkevann" 
          DROP-DOWN-LIST
          SIZE 31 BY 1
          FONT 2
     NPSPSYST.isolasjon AT ROW 4.86 COL 18.6 COLON-ALIGNED
          LABEL "Mantel/Isol."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","Mineralull","Cellegummi 13mm","Cellegummi 19mm","Cellegummi 24mm" 
          DROP-DOWN-LIST
          SIZE 31 BY 1
          FONT 2
     NPSPSYST.anb_max_innl_hast AT ROW 4.91 COL 89.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "      ","1.00","1.10","1.20","1.50","3.00" 
          DROP-DOWN-LIST
          SIZE 12.8 BY 1
     NPSPSYST.medietemperatur AT ROW 6.19 COL 18.6 COLON-ALIGNED
          LABEL "Medietemp."
          VIEW-AS FILL-IN NATIVE 
          SIZE 13.2 BY 1.24
          FONT 2
     NPSPSYST.glykoltype AT ROW 6.19 COL 46.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 4
          LIST-ITEMS "Ingen","Monoetylenglykol","Monopropylenglykol","Ukjent" 
          DROP-DOWN-LIST
          SIZE 33.8 BY 1
          FONT 2
     NPSPSYST.konsentrasjon AT ROW 6.19 COL 89.2 COLON-ALIGNED
          LABEL "Kons."
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "0","5","10","15","20","25","30","35","40","45","50","Ukjent" 
          DROP-DOWN-LIST
          SIZE 9.8 BY 1
     NPSPSYST.faktor AT ROW 7.57 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9 BY 1.24
     NPSPSYST.spiroventkapasitet AT ROW 7.57 COL 46.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14.8 BY 1.24
          FONT 2
     BUTTON-beregne AT ROW 7.71 COL 77.8
     BUTTON-tegning AT ROW 7.71 COL 105.4
     FILL-IN-valgt_produkt AT ROW 10.62 COL 18.6 COLON-ALIGNED
     NPSPSYST.avstand_flotor AT ROW 11.95 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 
     NPSPSYST.innl_hastighet AT ROW 11.95 COL 37 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 8 FGCOLOR 1 
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dialog-Frame
     NPSPSYST.kuleventil_verdi AT ROW 11.95 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9 BY 1.24
          BGCOLOR 8 FGCOLOR 1 
     NPSPSYST.max_temp AT ROW 11.95 COL 84.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 
     NPSPSYST.max_trykk AT ROW 11.95 COL 106.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 
     NPSPSYST.materialkvaliteter AT ROW 13.43 COL 18.6 COLON-ALIGNED
          LABEL "Materialkval."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Standard ihht brosjyre","ST.37.2","Messing","AISI 304","AISI 316","Spesial" 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPSYST.innmat AT ROW 13.52 COL 72 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Gitterrør Fortinnet Cu","Gitterrør AISI 316","Gitterrør AISI 304","Rustfri","Standard ihht. brosjyre" 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPSPSYST.trykkfall AT ROW 14.81 COL 18.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 13.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 
     NPSPSYST.motflenser AT ROW 17.67 COL 4.6
          VIEW-AS TOGGLE-BOX
          SIZE 16.6 BY .95
     NPSPSYST.utv_gjengeventil AT ROW 17.67 COL 24.8
          VIEW-AS TOGGLE-BOX
          SIZE 30.6 BY .95
     NPSPSYST.refill AT ROW 17.67 COL 59.6
          VIEW-AS TOGGLE-BOX
          SIZE 11.2 BY .95
     NPSPSYST.kuleventil_ja_nei AT ROW 17.67 COL 76
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .95
     Btn_OK AT ROW 19.38 COL 98.8
     NPSPSYST.listepris AT ROW 20.24 COL 14.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 18 BY 1.24
          FONT 2
     NPSPSYST.antall AT ROW 20.24 COL 42.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.8 BY 1.24
          FONT 2
     SYSTEMPRIS AT ROW 20.24 COL 67 COLON-ALIGNED
     Btn_Cancel AT ROW 20.81 COL 98.8
     Btn_Help AT ROW 20.81 COL 111.8
     RECT-31 AT ROW 1.62 COL 1.8
     RECT-32 AT ROW 9.86 COL 1.8
     RECT-33 AT ROW 16.91 COL 1.8
     RECT-34 AT ROW 19.76 COL 1.8
     " Før beregning" VIEW-AS TEXT
          SIZE 18.4 BY .76 AT ROW 1.14 COL 4
     " Tileggsleveranser" VIEW-AS TEXT
          SIZE 23.8 BY .76 AT ROW 16.57 COL 5
     " Pris" VIEW-AS TEXT
          SIZE 6.4 BY .76 AT ROW 19.14 COL 5.4
     " Etter beregning" VIEW-AS TEXT
          SIZE 19.8 BY .76 AT ROW 9.38 COL 5
     SPACE(100.59) SKIP(12.13)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Spiroventsystem"
         CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX NPSPSYST.beregnet_anvendelse IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR BUTTON BUTTON-tegning IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX NPSPSYST.isolasjon IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPSPSYST.konsentrasjon IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPSPSYST.materialkvaliteter IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSPSYST.medietemperatur IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSPSYST.systembetegnelse IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "norcalc.NPSPSYST"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Spiroventsystem */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.antall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.antall Dialog-Frame
ON LEAVE OF NPSPSYST.antall IN FRAME Dialog-Frame /* Antall */
DO:
  ASSIGN  SYSTEMPRIS =  DECIMAL(SELF:SCREEN-VALUE) * 
        DECIMAL(NPSPSYST.listepris:SCREEN-VALUE).
    DISPLAY SYSTEMPRIS WITH FRAME Dialog-Frame.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.avstand_flotor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.avstand_flotor Dialog-Frame
ON ENTRY OF NPSPSYST.avstand_flotor IN FRAME Dialog-Frame /* Avstand flotør */
DO:
  RETURN NO-APPLY.
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
    IF nyttSpSystem THEN
        Current-Rec = ROWID(NPSPSYST).
    RUN utskriftsTekst.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-beregne
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-beregne Dialog-Frame
ON CHOOSE OF BUTTON-beregne IN FRAME Dialog-Frame /* Foreta Beregning */
DO:
    /*produktnavn MÅ være fylt ut */
    IF INPUT NPSPSYST.produktnavn:SCREEN-VALUE = ?  THEN
        DO:
            MESSAGE 'produktnavn  MÅ være valgt' VIEW-AS ALERT-BOX TITLE 'FEIL'.
            APPLY 'ENTRY' TO NPSPSYST.produktnavn.
            RETURN NO-APPLY.            
        END.
        RUN VELGSKPA.W (INPUT 'Velg Spirovent', INPUT NPSPSYST.produktnavn:SCREEN-VALUE, 
        INPUT DECIMAL(NPSPSYST.spiroventkapasitet:SCREEN-VALUE), 
        INPUT DECIMAL(NPSPSYST.anb_max_innl_hast:SCREEN-VALUE),
        INPUT DECIMAL(NPSPSYST.faktor:SCREEN-VALUE),
        OUTPUT varenrParam, OUTPUT nrf_nrParam, OUTPUT innl_hastParam, 
        OUTPUT trykkfallParam).

        /* Finn dette produkt i vareliste og overfør data */
        FIND FIRST NPSPVARELISTE 
        WHERE NPSPVARELISTE.varenr = varenrParam NO-LOCK NO-ERROR.
        IF AVAILABLE NPSPVARELISTE THEN
        DO:
            ASSIGN
                 NPSPSYST.produktnavn = NPSPVARELISTE.produktnavn
                 produktNavnParam = NPSPVARELISTE.produktnavn
                 NPSPSYST.anslutning = NPSPVARELISTE.anslutning        
                 NPSPSYST.dimmensjon = NPSPVARELISTE.dimmensjon
                 NPSPSYST.ror_dim = NPSPVARELISTE.ror_dim
                 NPSPSYST.vegg_tykk = NPSPVARELISTE.vegg_tykkelse
                 NPSPSYST.avstand_flotor = NPSPVARELISTE.avstand_flotor
                 NPSPSYST.listepris = NPSPVARELISTE.pris
                 testListePris = NPSPVARELISTE.pris
                 NPSPSYST.kuleventil_verdi = NPSPVARELISTE.kuleventil
                 NPSPSYST.materialkvaliteter = NPSPVARELISTE.materialkvaliteter
                 NPSPSYST.max_trykk = NPSPVARELISTE.max_trykk
                 NPSPSYST.max_temp = NPSPVARELISTE.max_temp
                 NPSPSYST.innmat = NPSPVARELISTE.innmat
                 NPSPSYST.innl_hast = innl_hastParam
                 NPSPSYST.trykkfall = trykkfallParam
                 NPSPSYST.anbefalt_max_kap = NPSPVARELISTE.kapasitet
                 NPSPSYST.varenr = NPSPVARELISTE.varenr
                 NPSPSYST.nrf_nr = NPSPVARELISTE.nrf_nr.
                 
            ASSIGN FILL-IN-valgt_produkt  =
                 STRING(NPSPSYST.varenr) + ' ' + NPSPSYST.produktnavn + ' ' +
                 NPSPSYST.dimmensjon + ' ' + NPSPSYST.anslutning.            
            
           DISPLAY NPSPSYST.produktnavn FILL-IN-valgt_produkt NPSPSYST.listepris  
                NPSPSYST.innl_hast   NPSPSYST.trykkfall NPSPSYST.avstand_flotor
                NPSPSYST.kuleventil_verdi  NPSPSYST.materialkvaliteter
                NPSPSYST.innmat  NPSPSYST.trykkfall
                    WITH FRAME {&FRAME-NAME}.       
            /* Gjør det mulig å se på tegning */
            ENABLE BUTTON-TEGNING WITH FRAME {&FRAME-NAME}.
        END.
        ELSE
            MESSAGE 'Fant ikke verdier fra vareliste' VIEW-AS ALERT-BOX TITLE 'FEIL'.

    RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-tegning
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-tegning Dialog-Frame
ON CHOOSE OF BUTTON-tegning IN FRAME Dialog-Frame /* Vis tegning */
DO:
        RUN SPSYSBMP.W ( INPUT NPSPSYST.systembetegnelse:SCREEN-VALUE, 
            INPUT anleggsNavnParam, INPUT varenrParam).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-valgt_produkt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-valgt_produkt Dialog-Frame
ON ENTRY OF FILL-IN-valgt_produkt IN FRAME Dialog-Frame /* Valgt prod. */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.innl_hastighet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.innl_hastighet Dialog-Frame
ON ENTRY OF NPSPSYST.innl_hastighet IN FRAME Dialog-Frame /* Innl.hast. */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.innmat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.innmat Dialog-Frame
ON ENTRY OF NPSPSYST.innmat IN FRAME Dialog-Frame /* Innmat */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.kuleventil_verdi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.kuleventil_verdi Dialog-Frame
ON ENTRY OF NPSPSYST.kuleventil_verdi IN FRAME Dialog-Frame /* Kuleventil */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.listepris
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.listepris Dialog-Frame
ON LEAVE OF NPSPSYST.listepris IN FRAME Dialog-Frame /* Listepris */
DO:
    IF motflenser:SCREEN-VALUE = 'ja' OR
        utv_gjengeventil:SCREEN-VALUE = 'ja' OR
        refill:SCREEN-VALUE = 'ja' THEN
        DO:
            IF DECIMAL(SELF:SCREEN-VALUE) = testListePris THEN
            DO:
                MESSAGE 'Listepris er ikke justert' VIEW-AS ALERT-BOX TITLE 'Feil?'.
                APPLY 'ENTRY' TO SELF.
                RETURN NO-APPLY.
            END.                                                
        END.
   ASSIGN SYSTEMPRIS =  DECIMAL(SELF:SCREEN-VALUE) * 
        DECIMAL(NPSPSYST.antall:SCREEN-VALUE).
    DISPLAY SYSTEMPRIS WITH FRAME Dialog-Frame.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.materialkvaliteter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.materialkvaliteter Dialog-Frame
ON ENTRY OF NPSPSYST.materialkvaliteter IN FRAME Dialog-Frame /* Materialkval. */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.max_temp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.max_temp Dialog-Frame
ON ENTRY OF NPSPSYST.max_temp IN FRAME Dialog-Frame /* Max temp. */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.max_trykk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.max_trykk Dialog-Frame
ON ENTRY OF NPSPSYST.max_trykk IN FRAME Dialog-Frame /* Max trykk */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.produktnavn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.produktnavn Dialog-Frame
ON LEAVE OF NPSPSYST.produktnavn IN FRAME Dialog-Frame /* Produktnavn */
DO:
    DEFINE VAR egenverdi AS CHAR.

     egenverdi = SELF:SCREEN-VALUE.
    
     IF egenVerdi  BEGINS("Spirotop") OR egenVerdi  BEGINS("Spirovent Air Superior")  THEN
        DO:
             NPSPSYST.anb_max_innl_hast = '     '. 
             HIDE  NPSPSYST.anb_max_innl_hast 
                NPSPSYST.faktor NPSPSYST.spiroventkapasitet.
        END.
     ELSE IF egenVerdi  MATCHES("*Hi-Flow") THEN
        DO:
             NPSPSYST.anb_max_innl_hast = '3.00'.
             VIEW  NPSPSYST.anb_max_innl_hast 
                NPSPSYST.faktor NPSPSYST.spiroventkapasitet.
        END.
     ELSE
        DO:
            MESSAGE "Messing?"   
                     VIEW-AS ALERT-BOX INFORMATION BUTTONS YES-NO UPDATE bOk.
            
             NPSPSYST.anb_max_innl_hast =  (if bOk then '1.00' else '1.50').
             VIEW  NPSPSYST.anb_max_innl_hast 
                NPSPSYST.faktor NPSPSYST.spiroventkapasitet.
        END.
    DISPLAY  NPSPSYST.anb_max_innl_hast  WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.produktnavn Dialog-Frame
ON VALUE-CHANGED OF NPSPSYST.produktnavn IN FRAME Dialog-Frame /* Produktnavn */
DO:
  IF SELF:SCREEN-VALUE  BEGINS 'Spirovent Air Superior' THEN
    ENABLE refill WITH FRAME {&FRAME-NAME}.
  ELSE
    DISABLE refill WITH FRAME {&FRAME-NAME}.
  IF SELF:SCREEN-VALUE  MATCHES ("*Dirt*")  THEN
    ASSIGN NPSPSYST.kuleventil_ja_nei = TRUE.
  ELSE
    ASSIGN NPSPSYST.kuleventil_ja_nei = FALSE.
  DISPLAY NPSPSYST.kuleventil_ja_nei   WITH FRAME {&FRAME-NAME}.    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SYSTEMPRIS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SYSTEMPRIS Dialog-Frame
ON ENTRY OF SYSTEMPRIS IN FRAME Dialog-Frame /* Systempris */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SYSTEMPRIS Dialog-Frame
ON LEAVE OF SYSTEMPRIS IN FRAME Dialog-Frame /* Systempris */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.trykkfall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.trykkfall Dialog-Frame
ON ENTRY OF NPSPSYST.trykkfall IN FRAME Dialog-Frame /* Trykkfall */
DO:
RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

 FRAME {&FRAME-NAME}:TITLE = 'Spiroventsystem for anlegg: ' + anleggsNavnParam.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   pointer = SESSION:SET-WAIT-STATE("").
    IF nyttSpSystem THEN
       RUN nyttSystem.
    ELSE
       RUN endreSystem.
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
  DISPLAY FILL-IN-valgt_produkt SYSTEMPRIS 
      WITH FRAME Dialog-Frame.
  IF AVAILABLE NPSPSYST THEN 
    DISPLAY NPSPSYST.systembetegnelse NPSPSYST.produktnavn 
          NPSPSYST.beregnet_anvendelse NPSPSYST.isolasjon 
          NPSPSYST.anb_max_innl_hast NPSPSYST.medietemperatur 
          NPSPSYST.glykoltype NPSPSYST.konsentrasjon NPSPSYST.faktor 
          NPSPSYST.spiroventkapasitet NPSPSYST.avstand_flotor 
          NPSPSYST.innl_hastighet NPSPSYST.kuleventil_verdi NPSPSYST.max_temp 
          NPSPSYST.max_trykk NPSPSYST.materialkvaliteter NPSPSYST.innmat 
          NPSPSYST.trykkfall NPSPSYST.motflenser NPSPSYST.utv_gjengeventil 
          NPSPSYST.refill NPSPSYST.kuleventil_ja_nei NPSPSYST.listepris 
          NPSPSYST.antall 
      WITH FRAME Dialog-Frame.
  ENABLE NPSPSYST.systembetegnelse NPSPSYST.produktnavn 
         NPSPSYST.beregnet_anvendelse NPSPSYST.isolasjon 
         NPSPSYST.anb_max_innl_hast NPSPSYST.medietemperatur 
         NPSPSYST.glykoltype NPSPSYST.konsentrasjon NPSPSYST.faktor 
         NPSPSYST.spiroventkapasitet BUTTON-beregne FILL-IN-valgt_produkt 
         NPSPSYST.avstand_flotor NPSPSYST.innl_hastighet 
         NPSPSYST.kuleventil_verdi NPSPSYST.max_temp NPSPSYST.max_trykk 
         NPSPSYST.materialkvaliteter NPSPSYST.innmat NPSPSYST.trykkfall 
         NPSPSYST.motflenser NPSPSYST.utv_gjengeventil NPSPSYST.refill 
         NPSPSYST.kuleventil_ja_nei Btn_OK NPSPSYST.listepris NPSPSYST.antall 
         SYSTEMPRIS Btn_Cancel Btn_Help RECT-31 RECT-32 RECT-33 RECT-34 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreSystem Dialog-Frame 
PROCEDURE endreSystem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND NPSPSYST WHERE ROWID(NPSPSYST) = Current-Rec EXCLUSIVE-LOCK
   NO-ERROR NO-WAIT.
  IF AVAILABLE NPSPSYST THEN
    DO:
      ENABLE SYSTEMPRIS FILL-IN-valgt_produkt  NPSPSYST.listepris  
                NPSPSYST.innl_hast   NPSPSYST.trykkfall NPSPSYST.avstand_flotor
                NPSPSYST.kuleventil_verdi  NPSPSYST.materialkvaliteter
                NPSPSYST.innmat  NPSPSYST.trykkfall
                NPSPSYST.max_trykk NPSPSYST.max_temp
      WITH FRAME Dialog-Frame.

       ASSIGN FILL-IN-valgt_produkt  =
          STRING(NPSPSYST.varenr) + ' ' + NPSPSYST.produktnavn + ' ' +
          NPSPSYST.dimmensjon + ' ' + NPSPSYST.anslutning.            

      ASSIGN  SYSTEMPRIS =  NPSPSYST.antall * NPSPSYST.listepris
                         varenrParam = NPSPSYST.varenr.

      DISPLAY SYSTEMPRIS FILL-IN-valgt_produkt  NPSPSYST.listepris  
                NPSPSYST.innl_hast   NPSPSYST.trykkfall NPSPSYST.avstand_flotor
                NPSPSYST.kuleventil_verdi  NPSPSYST.materialkvaliteter
                NPSPSYST.innmat  NPSPSYST.trykkfall
                NPSPSYST.max_trykk NPSPSYST.max_temp
      WITH FRAME Dialog-Frame.

        UPDATE 
         NPSPSYST.systembetegnelse NPSPSYST.produktnavn 
         NPSPSYST.beregnet_anvendelse   NPSPSYST.isolasjon
         NPSPSYST.anb_max_innl_hast NPSPSYST.medietemperatur
         NPSPSYST.glykoltype   NPSPSYST.konsentrasjon 
         NPSPSYST.faktor  NPSPSYST.spiroventkapasitet 
         BUTTON-beregne   BUTTON-tegning
         NPSPSYST.motflenser  NPSPSYST.utv_gjengeventil 
         NPSPSYST.refill  NPSPSYST.kuleventil_ja_nei
         NPSPSYST.listepris  NPSPSYST.antall 
         SYSTEMPRIS 
             Btn_OK Btn_Cancel Btn_Help 
              WITH FRAME Dialog-Frame.
      END.
    ELSE DO:
    MESSAGE 'KUNNE IKKE FINNE POSTEN' VIEW-AS ALERT-BOX.
    RETURN.
    END.
 END. /* TRANSACTION */      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyttSystem Dialog-Frame 
PROCEDURE nyttSystem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND LAST NPSPSYST WHERE NPSPSYST.anleggsnr = anleggsnrParam NO-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE(NPSPSYST) THEN
      /* Det er opprettet system for dette anlegget tidligere */
          syst# = NPSPSYST.systemnr  + 1.
  ELSE
    DO:
      IF LOCKED NPSPSYST THEN
         DO:
            /* Andre registrerer spiroventsystem på dette anlegget nå */
             MESSAGE 'Andre registrerer spiroventtsystem på dette anlegget nå. Prøv igjen senere' VIEW-AS ALERT-BOX 
                 TITLE 'STOPP'.
            RETURN.
         END.
    ELSE            
      syst# = 1.  
    END.
  CREATE NPSPSYST.
  NPSPSYST.anleggsnr  = anleggsnrParam.
  NPSPSYST.systemnr = syst#.
  systemnrParam = syst#.
 ENABLE SYSTEMPRIS FILL-IN-valgt_produkt  NPSPSYST.listepris  
                NPSPSYST.innl_hast   NPSPSYST.trykkfall NPSPSYST.avstand_flotor
                NPSPSYST.kuleventil_verdi  NPSPSYST.materialkvaliteter
                NPSPSYST.innmat  NPSPSYST.trykkfall
                NPSPSYST.max_trykk NPSPSYST.max_temp
  WITH FRAME Dialog-Frame.
 
 UPDATE 
         NPSPSYST.systembetegnelse NPSPSYST.produktnavn 
         NPSPSYST.beregnet_anvendelse   NPSPSYST.isolasjon
         NPSPSYST.anb_max_innl_hast NPSPSYST.medietemperatur
         NPSPSYST.glykoltype   NPSPSYST.konsentrasjon 
         NPSPSYST.faktor  NPSPSYST.spiroventkapasitet 
         BUTTON-beregne  
         NPSPSYST.motflenser  NPSPSYST.utv_gjengeventil 
         NPSPSYST.refill  NPSPSYST.kuleventil_ja_nei
         NPSPSYST.listepris  NPSPSYST.antall 
         SYSTEMPRIS 
         Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.
END. /* TRANSACTION */      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE utskriftsTekst Dialog-Frame 
PROCEDURE utskriftsTekst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR tegningBmp AS CHAR.

DO WITH FRAME {&FRAME-NAME}:
    CASE NPSPSYST.produktnavn:SCREEN-VALUE:
    WHEN 'Spirotop' THEN 
    DO:
        NPSPSYST.produkttype = 'Toppavlufter'.
        tegningBmp = 'sptop.bmp'.
   END.
    WHEN 'Spirovent Air' THEN 
        NPSPSYST.produkttype = 'Mikobobleutskiller'.
    WHEN 'Spirovent Air Hi-Flow' THEN 
        NPSPSYST.produkttype = 'Mikobobleutskiller High Flow'.
    WHEN 'Spirovent Air & Dirt'  OR WHEN "SpiroCross" THEN 
        NPSPSYST.produkttype = 'Mikoboble- og smussutskiller'.
    WHEN 'Spirovent Air & Dirt Hi-Flow' THEN 
        NPSPSYST.produkttype = 'Mikoboble- og smussutskiller High Flow'.
    WHEN 'Spirovent Air & Dirt Demonterbar' THEN 
        NPSPSYST.produkttype = 'Mikoboble- og smussutskiller, demonterbar'.
    WHEN 'Spirovent Air & Dirt Demonterbar Hi-Flow' THEN 
        NPSPSYST.produkttype = 'Mikoboble- og smussutskiller, demonterbar High Flow'.
    WHEN 'Spirovent Dirt Separator' THEN 
        NPSPSYST.produkttype = 'Smussutskiller'.
    WHEN 'Spirovent Dirt Separator Hi-Flow' THEN 
        NPSPSYST.produkttype = 'Smussutskiller High Flow'.
    WHEN 'Spirovent Dirt Separator Demonterbar' THEN 
        NPSPSYST.produkttype = 'Smussutskiller, demonterbar'.
    WHEN 'Spirovent Dirt Separator Demonterbar Hi-Flow' THEN 
        NPSPSYST.produkttype = 'Smussutskiller, demonterbar High Flow'.
    WHEN 'Spirovent Air Superior 6-Heating' THEN 
        NPSPSYST.produkttype = 'Trykksenkningsavlufter, varme'.
    WHEN 'Spirovent Air Superior 6-Cooling' THEN 
        NPSPSYST.produkttype = 'Trykksenkningsavlufter, kjøling'.
    WHEN 'Spirovent Refill' THEN 
        NPSPSYST.produkttype = 'Automatisk Etterfyllingsenhet'.
    END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

