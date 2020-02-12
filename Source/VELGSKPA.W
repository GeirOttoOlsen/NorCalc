&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DLGCLOSE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DLGCLOSE 
/*------------------------------------------------------------------------

  File: dlgclose.w

  Description: General use dialog box 
    template with Close and Help buttons

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 03/08/94 -  9:14 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                            */
DEFINE INPUT PARAMETER tittelParam AS CHAR. 
DEFINE INPUT PARAMETER produktnavnParam LIKE NPSPSYST.produktnavn.
DEFINE INPUT PARAMETER kapasitetParam LIKE NPSPSYST.spiroventkapasitet.
/*DEFINE INPUT PARAMETER anslutningParam LIKE NPSPSYST.anslutning.*/
DEFINE INPUT PARAMETER anbefaltMaxParam AS DECIMAL.
DEFINE INPUT PARAMETER faktorParam LIKE NPSPSYST.faktor.
DEFINE OUTPUT PARAMETER varenrParam LIKE NPSPVARELISTE.varenr.
DEFINE OUTPUT PARAMETER nrfnrParam LIKE NPSPVARELISTE.nrf_nr.
DEFINE OUTPUT PARAMETER innl_hastParam LIKE NPSPSYST.innl_hast.
DEFINE OUTPUT PARAMETER trykkfallParam LIKE NPSPSYST.trykkfall.

IF tittelParam = "" THEN
    tittelParam = "(Tittel)".
 
/* Local Variable Definitions ---                                       */
DEFINE VAR Current-Rec AS ROWID.
DEFINE VAR selectedRow AS LOGICAL.
DEFINE VAR  i  AS INTEGER  INITIAL 1.
DEFINE VAR c_anbefalt AS ROWID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DLGCLOSE
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES SPIRO_TABLE

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 SPIRO_TABLE.varenr ~
SPIRO_TABLE.produktnavn SPIRO_TABLE.dimmensjon SPIRO_TABLE.innl_hastighet ~
SPIRO_TABLE.kpa SPIRO_TABLE.anslutning SPIRO_TABLE.materialkvaliteter 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH SPIRO_TABLE NO-LOCK ~
    BY SPIRO_TABLE.varenr.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 SPIRO_TABLE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 SPIRO_TABLE


/* Definitions for DIALOG-BOX DLGCLOSE                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DLGCLOSE ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      SPIRO_TABLE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 DLGCLOSE _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      SPIRO_TABLE.varenr FORMAT "9999999":U
      SPIRO_TABLE.produktnavn FORMAT "X(25)":U
      SPIRO_TABLE.dimmensjon FORMAT "X(10)":U
      SPIRO_TABLE.innl_hastighet COLUMN-LABEL "Innl.hast." FORMAT "->>>9.999999":U
      SPIRO_TABLE.kpa FORMAT "->>>>>.99":U
      SPIRO_TABLE.anslutning FORMAT "X(14)":U
      SPIRO_TABLE.materialkvaliteter FORMAT "X(25)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 114 BY 7.57
         BGCOLOR 15 FGCOLOR 4 FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGCLOSE
     BROWSE-1 AT ROW 1 COL 1
     SPACE(0.79) SKIP(0.09)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 8 FONT 2
         TITLE BGCOLOR 8 "".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DLGCLOSE
   UNDERLINE                                                            */
/* BROWSE-TAB BROWSE-1 1 DLGCLOSE */
ASSIGN 
       FRAME DLGCLOSE:SCROLLABLE       = FALSE
       FRAME DLGCLOSE:PRIVATE-DATA     = 
                "DLGCLOSE".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "norcalc.SPIRO_TABLE"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.SPIRO_TABLE.varenr|yes"
     _FldNameList[1]   = norcalc.SPIRO_TABLE.varenr
     _FldNameList[2]   = norcalc.SPIRO_TABLE.produktnavn
     _FldNameList[3]   > norcalc.SPIRO_TABLE.dimmensjon
"SPIRO_TABLE.dimmensjon" ? "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   > norcalc.SPIRO_TABLE.innl_hastighet
"SPIRO_TABLE.innl_hastighet" "Innl.hast." "->>>9.999999" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[5]   > norcalc.SPIRO_TABLE.kpa
"SPIRO_TABLE.kpa" ? "->>>>>.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[6]   = norcalc.SPIRO_TABLE.anslutning
     _FldNameList[7]   = norcalc.SPIRO_TABLE.materialkvaliteter
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 DLGCLOSE
ON GO OF BROWSE-1 IN FRAME DLGCLOSE
DO:
    RUN returParam.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 DLGCLOSE
ON LEFT-MOUSE-DBLCLICK OF BROWSE-1 IN FRAME DLGCLOSE
DO:
    RUN returParam.
  APPLY "GO" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 DLGCLOSE
ON RETURN OF BROWSE-1 IN FRAME DLGCLOSE
DO:
    RUN returParam.
  APPLY "GO" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DLGCLOSE 


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
   
    /* Bereg kpa og legg i tabell, tøm først */
    FOR EACH SPIRO_TABLE:
        DELETE SPIRO_TABLE.
    END.
    RUN beregnKpa.
    RUN enable_UI.

    IF c_anbefalt <> ? THEN 
         REPOSITION BROWSE-1 TO ROWID c_anbefalt.

     selectedRow = BROWSE-1:SELECT-FOCUSED-ROW(). 
         
 WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnKpa DLGCLOSE 
PROCEDURE beregnKpa :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VAR c_nedre AS DECIMAL.
  DEFINE VAR c_ovre AS DECIMAL.
  DEFINE VAR c_nevner_kpa AS DECIMAL.
  DEFINE VAR c_utregnet_kpa AS DECIMAL.
  DEFINE VAR teller AS INTEGER INITIAL 1.
  DEFINE VAR  pi as decimal initial 3.14.
  DEFINE VAR v_indre_diameter AS DECIMAL.

 /* Hent valgte produktnavn fra vareliste */
  FOR EACH NPSPVARELISTE 
            WHERE NPSPVARELISTE.produktnavn MATCHES produktnavnParam NO-LOCK:
              CREATE SPIRO_TABLE.
              ASSIGN 
                 SPIRO_TABLE.id# = teller
                 SPIRO_TABLE.varenr = NPSPVARELISTE.varenr
                 SPIRO_TABLE.nrf_nr = NPSPVARELISTE.nrf_nr
                 SPIRO_TABLE.produktnavn = NPSPVARELISTE.produktnavn
                 SPIRO_TABLE.dimmensjon  = NPSPVARELISTE.dimmensjon
                 SPIRO_TABLE.anslutning = NPSPVARELISTE.anslutning.
                 SPIRO_TABLE.materialkvaliteter = NPSPVARELISTE.materialkvaliteter.
                 c_utregnet_kpa = EXP((((kapasitetParam * 60) * 0.6) /  NPSPVARELISTE.kv_verdi), 2).
               IF faktorParam > 0 THEN
                   c_utregnet_kpa =  c_utregnet_kpa *  faktorParam.
               ASSIGN SPIRO_TABLE.kpa = c_utregnet_kpa. 
               v_indre_diameter = NPSPVARELISTE.ror_dim - (NPSPVARELISTE.vegg_tykkelse * 2).
                innl_hastParam = kapasitetParam * 1000 /  ((v_indre_diameter * v_indre_diameter * pi) / 4).
                ASSIGN SPIRO_TABLE.innl_hastighet = innl_hastParam.
               teller = teller + 1.
           END.

    /*Tilordne rett anbefalt verdi */
    /* Bytt ut decimalpunktum med decimalkomma. Ettersom punktum blir
    oppfattet som tusenseparator, kan dette gjøres ved å dele på hundrer  */
    anbefaltMaxParam  = anbefaltMaxParam / 100.

    FOR EACH SPIRO_TABLE  BY SPIRO_TABLE.innl_hastighet DESC:
          IF SPIRO_TABLE.innl_hastighet <= anbefaltMaxParam THEN            
              DO:
                   c_anbefalt = ROWID(SPIRO_TABLE).
                    LEAVE.            
               END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DLGCLOSE  _DEFAULT-DISABLE
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
  HIDE FRAME DLGCLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DLGCLOSE  _DEFAULT-ENABLE
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
  ENABLE BROWSE-1 
      WITH FRAME DLGCLOSE.
  {&OPEN-BROWSERS-IN-QUERY-DLGCLOSE}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returParam DLGCLOSE 
PROCEDURE returParam :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  Current-Rec = ROWID(SPIRO_TABLE).
  FIND SPIRO_TABLE WHERE ROWID (SPIRO_TABLE) = Current-Rec.
  IF AVAILABLE SPIRO_TABLE THEN
  DO:
      varenrParam  = SPIRO_TABLE.varenr.
      nrfnrParam  = SPIRO_TABLE.nrf_nr.
      trykkfallParam = SPIRO_TABLE.kpa.
      innl_hastParam = SPIRO_TABLE.innl_hast.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

