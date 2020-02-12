&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME ENDRE-OPPF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS ENDRE-OPPF 
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
/*DEFINE SHARED VAR anleggsnrParam LIKE NPSHANLG.anleggsnr.*/
/*DEFINE SHARED VAR tilbudsIdParam LIKE NPSHTILBUD.id.     */
/* Local Variable Definitions ---                                       */
def var hParent as handle no-undo.
def var current-rec as rowid no-undo.
def var anleggsNrParam like npshanlg.anleggsnr.
def var TilbudsIdParam like npshtilbud.id.
def var i as int no-undo.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME ENDRE-OPPF

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHTOPP

/* Definitions for DIALOG-BOX ENDRE-OPPF                                */
&Scoped-define FIELDS-IN-QUERY-ENDRE-OPPF NPSHTOPP.oppf_dato ~
NPSHTOPP.oppf_uke NPSHTOPP.oppf_status NPSHTOPP.kriterium_1 ~
NPSHTOPP.kriterium_2 NPSHTOPP.tiltak NPSHTOPP.neste_oppf_uke ~
NPSHTOPP.neste_oppf NPSHTOPP.neste_oppf_aar NPSHTOPP.notater ~
NPSHTOPP.vaar_kontakt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-ENDRE-OPPF NPSHTOPP.oppf_dato ~
NPSHTOPP.oppf_uke NPSHTOPP.oppf_status NPSHTOPP.kriterium_1 ~
NPSHTOPP.kriterium_2 NPSHTOPP.tiltak NPSHTOPP.neste_oppf_uke ~
NPSHTOPP.neste_oppf NPSHTOPP.neste_oppf_aar NPSHTOPP.notater ~
NPSHTOPP.vaar_kontakt 
&Scoped-define ENABLED-TABLES-IN-QUERY-ENDRE-OPPF NPSHTOPP
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-ENDRE-OPPF NPSHTOPP
&Scoped-define QUERY-STRING-ENDRE-OPPF FOR EACH NPSHTOPP SHARE-LOCK
&Scoped-define OPEN-QUERY-ENDRE-OPPF OPEN QUERY ENDRE-OPPF FOR EACH NPSHTOPP SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-ENDRE-OPPF NPSHTOPP
&Scoped-define FIRST-TABLE-IN-QUERY-ENDRE-OPPF NPSHTOPP


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
     SIZE 10.2 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 8 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 8 BY 1.1
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 112.4 BY 11.38.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY ENDRE-OPPF FOR 
      NPSHTOPP SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME ENDRE-OPPF
     NPSHTOPP.oppf_dato AT ROW 2.1 COL 25.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.oppf_uke AT ROW 2.1 COL 51 COLON-ALIGNED
          LABEL "Uke"
          VIEW-AS FILL-IN 
          SIZE 4.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.oppf_status AT ROW 1.95 COL 73.6 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ukjent","Antas","Sikker","Selges","ORDRE","Mulig","Tvilsom","Tapt ABS","Tapt L&G","Tapt T&A","Tapt TTM","Plassbygd","Tapt Ukjent","Ikke Realisert","Tapt Andre" 
          DROP-DOWN-LIST
          SIZE 29.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.kriterium_1 AT ROW 3.24 COL 25 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Pris rett","Pris høy-justeres","Pris høy-uinteressant" 
          DROP-DOWN-LIST
          SIZE 29.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.kriterium_2 AT ROW 3.24 COL 73.6 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Relasjon pos.","Relasjon neg.","Leveringstid","Kvalitet","Konsept","For sent" 
          DROP-DOWN-LIST
          SIZE 29.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.tiltak AT ROW 4.33 COL 25.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Avklares","Informasjon","TLF/FAX/BREV","Besøk","Pleies","Bedres","Endres","Avvise" 
          DROP-DOWN-LIST
          SIZE 28.8 BY 1.05
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.neste_oppf_uke AT ROW 5.76 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.neste_oppf AT ROW 5.76 COL 39 COLON-ALIGNED
          LABEL "Dato"
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.neste_oppf_aar AT ROW 5.76 COL 60 COLON-ALIGNED
          LABEL "år"
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.8 BY 1
     NPSHTOPP.notater AT ROW 7.19 COL 27 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 85 BY 3.86
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHTOPP.vaar_kontakt AT ROW 11.19 COL 25.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 8
          DROP-DOWN-LIST
          SIZE 29.2 BY 1.05
     Btn_OK AT ROW 12.91 COL 44
     Btn_Cancel AT ROW 12.91 COL 54
     Btn_Help AT ROW 12.95 COL 66.6
     "Notater:" VIEW-AS TEXT
          SIZE 10 BY .62 AT ROW 7.19 COL 17
     RECT-1 AT ROW 1.29 COL 1.6
     SPACE(0.79) SKIP(1.80)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Endre Shunt - Oppfølging"
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
/* SETTINGS FOR DIALOG-BOX ENDRE-OPPF
   Custom                                                               */
ASSIGN 
       FRAME ENDRE-OPPF:SCROLLABLE       = FALSE
       FRAME ENDRE-OPPF:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN NPSHTOPP.neste_oppf IN FRAME ENDRE-OPPF
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHTOPP.neste_oppf_aar IN FRAME ENDRE-OPPF
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHTOPP.oppf_uke IN FRAME ENDRE-OPPF
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX ENDRE-OPPF
/* Query rebuild information for DIALOG-BOX ENDRE-OPPF
     _TblList          = "norcalc.NPSHTOPP"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX ENDRE-OPPF */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ENDRE-OPPF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ENDRE-OPPF ENDRE-OPPF
ON WINDOW-CLOSE OF FRAME ENDRE-OPPF /* Endre Shunt - Oppfølging */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help ENDRE-OPPF
ON CHOOSE OF Btn_Help IN FRAME ENDRE-OPPF /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK ENDRE-OPPF
ON CHOOSE OF Btn_OK IN FRAME ENDRE-OPPF /* OK */
DO:
    DEFINE VAR c_status AS CHAR.
    DEFINE VAR i_id AS INTEGER.
    DEFINE VAR cProsjektId LIKE NORPROSJEKT.prosjektid.

    /* Dersom oppfølgingsdato ikke er fylt ut, stopp registrering */
    IF DATE(NPSHTOPP.oppf_dato:SCREEN-VALUE)  = ?  THEN
        DO:
            MESSAGE 'Oppfølgingsdato MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
           APPLY "ENTRY" TO NPSHTOPP.oppf_dato.
          RETURN NO-APPLY.
        END.

    /* Dersom neste oppf. år ikke er fylt ut, stopp registrering */
    IF INTEGER(NPSHTOPP.neste_oppf_aar:SCREEN-VALUE) = 0 THEN
        DO:
            MESSAGE 'Neste oppfølgingsår MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            APPLY "ENTRY" TO NPSHTOPP.neste_oppf_aar.
            RETURN NO-APPLY.
        END.
    c_status = NPSHTOPP.oppf_status:SCREEN-VALUE.
    /* Neste oppfølgings uke MÅ fylles ut */
    IF NPSHTOPP.neste_oppf_uke:SCREEN-VALUE <= '0'  THEN DO:
        IF c_status <> 'ORDRE' AND NOT c_status MATCHES  'Tapt*' AND NOT c_status 
            BEGINS 'Plassbygd' AND NOT c_status BEGINS 'Ikke' THEN
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
    
    i_id = NPSHTOPP.id.
    
  /* Dersom STATUS = 'ORDRE'  eller 'Tapt' skal aktivt - flagg for dette anlegget settes til FALSE 
       Dersom status = 'Sikker' skal Sikker-flagget for anlegget settes til TRUE */
  IF c_status = 'ORDRE'  OR c_status BEGINS 'Plassbygd'  OR c_status BEGINS 'Ikke' 
    OR c_status MATCHES 'Tapt*' THEN
    DO:
        FIND NPSHANLG WHERE NPSHANLG.anleggsnr = anleggsnrParam EXCLUSIVE-LOCK NO-ERROR  NO-WAIT.
        IF AVAILABLE NPSHANLG THEN
                ASSIGN NPSHANLG.aktivt = FALSE.
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
 skal oppfølgingsstatus for andre tilbud på dette anlegget settes til Tapt Andre. */

 IF c_status = 'Antas' OR c_status = 'Sikker' OR c_status = 'Selges' OR c_status = 'ORDRE' OR
      c_status = 'Mulig' OR c_status = 'Tvilsom' OR c_status BEGINS 'Plassbygd'  OR
      c_status BEGINS 'Ikke'  OR c_status MATCHES 'Tapt*' THEN
        DO:      
            DEFINE VAR denneOppf AS ROWID.
            DEFINE VAR tilbudsId LIKE NPSHTILBUD.id.
            /* Husk denne oppfølging, den skal tilbakestilles etterpå  */
            denneOppf = ROWID(NPSHTOPP).
            /* Oppdater alle oppfølginger for alle tilbud gitt på dette anlegget */
            FOR EACH NPSHTILBUD WHERE NPSHTILBUD.anleggsnr = anleggsnrParam:            
                IF NPSHTILBUD.id <> tilbudsIdParam THEN
                    DO:
                        tilbudsId = NPSHTILBUD.id.                
                        UPDATE  NPSHTOPP SET oppf_status = 'Tapt Andre'   
                            WHERE NPSHTOPP.id = tilbudsId.
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTOPP.neste_oppf_uke ENDRE-OPPF
ON LEAVE OF NPSHTOPP.neste_oppf_uke IN FRAME ENDRE-OPPF /* Neste oppf.uke */
DO:
  IF INTEGER(SELF:SCREEN-VALUE) > 0 THEN
    DO:
        ASSIGN NPSHTOPP.neste_oppf = DATE("").
        DISPLAY NPSHTOPP.neste_oppf WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHTOPP.oppf_status
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTOPP.oppf_status ENDRE-OPPF
ON VALUE-CHANGED OF NPSHTOPP.oppf_status IN FRAME ENDRE-OPPF /* Status */
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTOPP.vaar_kontakt ENDRE-OPPF
ON ANY-PRINTABLE OF NPSHTOPP.vaar_kontakt IN FRAME ENDRE-OPPF /* Vår kontakt */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTOPP.vaar_kontakt ENDRE-OPPF
ON CURSOR-DOWN OF NPSHTOPP.vaar_kontakt IN FRAME ENDRE-OPPF /* Vår kontakt */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTOPP.vaar_kontakt ENDRE-OPPF
ON CURSOR-UP OF NPSHTOPP.vaar_kontakt IN FRAME ENDRE-OPPF /* Vår kontakt */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK ENDRE-OPPF 


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
  anleggsnrParam = int(dynamic-function('getAttribute',hParent,'anleggsnrParam')).
   RUN fyll_combo.
  RUN endreOppf.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI ENDRE-OPPF  _DEFAULT-DISABLE
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
  HIDE FRAME ENDRE-OPPF.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI ENDRE-OPPF  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-ENDRE-OPPF}
  GET FIRST ENDRE-OPPF.
  IF AVAILABLE NPSHTOPP THEN 
    DISPLAY NPSHTOPP.oppf_dato NPSHTOPP.oppf_uke NPSHTOPP.oppf_status 
          NPSHTOPP.kriterium_1 NPSHTOPP.kriterium_2 NPSHTOPP.tiltak 
          NPSHTOPP.neste_oppf_uke NPSHTOPP.neste_oppf NPSHTOPP.neste_oppf_aar 
          NPSHTOPP.notater NPSHTOPP.vaar_kontakt 
      WITH FRAME ENDRE-OPPF.
  ENABLE NPSHTOPP.oppf_dato NPSHTOPP.oppf_uke NPSHTOPP.oppf_status 
         NPSHTOPP.kriterium_1 NPSHTOPP.kriterium_2 NPSHTOPP.tiltak 
         NPSHTOPP.neste_oppf_uke NPSHTOPP.neste_oppf NPSHTOPP.neste_oppf_aar 
         NPSHTOPP.notater NPSHTOPP.vaar_kontakt Btn_OK Btn_Cancel Btn_Help 
         RECT-1 
      WITH FRAME ENDRE-OPPF.
  VIEW FRAME ENDRE-OPPF.
  {&OPEN-BROWSERS-IN-QUERY-ENDRE-OPPF}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreOppf ENDRE-OPPF 
PROCEDURE endreOppf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND NPSHTOPP WHERE ROWID(NPSHTOPP) = Current-Rec EXCLUSIVE-LOCK 
    NO-WAIT  NO-ERROR.
IF AVAILABLE NPSHTOPP THEN
 UPDATE 
    NPSHTOPP.oppf_dato NPSHTOPP.oppf_uke NPSHTOPP.oppf_status NPSHTOPP.kriterium_1 
    NPSHTOPP.kriterium_2 NPSHTOPP.tiltak NPSHTOPP.neste_oppf_uke 
    NPSHTOPP.neste_oppf NPSHTOPP.neste_oppf_aar NPSHTOPP.notater
    NPSHTOPP.vaar_kontakt
        Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME ENDRE-OPPF.
ELSE
    MESSAGE 'Oppfølgingstabellen er opptatt. Prøv senere.' VIEW-AS ALERT-BOX TITLE 'STOPP'.
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_combo ENDRE-OPPF 
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

