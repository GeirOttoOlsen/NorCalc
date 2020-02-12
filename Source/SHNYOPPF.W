&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME NY-OPPF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS NY-OPPF 
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
/*DEFINE SHARED VAR Current-Oppf-Rec AS ROWID.             */
/*DEFINE SHARED VAR nyRecord AS LOGICAL.                   */
/*DEFINE SHARED VAR tilbudsIdParam LIKE NPSHTILBUD.id.     */
/*DEFINE SHARED VAR anleggsnrParam LIKE NPSHANLG.anleggsnr.*/

/* Local Variable Definitions ---                                       */
def var hParent as handle no-undo.
def var current-rec as rowid no-undo.
def var nyRecord as log no-undo.
def var anleggsNrParam like npshanlg.anleggsnr.
def var TilbudsIdParam like npshtilbud.id.


DEFINE VAR iNextId AS INTEGER.
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME NY-OPPF

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHTOPP

/* Definitions for DIALOG-BOX NY-OPPF                                   */
&Scoped-define FIELDS-IN-QUERY-NY-OPPF NPSHTOPP.oppf_dato NPSHTOPP.oppf_uke ~
NPSHTOPP.oppf_status NPSHTOPP.kriterium_1 NPSHTOPP.kriterium_2 ~
NPSHTOPP.tiltak NPSHTOPP.neste_oppf_uke NPSHTOPP.neste_oppf ~
NPSHTOPP.neste_oppf_aar NPSHTOPP.notater NPSHTOPP.vaar_kontakt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-NY-OPPF NPSHTOPP.oppf_dato ~
NPSHTOPP.oppf_uke NPSHTOPP.oppf_status NPSHTOPP.kriterium_1 ~
NPSHTOPP.kriterium_2 NPSHTOPP.tiltak NPSHTOPP.neste_oppf_uke ~
NPSHTOPP.neste_oppf NPSHTOPP.neste_oppf_aar NPSHTOPP.notater ~
NPSHTOPP.vaar_kontakt 
&Scoped-define ENABLED-TABLES-IN-QUERY-NY-OPPF NPSHTOPP
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-NY-OPPF NPSHTOPP
&Scoped-define QUERY-STRING-NY-OPPF FOR EACH NPSHTOPP SHARE-LOCK
&Scoped-define OPEN-QUERY-NY-OPPF OPEN QUERY NY-OPPF FOR EACH NPSHTOPP SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-NY-OPPF NPSHTOPP
&Scoped-define FIRST-TABLE-IN-QUERY-NY-OPPF NPSHTOPP


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHTOPP.oppf_dato NPSHTOPP.oppf_uke ~
NPSHTOPP.oppf_status NPSHTOPP.kriterium_1 NPSHTOPP.kriterium_2 ~
NPSHTOPP.tiltak NPSHTOPP.neste_oppf_uke NPSHTOPP.neste_oppf ~
NPSHTOPP.neste_oppf_aar NPSHTOPP.notater NPSHTOPP.vaar_kontakt 
&Scoped-define ENABLED-TABLES NPSHTOPP
&Scoped-define FIRST-ENABLED-TABLE NPSHTOPP
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel Btn_Help RECT-1 
&Scoped-Define DISPLAYED-FIELDS NPSHTOPP.oppf_dato NPSHTOPP.oppf_uke ~
NPSHTOPP.oppf_status NPSHTOPP.kriterium_1 NPSHTOPP.kriterium_2 ~
NPSHTOPP.tiltak NPSHTOPP.neste_oppf_uke NPSHTOPP.neste_oppf ~
NPSHTOPP.neste_oppf_aar NPSHTOPP.notater NPSHTOPP.vaar_kontakt 
&Scoped-define DISPLAYED-TABLES NPSHTOPP
&Scoped-define FIRST-DISPLAYED-TABLE NPSHTOPP


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 11.2 BY 1.38
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 11.2 BY 1.38
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 11.2 BY 1.38
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 119.2 BY 13.67.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY NY-OPPF FOR 
      NPSHTOPP SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME NY-OPPF
     NPSHTOPP.oppf_dato AT ROW 1.81 COL 18.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.oppf_uke AT ROW 1.81 COL 42.6 COLON-ALIGNED
          LABEL "Uke"
          VIEW-AS FILL-IN 
          SIZE 5.4 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.oppf_status AT ROW 1.76 COL 75 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ukjent","Antas","Sikker","Selges","ORDRE","Mulig","Tvilsom","Tapt ABS","Tapt L&G","Tapt T&A","Tapt TTM","Plassbygd","Tapt Ukjent","Ikke Realisert","Tapt Andre" 
          DROP-DOWN-LIST
          SIZE 30 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.kriterium_1 AT ROW 3.19 COL 18.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Pris rett","Pris høy-justeres","Pris høy-uinteressant" 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.kriterium_2 AT ROW 3.14 COL 75 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Relasjon pos.","Relasjon neg.","Leveringstid","Kvalitet","Konsept","For sent" 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.tiltak AT ROW 4.48 COL 18.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Avklares","Informasjon","TLF/FAX/BREV","Besøk","Pleies","Bedres","Endres","Avvise" 
          DROP-DOWN-LIST
          SIZE 26.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.neste_oppf_uke AT ROW 6.71 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.4 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.neste_oppf AT ROW 6.71 COL 46 COLON-ALIGNED
          LABEL "Dato"
          VIEW-AS FILL-IN 
          SIZE 14.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.neste_oppf_aar AT ROW 6.71 COL 76 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
     NPSHTOPP.notater AT ROW 8.38 COL 22 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 86 BY 5.14
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.vaar_kontakt AT ROW 13.62 COL 20 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
     Btn_OK AT ROW 15.52 COL 41
     Btn_Cancel AT ROW 15.52 COL 55
     Btn_Help AT ROW 15.52 COL 69
     "Notater:" VIEW-AS TEXT
          SIZE 10 BY .76 AT ROW 8.38 COL 12
     RECT-1 AT ROW 1.38 COL 1.8
     SPACE(1.79) SKIP(2.56)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Ny Shunt - Oppfølging"
         CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX NY-OPPF
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME NY-OPPF:SCROLLABLE       = FALSE
       FRAME NY-OPPF:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN NPSHTOPP.neste_oppf IN FRAME NY-OPPF
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHTOPP.oppf_uke IN FRAME NY-OPPF
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX NY-OPPF
/* Query rebuild information for DIALOG-BOX NY-OPPF
     _TblList          = "norcalc.NPSHTOPP"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX NY-OPPF */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME NY-OPPF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NY-OPPF NY-OPPF
ON WINDOW-CLOSE OF FRAME NY-OPPF /* Ny Shunt - Oppfølging */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help NY-OPPF
ON CHOOSE OF Btn_Help IN FRAME NY-OPPF /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK NY-OPPF
ON CHOOSE OF Btn_OK IN FRAME NY-OPPF /* OK */
DO:
    define var cp_tabell_navn as char.
    define var ip_neste_id as integer.
    define var c_status as char.
    define var cProsjektId  like norprosjekt.prosjektid.

    /* Dersom oppfølgingsdato ikke er fylt ut, stopp registrering */
    IF DATE(NPSHTOPP.oppf_dato:SCREEN-VALUE)  = ?  THEN
        DO:
            MESSAGE 'Oppfølgingsdato MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
           APPLY "ENTRY" TO NPSHTOPP.oppf_dato.
           RETURN NO-APPLY.
        END.
            
    /* Dersom neste oppf. År ikke er fylt ut, stopp registrering */
    IF INTEGER(NPSHTOPP.neste_oppf_aar:SCREEN-VALUE) = 0 THEN
        DO:
            MESSAGE 'Neste oppfølgingsår MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            APPLY "ENTRY" TO NPSHTOPP.neste_oppf_aar.
            RETURN NO-APPLY.
        END.
    c_status = NPSHTOPP.oppf_status:SCREEN-VALUE.
    /* Neste oppfølgings uke MÅ fylles ut */
    IF NPSHTOPP.neste_oppf_uke:SCREEN-VALUE <= '0' THEN DO:
        IF c_status <> 'ORDRE' AND NOT c_status MATCHES  'Tapt*' AND NOT c_status BEGINS 
            'Plassbygd' AND NOT c_status BEGINS 'Ikke'  THEN
         DO:
            MESSAGE 'Neste oppfølgingsuke MÅ fylles ut!' VIEW-AS ALERT-BOX TITLE 'STOPP!'.
            APPLY "ENTRY" TO NPSHTOPP.neste_oppf_uke.
            RETURN NO-APPLY.
         END.     
     END.
    /* Dersom neste vår kontakt ikke er fylt ut, stopp registrering */
    IF NPSHTOPP.vaar_kontakt:SCREEN-VALUE = ? THEN
        DO:
            MESSAGE 'Vår kontakt MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            APPLY "ENTRY" TO NPSHTOPP.vaar_kontakt.
            RETURN NO-APPLY.
        END.

    cp_tabell_navn  = 'NPSHTOPP'.
    run neste_id.p (input cp_tabell_navn, output ip_neste_id).
    ASSIGN NPSHTOPP.oppf_nr = ip_neste_id.

  Current-Rec = ROWID(NPSHTOPP).
  nyRecord = TRUE.  
  
  /* Dersom STATUS = 'ORDRE'  eller 'Tapt' skal aktivt - flagg for dette anlegget settes til FALSE 
      Dersom STATUS = 'Sikker', sett Sikker - flagget for dette anlegget til TRUE */
  IF c_status = 'ORDRE'  OR c_status BEGINS 'Plassbygd' OR  c_status BEGINS 'Ikke' 
    OR c_status MATCHES 'Tapt*' THEN
    DO:
        FIND NPSHANLG WHERE NPSHANLG.anleggsnr = anleggsnrParam EXCLUSIVE-LOCK NO-ERROR  NO-WAIT.
        IF AVAILABLE NPSHANLG THEN DO:
                ASSIGN NPSHANLG.aktivt = FALSE.       
                cProsjektid = NPSHANLG.prosjektid.
        END.
    END.
  FIND NPSHANLG WHERE NPSHANLG.anleggsnr = anleggsnrParam EXCLUSIVE-LOCK NO-ERROR  NO-WAIT.
  IF AVAILABLE NPSHANLG THEN
    DO:
        IF c_status = 'Sikker' THEN
                ASSIGN sikker = TRUE.       
        ELSE
                ASSIGN sikker = FALSE.
    END.

     /* Dersom ett tilbud får oppfølgingsstatus: Antas, Sikker, Selges, ORDRE, Mulig eller Tvilsom,
     eller Tapt skal oppfølgingsstatus for andre tilbud på dette anlegget settes til Tapt Andre. */
     IF c_status = 'Antas' OR c_status = 'Sikker' OR c_status = 'Selges' OR c_status = 'ORDRE' OR
      c_status = 'Mulig' OR c_status = 'Tvilsom' OR c_status = 'Plassbygd' OR c_status 
      BEGINS 'Ikke'  OR c_status MATCHES 'Tapt*' THEN 
        DO:      
            DEFINE VAR denneOppf AS ROWID.
            DEFINE VAR tilbudsId LIKE NPSHTILBUD.id.
            DEFINE VAR detteTilbud LIKE NPSHTILBUD.id.
            
            /* Husk denne oppfølging, den skal tilbakestilles etterpå  */
            denneOppf = ROWID(NPSHTOPP).
            detteTilbud = NPSHTOPP.id.
            /* Oppdater alle oppfølginger for alle andre tilbud gitt på dette anlegget */
            FOR EACH NPSHTILBUD WHERE NPSHTILBUD.anleggsnr = anleggsnrParam:            
               IF NPSHTILBUD.id <> tilbudsIdParam THEN
                    DO:
                        tilbudsId = NPSHTILBUD.id.                
                        UPDATE  NPSHTOPP SET oppf_status = 'Tapt Andre' 
                        WHERE NPSHTOPP.id = tilbudsId AND NOT oppf_status  BEGINS 'Tapt'.
                    END.
            END.
           /* Sett current til valgt verdi */
          FIND NPSHTOPP WHERE ROWID(NPSHTOPP) = denneOppf  EXCLUSIVE-LOCK.
                ASSIGN NPSHTOPP.oppf_status = c_status.
      END.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHTOPP.neste_oppf_uke
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTOPP.neste_oppf_uke NY-OPPF
ON LEAVE OF NPSHTOPP.neste_oppf_uke IN FRAME NY-OPPF /* Neste oppf.uke */
DO:
  IF INTEGER(SELF:SCREEN-VALUE) > 0 THEN
    DO:
        ASSIGN NPSHTOPP.neste_oppf = DATE("        ").
        DISPLAY NPSHTOPP.neste_oppf WITH FRAME {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHTOPP.oppf_status
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTOPP.oppf_status NY-OPPF
ON VALUE-CHANGED OF NPSHTOPP.oppf_status IN FRAME NY-OPPF /* Status */
DO:
    /* Dersom status = ORDRE eller status = Tapt - set oppf. uke og dato til null */
    DEFINE VAR cStatus AS CHAR.
/*    DEFINE VAR iUke AS INTEGER.
    DEFINE VAR dDato AS DATE. */
            
    cStatus = SELF:SCREEN-VALUE.
/*    IF INTEGER(NPSHTOPP.neste_oppf_uke:SCREEN-VALUE) <> 0 THEN
        iUke = INTEGER(NPSHTOPP.neste_oppf_uke:SCREEN-VALUE).
    IF NPSHTOPP.neste_oppf:SCREEN-VALUE <> "" THEN
        dDato = DATE(NPSHTOPP.neste_oppf:SCREEN-VALUE). */
    IF cStatus = 'ORDRE' OR cStatus BEGINS 'Tapt' THEN
            ASSIGN NPSHTOPP.neste_oppf_uke = 0
                          NPSHTOPP.neste_oppf = DATE("      ").
/*    ELSE
           ASSIGN NPSHTOPP.neste_oppf_uke = iUke
                             NPSHTOPP.neste_oppf = dDato.*/
     DISPLAY NPSHTOPP.neste_oppf_uke NPSHTOPP.neste_oppf 
          WITH FRAME {&FRAME-NAME}.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHTOPP.vaar_kontakt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTOPP.vaar_kontakt NY-OPPF
ON ANY-PRINTABLE OF NPSHTOPP.vaar_kontakt IN FRAME NY-OPPF /* Vår kontakt */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTOPP.vaar_kontakt NY-OPPF
ON CURSOR-DOWN OF NPSHTOPP.vaar_kontakt IN FRAME NY-OPPF /* Vår kontakt */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTOPP.vaar_kontakt NY-OPPF
ON CURSOR-UP OF NPSHTOPP.vaar_kontakt IN FRAME NY-OPPF /* Vår kontakt */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK NY-OPPF 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  SESSION:SET-WAIT-STATE("").   
  hParent = source-procedure.
  current-rec = dynamic-function('getCurrentRec' in hParent).
  nyRecord    = logical(dynamic-function('getNyRecord' in hParent)).
  tilbudsidparam = int(dynamic-function('getAttribute',hParent,'TilbudsIdParam')).
  anleggsNrParam = int(dynamic-function('getAttribute',hParent,'AnleggsNrParam')).
/*  current-tilbud-rec = to-rowid(dynamic-function('getAttribute',hParent,'current-tilbud-rec')).*/
  RUN fyll_combo.
  RUN nyOppf.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI NY-OPPF  _DEFAULT-DISABLE
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
  HIDE FRAME NY-OPPF.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI NY-OPPF  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-NY-OPPF}
  GET FIRST NY-OPPF.
  IF AVAILABLE NPSHTOPP THEN 
    DISPLAY NPSHTOPP.oppf_dato NPSHTOPP.oppf_uke NPSHTOPP.oppf_status 
          NPSHTOPP.kriterium_1 NPSHTOPP.kriterium_2 NPSHTOPP.tiltak 
          NPSHTOPP.neste_oppf_uke NPSHTOPP.neste_oppf NPSHTOPP.neste_oppf_aar 
          NPSHTOPP.notater NPSHTOPP.vaar_kontakt 
      WITH FRAME NY-OPPF.
  ENABLE NPSHTOPP.oppf_dato NPSHTOPP.oppf_uke NPSHTOPP.oppf_status 
         NPSHTOPP.kriterium_1 NPSHTOPP.kriterium_2 NPSHTOPP.tiltak 
         NPSHTOPP.neste_oppf_uke NPSHTOPP.neste_oppf NPSHTOPP.neste_oppf_aar 
         NPSHTOPP.notater NPSHTOPP.vaar_kontakt Btn_OK Btn_Cancel Btn_Help 
         RECT-1 
      WITH FRAME NY-OPPF.
  VIEW FRAME NY-OPPF.
  {&OPEN-BROWSERS-IN-QUERY-NY-OPPF}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_combo NY-OPPF 
PROCEDURE fyll_combo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN  
      NPSHTOPP.vaar_kontakt:DELIMITER = '|'
      NPSHTOPP.vaar_kontakt:LIST-ITEM-pairs = JBoxServerAPI:Instance:FieldList('NPKontakt;Kontaktperson;id','where true').
      .    
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyOppf NY-OPPF 
PROCEDURE nyOppf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR cAnleggsnr AS CHAR.

      iNextId = 0.
     create NPSHTOPP.
     NPSHTOPP.oppf_dato = TODAY.
     NPSHTOPP.id = tilbudsIdParam.
     NPSHTOPP.oppf_nr = iNextId.
     NPSHTOPP.neste_oppf = TODAY + 14.
     NPSHTOPP.neste_oppf_aar = YEAR(TODAY).

 UPDATE 
    NPSHTOPP.oppf_dato NPSHTOPP.oppf_uke NPSHTOPP.oppf_status NPSHTOPP.kriterium_1 
    NPSHTOPP.kriterium_2 NPSHTOPP.tiltak NPSHTOPP.neste_oppf_uke 
    NPSHTOPP.neste_oppf_aar NPSHTOPP.neste_oppf NPSHTOPP.notater
    NPSHTOPP.vaar_kontakt
        Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME NY-OPPF.
  dynamic-function('setCurrentRec' in hParent,rowid(npshtopp)).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

