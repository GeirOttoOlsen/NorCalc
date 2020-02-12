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
DEFINE INPUT PARAMETER appdata AS CHARACTER.
DEFINE SHARED VAR Current-Oppf-Rec AS ROWID.
DEFINE SHARED VAR anleggsnrParam LIKE NPSPANLG.anleggsnr.
DEFINE SHARED VAR tilbudsIdParam LIKE NPSPTILBUD.id.
/* Local Variable Definitions ---                                       */
DEFINE VAR pointer AS LOGICAL.
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME ENDRE-OPPF

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPTOPP

/* Definitions for DIALOG-BOX ENDRE-OPPF                                */
&Scoped-define FIELDS-IN-QUERY-ENDRE-OPPF NPSPTOPP.oppf_dato ~
NPSPTOPP.oppf_uke NPSPTOPP.oppf_status NPSPTOPP.kriterium_1 ~
NPSPTOPP.kriterium_2 NPSPTOPP.tiltak NPSPTOPP.neste_oppf_uke ~
NPSPTOPP.neste_oppf NPSPTOPP.neste_oppf_aar NPSPTOPP.notater ~
NPSPTOPP.vaar_kontakt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-ENDRE-OPPF NPSPTOPP.oppf_dato ~
NPSPTOPP.oppf_uke NPSPTOPP.oppf_status NPSPTOPP.kriterium_1 ~
NPSPTOPP.kriterium_2 NPSPTOPP.tiltak NPSPTOPP.neste_oppf_uke ~
NPSPTOPP.neste_oppf NPSPTOPP.neste_oppf_aar NPSPTOPP.notater ~
NPSPTOPP.vaar_kontakt 
&Scoped-define ENABLED-TABLES-IN-QUERY-ENDRE-OPPF NPSPTOPP
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-ENDRE-OPPF NPSPTOPP

&Scoped-define FIELD-PAIRS-IN-QUERY-ENDRE-OPPF~
 ~{&FP1}oppf_dato ~{&FP2}oppf_dato ~{&FP3}~
 ~{&FP1}oppf_uke ~{&FP2}oppf_uke ~{&FP3}~
 ~{&FP1}neste_oppf_uke ~{&FP2}neste_oppf_uke ~{&FP3}~
 ~{&FP1}neste_oppf ~{&FP2}neste_oppf ~{&FP3}~
 ~{&FP1}neste_oppf_aar ~{&FP2}neste_oppf_aar ~{&FP3}
&Scoped-define OPEN-QUERY-ENDRE-OPPF OPEN QUERY ENDRE-OPPF FOR EACH NPSPTOPP SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-ENDRE-OPPF NPSPTOPP
&Scoped-define FIRST-TABLE-IN-QUERY-ENDRE-OPPF NPSPTOPP


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSPTOPP.oppf_dato NPSPTOPP.oppf_uke ~
NPSPTOPP.oppf_status NPSPTOPP.kriterium_1 NPSPTOPP.kriterium_2 ~
NPSPTOPP.tiltak NPSPTOPP.neste_oppf_uke NPSPTOPP.neste_oppf ~
NPSPTOPP.neste_oppf_aar NPSPTOPP.notater NPSPTOPP.vaar_kontakt 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}oppf_dato ~{&FP2}oppf_dato ~{&FP3}~
 ~{&FP1}oppf_uke ~{&FP2}oppf_uke ~{&FP3}~
 ~{&FP1}neste_oppf_uke ~{&FP2}neste_oppf_uke ~{&FP3}~
 ~{&FP1}neste_oppf ~{&FP2}neste_oppf ~{&FP3}~
 ~{&FP1}neste_oppf_aar ~{&FP2}neste_oppf_aar ~{&FP3}
&Scoped-define ENABLED-TABLES NPSPTOPP
&Scoped-define FIRST-ENABLED-TABLE NPSPTOPP
&Scoped-Define ENABLED-OBJECTS RECT-1 Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPSPTOPP.oppf_dato NPSPTOPP.oppf_uke ~
NPSPTOPP.oppf_status NPSPTOPP.kriterium_1 NPSPTOPP.kriterium_2 ~
NPSPTOPP.tiltak NPSPTOPP.neste_oppf_uke NPSPTOPP.neste_oppf ~
NPSPTOPP.neste_oppf_aar NPSPTOPP.notater NPSPTOPP.vaar_kontakt 

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
     SIZE 117.4 BY 10.1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY ENDRE-OPPF FOR 
      NPSPTOPP SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME ENDRE-OPPF
     NPSPTOPP.oppf_dato AT ROW 1.62 COL 17.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 18 BY 1.24
          FONT 2
     NPSPTOPP.oppf_uke AT ROW 1.71 COL 46 COLON-ALIGNED
          LABEL "Uke"
          VIEW-AS FILL-IN 
          SIZE 5.4 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSPTOPP.oppf_status AT ROW 1.71 COL 63.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ukjent","Antas","Sikker","Selges","ORDRE","Mulig","Tvilsom","Tapt Flamcovent","Tapt Ajevent","Tapt Nonair","Tapt Ukjent","Ikke Realisert","Tapt Andre" 
          SIZE 27.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSPTOPP.kriterium_1 AT ROW 3.05 COL 17.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Pris rett","Pris høy-justeres","Pris høy-uinteressant" 
          SIZE 40.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSPTOPP.kriterium_2 AT ROW 3.05 COL 75.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Relasjon pos.","Relasjon neg.","Leveringstid","Kvalitet","Konsept","For sent" 
          SIZE 40.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSPTOPP.tiltak AT ROW 4.33 COL 17.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Avklares","Informasjon","TLF/FAX/BREV","Besøk","Pleies","Bedres","Endres","Avvise" 
          SIZE 26.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSPTOPP.neste_oppf_uke AT ROW 4.33 COL 65 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.4 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSPTOPP.neste_oppf AT ROW 4.33 COL 78.8 COLON-ALIGNED
          LABEL "Dato"
          VIEW-AS FILL-IN NATIVE 
          SIZE 18 BY 1.24
          FONT 2
     NPSPTOPP.neste_oppf_aar AT ROW 4.33 COL 108.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
     NPSPTOPP.notater AT ROW 5.76 COL 19.8 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 86 BY 3.62
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSPTOPP.vaar_kontakt AT ROW 9.48 COL 17.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","" 
          SIZE 40.8 BY 1
     Btn_OK AT ROW 11.95 COL 42.8
     Btn_Cancel AT ROW 11.95 COL 56.8
     Btn_Help AT ROW 11.95 COL 70.8
     "Notater:" VIEW-AS TEXT
          SIZE 11 BY .76 AT ROW 5.76 COL 8.8
     RECT-1 AT ROW 1.38 COL 2.6
     SPACE(1.80) SKIP(2.32)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Endre Spirovent - Oppfølging"
         CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX ENDRE-OPPF
                                                                        */
ASSIGN 
       FRAME ENDRE-OPPF:SCROLLABLE       = FALSE
       FRAME ENDRE-OPPF:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN NPSPTOPP.neste_oppf IN FRAME ENDRE-OPPF
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSPTOPP.oppf_uke IN FRAME ENDRE-OPPF
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX ENDRE-OPPF
/* Query rebuild information for DIALOG-BOX ENDRE-OPPF
     _TblList          = "norcalc.NPSPTOPP"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX ENDRE-OPPF */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ENDRE-OPPF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ENDRE-OPPF ENDRE-OPPF
ON WINDOW-CLOSE OF FRAME ENDRE-OPPF /* Endre Spirovent - Oppfølging */
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
    IF DATE(NPSPTOPP.oppf_dato:SCREEN-VALUE)  = ?  THEN
        DO:
            MESSAGE 'Oppfølgingsdato MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
             APPLY "ENTRY" TO NPSPTOPP.oppf_dato.
          RETURN NO-APPLY.
        END.

    /* Dersom neste oppf. År ikke er fylt ut, stopp registrering */
    IF INTEGER(NPSPTOPP.neste_oppf_aar:SCREEN-VALUE) = 0 THEN
        DO:
            MESSAGE 'Neste oppfølgingsår MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
             APPLY "ENTRY" TO NPSPTOPP.neste_oppf_aar.
            RETURN NO-APPLY.
        END.
    c_status = NPSPTOPP.oppf_status:SCREEN-VALUE.
    /* Neste oppfølgings uke MÅ fylles ut */
    IF NPSPTOPP.neste_oppf_uke:SCREEN-VALUE <= '0'  THEN DO:
        IF c_status <> 'ORDRE' AND NOT c_status BEGINS 'Tapt' 
          AND NOT c_status = 'Ikke Realisert' THEN
            DO:
                 MESSAGE 'Neste oppfølgingsuke MÅ fylles ut!' VIEW-AS ALERT-BOX TITLE 'STOPP!'.
                APPLY "ENTRY" TO NPSPTOPP.neste_oppf_uke.
                RETURN NO-APPLY.
            END.     
     END.    
    /* Dersom neste vår kontakt ikke er fylt ut, stopp registrering */
    IF NPSPTOPP.vaar_kontakt:SCREEN-VALUE = ? THEN
        DO:
            MESSAGE 'Vår kontakt MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
             APPLY "ENTRY" TO NPSPTOPP.vaar_kontakt.
            RETURN NO-APPLY.
        END.


    i_id = NPSPTOPP.id.
    
  /* Dersom STATUS = 'ORDRE'  eller 'Tapt' skal aktivt - flagg for dette anlegget settes til FALSE 
       Dersom status = 'Sikker' skal Sikker-flagget for anlegget settes til TRUE */
  IF c_status = 'ORDRE'  OR c_status BEGINS 'Ikke' OR c_status MATCHES 'Tapt*' THEN
    DO:
        FIND NPSPANLG WHERE NPSPANLG.anleggsnr = anleggsnrParam EXCLUSIVE-LOCK NO-ERROR  NO-WAIT.
        IF AVAILABLE NPSPANLG THEN
                ASSIGN NPSPANLG.aktivt = FALSE.
    END.  
  FIND NPSPANLG WHERE NPSPANLG.anleggsnr = anleggsnrParam EXCLUSIVE-LOCK NO-ERROR  NO-WAIT.
  IF AVAILABLE NPSPANLG THEN
    DO:
        IF c_status = 'Sikker' THEN
                ASSIGN sikker = TRUE.       
        ELSE
                ASSIGN sikker = FALSE.
    END.
    
 /* Dersom ett tilbud får oppfølgingsstatus: Antas, Sikker, Selges, ORDRE, Mulig eller Tvilsom,
 skal oppfølgingsstatus for andre tilbud på dette anlegget settes til Tapt Andre. */
 IF c_status = 'Antas' OR c_status = 'Sikker' OR c_status = 'Selges' OR c_status = 'ORDRE' OR
      c_status = 'Mulig' OR c_status = 'Tvilsom' OR c_status BEGINS 'Ikke' OR 
      c_status MATCHES 'Tapt*' THEN
        DO:      
            DEFINE VAR denneOppf AS ROWID.
            DEFINE VAR tilbudsId LIKE NPSPTILBUD.id.
            /* Husk denne oppfølging, den skal tilbakestilles etterpå  */
            denneOppf = ROWID(NPSPTOPP).
            /* Oppdater alle oppfølginger for alle tilbud gitt på dette anlegget */
            FOR EACH NPSPTILBUD WHERE NPSPTILBUD.anleggsnr = anleggsnrParam:            
                IF NPSPTILBUD.id <> tilbudsidParam THEN
                    DO:
                        tilbudsId = NPSPTILBUD.id.                
                        UPDATE  NPSPTOPP SET oppf_status = 'Tapt Andre' 
                        WHERE NPSPTOPP.id = tilbudsId.
                    END.
            END.
           /* Sett current til valgt verdi */
          FIND NPSPTOPP WHERE ROWID(NPSPTOPP) = denneOppf  EXCLUSIVE-LOCK.
                ASSIGN NPSPTOPP.oppf_status = c_status.
      END.       

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPTOPP.neste_oppf_uke
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPTOPP.neste_oppf_uke ENDRE-OPPF
ON LEAVE OF NPSPTOPP.neste_oppf_uke IN FRAME ENDRE-OPPF /* Neste oppf.uke */
DO:
  IF INTEGER(SELF:SCREEN-VALUE) > 0 THEN
    DO:
        ASSIGN NPSPTOPP.neste_oppf = DATE("").
        DISPLAY NPSPTOPP.neste_oppf WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPTOPP.oppf_status
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPTOPP.oppf_status ENDRE-OPPF
ON VALUE-CHANGED OF NPSPTOPP.oppf_status IN FRAME ENDRE-OPPF /* Status */
DO:
    /* Dersom status = ORDRE eller status = Tapt - set oppf. uke og dato til null */
    DEFINE VAR cStatus AS CHAR.
/*    DEFINE VAR iUke AS INTEGER.
    DEFINE VAR dDato AS DATE. */
            
    cStatus = SELF:SCREEN-VALUE.
/*    IF INTEGER(NPSPTOPP.neste_oppf_uke:SCREEN-VALUE) <> 0 THEN
        iUke = INTEGER(NPSPTOPP.neste_oppf_uke:SCREEN-VALUE).
    IF NPSPTOPP.neste_oppf:SCREEN-VALUE <> "" THEN
        dDato = DATE(NPSPTOPP.neste_oppf:SCREEN-VALUE). */
    IF cStatus = 'ORDRE' OR cStatus BEGINS 'Tapt' THEN
            ASSIGN NPSPTOPP.neste_oppf_uke = 0
                          NPSPTOPP.neste_oppf = DATE("      ").
/*    ELSE
           ASSIGN NPSPTOPP.neste_oppf_uke = iUke
                             NPSPTOPP.neste_oppf = dDato.*/
     DISPLAY NPSPTOPP.neste_oppf_uke NPSPTOPP.neste_oppf 
          WITH FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPTOPP.vaar_kontakt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPTOPP.vaar_kontakt ENDRE-OPPF
ON ANY-PRINTABLE OF NPSPTOPP.vaar_kontakt IN FRAME ENDRE-OPPF /* Vår kontakt */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPTOPP.vaar_kontakt ENDRE-OPPF
ON CURSOR-DOWN OF NPSPTOPP.vaar_kontakt IN FRAME ENDRE-OPPF /* Vår kontakt */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPTOPP.vaar_kontakt ENDRE-OPPF
ON CURSOR-UP OF NPSPTOPP.vaar_kontakt IN FRAME ENDRE-OPPF /* Vår kontakt */
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
  pointer = SESSION:SET-WAIT-STATE("").   
   RUN fyll_combo.
  RUN endreOppf.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI ENDRE-OPPF _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI ENDRE-OPPF _DEFAULT-ENABLE
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
  IF AVAILABLE NPSPTOPP THEN 
    DISPLAY NPSPTOPP.oppf_dato NPSPTOPP.oppf_uke NPSPTOPP.oppf_status 
          NPSPTOPP.kriterium_1 NPSPTOPP.kriterium_2 NPSPTOPP.tiltak 
          NPSPTOPP.neste_oppf_uke NPSPTOPP.neste_oppf NPSPTOPP.neste_oppf_aar 
          NPSPTOPP.notater NPSPTOPP.vaar_kontakt 
      WITH FRAME ENDRE-OPPF.
  ENABLE RECT-1 NPSPTOPP.oppf_dato NPSPTOPP.oppf_uke NPSPTOPP.oppf_status 
         NPSPTOPP.kriterium_1 NPSPTOPP.kriterium_2 NPSPTOPP.tiltak 
         NPSPTOPP.neste_oppf_uke NPSPTOPP.neste_oppf NPSPTOPP.neste_oppf_aar 
         NPSPTOPP.notater NPSPTOPP.vaar_kontakt Btn_OK Btn_Cancel Btn_Help 
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
FIND NPSPTOPP WHERE ROWID(NPSPTOPP) = Current-Oppf-Rec EXCLUSIVE-LOCK 
    NO-WAIT  NO-ERROR.
IF AVAILABLE NPSPTOPP THEN
 UPDATE 
    NPSPTOPP.oppf_dato NPSPTOPP.oppf_uke NPSPTOPP.oppf_status NPSPTOPP.kriterium_1 
    NPSPTOPP.kriterium_2 NPSPTOPP.tiltak NPSPTOPP.neste_oppf_uke
    NPSPTOPP.neste_oppf NPSPTOPP.neste_oppf_aar  NPSPTOPP.notater
    NPSPTOPP.vaar_kontakt
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
    temp-string = "".
    FOR EACH NPKONTAKT:
         IF temp-string = ""
        THEN temp-string = NPKONTAKT.kontaktperson.
        ELSE temp-string = temp-string + "," + NPKONTAKT.kontaktperson.
    END.
    /* Legg til en blank post */
    temp-string = temp-string + "," + " ".

    ASSIGN NPSPTOPP.vaar_kontakt:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


