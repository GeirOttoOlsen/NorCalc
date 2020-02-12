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
DEFINE INPUT PARAMETER appdata AS CHARACTER.
DEFINE SHARED VAR Current-Oppf-Rec AS ROWID.
DEFINE SHARED VAR nyRecord AS LOGICAL.
DEFINE SHARED VAR tilbudsIdParam LIKE NPAGTILBUD.id.
DEFINE SHARED VAR anleggsnrParam LIKE NPAGANLG.anleggsnr.

/* Local Variable Definitions ---                                       */
DEFINE VAR iNextId AS INTEGER.
DEFINE VAR pointer AS LOGICAL.
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME NY-OPPF

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPAGTOPP

/* Definitions for DIALOG-BOX NY-OPPF                                   */
&Scoped-define FIELDS-IN-QUERY-NY-OPPF NPAGTOPP.oppf_uke ~
NPAGTOPP.oppf_status NPAGTOPP.oppf_dato NPAGTOPP.kriterium_1 ~
NPAGTOPP.kriterium_2 NPAGTOPP.neste_oppf_aar NPAGTOPP.tiltak ~
NPAGTOPP.neste_oppf_uke NPAGTOPP.neste_oppf NPAGTOPP.notater ~
NPAGTOPP.vaar_kontakt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-NY-OPPF NPAGTOPP.oppf_uke ~
NPAGTOPP.oppf_status NPAGTOPP.oppf_dato NPAGTOPP.kriterium_1 ~
NPAGTOPP.kriterium_2 NPAGTOPP.neste_oppf_aar NPAGTOPP.tiltak ~
NPAGTOPP.neste_oppf_uke NPAGTOPP.neste_oppf NPAGTOPP.notater ~
NPAGTOPP.vaar_kontakt 
&Scoped-define ENABLED-TABLES-IN-QUERY-NY-OPPF NPAGTOPP
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-NY-OPPF NPAGTOPP

&Scoped-define FIELD-PAIRS-IN-QUERY-NY-OPPF~
 ~{&FP1}oppf_uke ~{&FP2}oppf_uke ~{&FP3}~
 ~{&FP1}oppf_dato ~{&FP2}oppf_dato ~{&FP3}~
 ~{&FP1}neste_oppf_aar ~{&FP2}neste_oppf_aar ~{&FP3}~
 ~{&FP1}neste_oppf_uke ~{&FP2}neste_oppf_uke ~{&FP3}~
 ~{&FP1}neste_oppf ~{&FP2}neste_oppf ~{&FP3}
&Scoped-define OPEN-QUERY-NY-OPPF OPEN QUERY NY-OPPF FOR EACH NPAGTOPP SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-NY-OPPF NPAGTOPP
&Scoped-define FIRST-TABLE-IN-QUERY-NY-OPPF NPAGTOPP


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPAGTOPP.oppf_uke NPAGTOPP.oppf_status ~
NPAGTOPP.oppf_dato NPAGTOPP.kriterium_1 NPAGTOPP.kriterium_2 ~
NPAGTOPP.neste_oppf_aar NPAGTOPP.tiltak NPAGTOPP.neste_oppf_uke ~
NPAGTOPP.neste_oppf NPAGTOPP.notater NPAGTOPP.vaar_kontakt 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}oppf_uke ~{&FP2}oppf_uke ~{&FP3}~
 ~{&FP1}oppf_dato ~{&FP2}oppf_dato ~{&FP3}~
 ~{&FP1}neste_oppf_aar ~{&FP2}neste_oppf_aar ~{&FP3}~
 ~{&FP1}neste_oppf_uke ~{&FP2}neste_oppf_uke ~{&FP3}~
 ~{&FP1}neste_oppf ~{&FP2}neste_oppf ~{&FP3}
&Scoped-define ENABLED-TABLES NPAGTOPP
&Scoped-define FIRST-ENABLED-TABLE NPAGTOPP
&Scoped-Define ENABLED-OBJECTS RECT-1 Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPAGTOPP.oppf_uke NPAGTOPP.oppf_status ~
NPAGTOPP.oppf_dato NPAGTOPP.kriterium_1 NPAGTOPP.kriterium_2 ~
NPAGTOPP.neste_oppf_aar NPAGTOPP.tiltak NPAGTOPP.neste_oppf_uke ~
NPAGTOPP.neste_oppf NPAGTOPP.notater NPAGTOPP.vaar_kontakt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 10.8 BY 1.1
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
     SIZE 113.8 BY 10.43.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY NY-OPPF FOR 
      NPAGTOPP SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME NY-OPPF
     NPAGTOPP.oppf_uke AT ROW 2.67 COL 50 COLON-ALIGNED
          LABEL "Uke"
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPAGTOPP.oppf_status AT ROW 2.67 COL 67.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ukjent","Antas","Sikker","Selges","ORDRE","Mulig","Tvilsom","Tapt NVP","Tapt NOVEMA","Tapt COVENT","Tapt ABB","Tapt PMluft","Tapt IV","Tapt Norse Block","Tapt WOLF","Tapt Ukjent","Ikke Realisert","Tapt Andre" 
          SIZE 28.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPAGTOPP.oppf_dato AT ROW 2.81 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          FONT 2
     NPAGTOPP.kriterium_1 AT ROW 3.95 COL 22 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Pris rett","Pris høy-justeres","Pris høy-uinteressant" 
          SIZE 29.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPAGTOPP.kriterium_2 AT ROW 3.95 COL 67.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Relasjon pos.","Relasjon neg.","Leveringstid","Kvalitet","Konsept","For sent" 
          SIZE 29.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPAGTOPP.neste_oppf_aar AT ROW 5.24 COL 102 COLON-ALIGNED
          LABEL "år"
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.2 BY 1
     NPAGTOPP.tiltak AT ROW 5.29 COL 22 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","Avklares","Informasjon","TLF/FAX/BREV","Besøk","Pleies","Bedres","Endres","Avvise" 
          SIZE 19.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPAGTOPP.neste_oppf_uke AT ROW 5.29 COL 67.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.6 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPAGTOPP.neste_oppf AT ROW 5.29 COL 80.8 COLON-ALIGNED
          LABEL "Dato"
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          FONT 2
     NPAGTOPP.notater AT ROW 6.62 COL 24 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 87.8 BY 3.91
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPAGTOPP.vaar_kontakt AT ROW 10.76 COL 22 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","" 
          SIZE 29.2 BY 1
     Btn_OK AT ROW 12.91 COL 47
     Btn_Cancel AT ROW 12.91 COL 57
     Btn_Help AT ROW 12.91 COL 70.2
     "Notater:" VIEW-AS TEXT
          SIZE 10.2 BY .62 AT ROW 6.86 COL 13.4
     RECT-1 AT ROW 2 COL 2.8
     SPACE(6.39) SKIP(2.18)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Ny Aggregat - Oppfølging"
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
/* SETTINGS FOR DIALOG-BOX NY-OPPF
                                                                        */
ASSIGN 
       FRAME NY-OPPF:SCROLLABLE       = FALSE
       FRAME NY-OPPF:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN NPAGTOPP.neste_oppf IN FRAME NY-OPPF
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPAGTOPP.neste_oppf_aar IN FRAME NY-OPPF
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPAGTOPP.oppf_uke IN FRAME NY-OPPF
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX NY-OPPF
/* Query rebuild information for DIALOG-BOX NY-OPPF
     _TblList          = "norcalc.NPAGTOPP"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX NY-OPPF */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME NY-OPPF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NY-OPPF NY-OPPF
ON WINDOW-CLOSE OF FRAME NY-OPPF /* Ny Aggregat - Oppfølging */
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
    define var ip_neste_id as integer initial 0.
    define var c_status as char.
    define var cProsjektId  like norprosjekt.prosjektid.

    /* Dersom oppfølgingsdato ikke er fylt ut, stopp registrering */
    IF DATE(NPAGTOPP.oppf_dato:SCREEN-VALUE)  = ?  THEN
        DO:
            MESSAGE 'Oppfølgingsdato MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            APPLY "ENTRY" TO NPAGTOPP.oppf_dato.
            RETURN NO-APPLY.
        END.
            
    /* Dersom neste oppf. år ikke er fylt ut, stopp registrering */
    IF INTEGER(NPAGTOPP.neste_oppf_aar:SCREEN-VALUE) = 0 THEN
        DO:
            MESSAGE 'Neste oppfølgingsår MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            APPLY "ENTRY" TO NPAGTOPP.neste_oppf_aar.
            RETURN NO-APPLY.
        END.
   c_status = NPAGTOPP.oppf_status:SCREEN-VALUE.
    /* Dersom status ikke er ORDRE eller TAPT , Må neste oppfølgings uke fylles ut */
    IF NPAGTOPP.neste_oppf_uke:SCREEN-VALUE <= '0' THEN DO:
          IF c_status <> 'ORDRE' AND  NOT c_status BEGINS 'Tapt' 
            AND NOT c_status = 'Ikke Realisert' THEN
            DO:
                MESSAGE 'Neste oppfølgingsuke MÅ fylles ut!' VIEW-AS ALERT-BOX TITLE 'STOPP!'.
              APPLY "ENTRY" TO NPAGTOPP.neste_oppf_uke.
              RETURN NO-APPLY.
            END.     
    END.
    /* Dersom neste vår kontakt ikke er fylt ut, stopp registrering */
    IF NPAGTOPP.vaar_kontakt:SCREEN-VALUE = ? THEN
        DO:
            MESSAGE 'Vår kontakt MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            APPLY "ENTRY" TO NPAGTOPP.vaar_kontakt.
            RETURN NO-APPLY.
        END.

    cp_tabell_navn  = 'NPAGTOPP'.
    run neste_id.p (input cp_tabell_navn, output ip_neste_id).
    IF ip_neste_id = 0 THEN
    DO:
        MESSAGE 'Kunne ikke tilordne primærnøkkel' VIEW-AS ALERT-BOX TITLE 'Stopp'.
        APPLY "WINDOW-CLOSE" TO {&WINDOW-NAME}.
    END.
    ASSIGN NPAGTOPP.oppf_nr = ip_neste_id.

  Current-Oppf-Rec = ROWID(NPAGTOPP).
  nyRecord = TRUE.  
  
  /* Dersom STATUS = 'ORDRE'  eller 'Tapt' skal aktivt - flagg for dette anlegget settes til FALSE 
      Dersom STATUS = 'Sikker', sett Sikker - flagget for dette anlegget til TRUE */
  IF c_status = 'ORDRE'  OR c_status BEGINS 'Plassbygd' OR  c_status BEGINS 'Ikke' 
    OR c_status MATCHES 'Tapt*' THEN
    DO:
    
/*    message c_status view-as alert-box.*/
        FIND NPAGANLG WHERE NPAGANLG.anleggsnr = anleggsnrParam EXCLUSIVE-LOCK NO-ERROR  NO-WAIT.
        IF AVAILABLE NPAGANLG THEN DO:
                ASSIGN NPAGANLG.aktivt = FALSE.       
                cProsjektid = NPAGANLG.prosjektid.
                IF c_status = 'Sikker' THEN
                    ASSIGN sikker = TRUE.       
                ELSE
                    ASSIGN sikker = FALSE.
         END.
    END.

     /* Dersom ett tilbud får oppfølgingsstatus: Antas, Sikker, Selges, ORDRE, Mulig eller Tvilsom,
     eller Tapt skal oppfølgingsstatus for andre tilbud på dette anlegget settes til Tapt Andre. */
     IF c_status = 'Antas' OR c_status = 'Sikker' OR c_status = 'Selges' OR c_status = 'ORDRE' OR
      c_status = 'Mulig' OR c_status = 'Tvilsom' OR c_status = 'Plassbygd' OR c_status 
      BEGINS 'Ikke'  OR c_status MATCHES 'Tapt*' THEN 
        DO:      
            DEFINE VAR denneOppf AS ROWID.
            DEFINE VAR tilbudsId LIKE NPAGTILBUD.id.
            DEFINE VAR detteTilbud LIKE NPAGTILBUD.id.
            
            /* Husk denne oppfølging, den skal tilbakestilles etterpå  */
            denneOppf = ROWID(NPAGTOPP).
            detteTilbud = NPAGTOPP.id.
            /* Oppdater alle oppfølginger for alle andre tilbud gitt på dette anlegget */
            FOR EACH NPAGTILBUD WHERE NPAGTILBUD.anleggsnr = anleggsnrParam:            
               IF NPAGTILBUD.id <> tilbudsIdParam THEN
                    DO:
                        tilbudsId = NPAGTILBUD.id.                
                        UPDATE  NPAGTOPP SET oppf_status = 'Tapt Andre' 
                        WHERE NPAGTOPP.id = tilbudsId AND NOT oppf_status  BEGINS 'Tapt'.
                    END.
            END.
           /* Sett current til valgt verdi */
          FIND NPAGTOPP WHERE ROWID(NPAGTOPP) = denneOppf  EXCLUSIVE-LOCK.
                ASSIGN NPAGTOPP.oppf_status = c_status.
      END.       
      
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGTOPP.neste_oppf_uke
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGTOPP.neste_oppf_uke NY-OPPF
ON LEAVE OF NPAGTOPP.neste_oppf_uke IN FRAME NY-OPPF /* Neste oppf.uke */
DO:
  IF INTEGER(SELF:SCREEN-VALUE) > 0 THEN
    DO:
        ASSIGN NPAGTOPP.neste_oppf = DATE("        ").
        DISPLAY NPAGTOPP.neste_oppf WITH FRAME {&FRAME-NAME}.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGTOPP.oppf_status
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGTOPP.oppf_status NY-OPPF
ON VALUE-CHANGED OF NPAGTOPP.oppf_status IN FRAME NY-OPPF /* Status */
DO:
    /* Dersom status = ORDRE eller status = Tapt - set oppf. uke og dato til null */
    DEFINE VAR cStatus AS CHAR.
/*    DEFINE VAR iUke AS INTEGER.
    DEFINE VAR dDato AS DATE. */
            
    cStatus = SELF:SCREEN-VALUE.
/*    IF INTEGER(NPAGTOPP.neste_oppf_uke:SCREEN-VALUE) <> 0 THEN
        iUke = INTEGER(NPAGTOPP.neste_oppf_uke:SCREEN-VALUE).
    IF NPAGTOPP.neste_oppf:SCREEN-VALUE <> "" THEN
        dDato = DATE(NPAGTOPP.neste_oppf:SCREEN-VALUE). */
    IF cStatus = 'ORDRE' OR cStatus BEGINS 'Tapt' THEN
            ASSIGN NPAGTOPP.neste_oppf_uke = 0
                          NPAGTOPP.neste_oppf = DATE("      ").
/*    ELSE
           ASSIGN NPAGTOPP.neste_oppf_uke = iUke
                             NPAGTOPP.neste_oppf = dDato.*/
     DISPLAY NPAGTOPP.neste_oppf_uke NPAGTOPP.neste_oppf 
          WITH FRAME {&FRAME-NAME}.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGTOPP.vaar_kontakt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGTOPP.vaar_kontakt NY-OPPF
ON ANY-PRINTABLE OF NPAGTOPP.vaar_kontakt IN FRAME NY-OPPF /* Vår kontakt */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGTOPP.vaar_kontakt NY-OPPF
ON CURSOR-DOWN OF NPAGTOPP.vaar_kontakt IN FRAME NY-OPPF /* Vår kontakt */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGTOPP.vaar_kontakt NY-OPPF
ON CURSOR-UP OF NPAGTOPP.vaar_kontakt IN FRAME NY-OPPF /* Vår kontakt */
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
  pointer = SESSION:SET-WAIT-STATE("").   
   RUN fyll_combo.
  RUN nyOppf.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI NY-OPPF _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI NY-OPPF _DEFAULT-ENABLE
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
  IF AVAILABLE NPAGTOPP THEN 
    DISPLAY NPAGTOPP.oppf_uke NPAGTOPP.oppf_status NPAGTOPP.oppf_dato 
          NPAGTOPP.kriterium_1 NPAGTOPP.kriterium_2 NPAGTOPP.neste_oppf_aar 
          NPAGTOPP.tiltak NPAGTOPP.neste_oppf_uke NPAGTOPP.neste_oppf 
          NPAGTOPP.notater NPAGTOPP.vaar_kontakt 
      WITH FRAME NY-OPPF.
  ENABLE RECT-1 NPAGTOPP.oppf_uke NPAGTOPP.oppf_status NPAGTOPP.oppf_dato 
         NPAGTOPP.kriterium_1 NPAGTOPP.kriterium_2 NPAGTOPP.neste_oppf_aar 
         NPAGTOPP.tiltak NPAGTOPP.neste_oppf_uke NPAGTOPP.neste_oppf 
         NPAGTOPP.notater NPAGTOPP.vaar_kontakt Btn_OK Btn_Cancel Btn_Help 
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
    temp-string = "".
    FOR EACH NPKONTAKT:
         IF temp-string = ""
        THEN temp-string = NPKONTAKT.kontaktperson.
        ELSE temp-string = temp-string + "," + NPKONTAKT.kontaktperson.
    END.
    /* Legg til en blank post */
    temp-string = temp-string + "," + " ".

    ASSIGN NPAGTOPP.vaar_kontakt:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

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
     create NPAGTOPP.
     NPAGTOPP.oppf_dato = TODAY.
     NPAGTOPP.id = tilbudsIdParam.
     NPAGTOPP.oppf_nr = iNextId.
     NPAGTOPP.neste_oppf = TODAY + 14.
     NPAGTOPP.neste_oppf_aar = YEAR(TODAY).
 UPDATE 
    NPAGTOPP.oppf_dato NPAGTOPP.oppf_uke NPAGTOPP.oppf_status NPAGTOPP.kriterium_1 
    NPAGTOPP.kriterium_2 NPAGTOPP.tiltak NPAGTOPP.neste_oppf_uke
    NPAGTOPP.neste_oppf NPAGTOPP.neste_oppf_aar NPAGTOPP.notater
    NPAGTOPP.vaar_kontakt
        Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME NY-OPPF.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


