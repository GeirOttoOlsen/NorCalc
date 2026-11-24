&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
DEFINE INPUT-OUTPUT PARAMETER cKundenavn  AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER cKategori  AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER  cPostnr  AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER cPoststed  AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER cDistrikt  AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER dFraDato AS DATE.
DEFINE INPUT-OUTPUT PARAMETER dTilDato AS DATE.
DEFINE INPUT-OUTPUT PARAMETER csaksbehandler AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER cAktivitet AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER cDmKode AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER iReturVerdi AS INTEGER.

/* Local Variable Definitions ---                                       */
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-32 FILL-IN-kundenavn ~
COMBO-BOX_kundekategori FILL-IN-postnr FILL-IN-poststed ~
COMBO-BOX_kundedistriktnr FILL-IN-fra-dato FILL-IN-til-dato ~
COMBO-BOX-saksbeh TOGGLE-ikke-OK COMBO-BOX-aktivitet COMBO-BOX-dm_kode ~
Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-kundenavn COMBO-BOX_kundekategori ~
FILL-IN-postnr FILL-IN-poststed COMBO-BOX_kundedistriktnr FILL-IN-fra-dato ~
FILL-IN-til-dato COMBO-BOX-saksbeh TOGGLE-ikke-OK COMBO-BOX-aktivitet ~
COMBO-BOX-dm_kode 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 11.2 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 8 BY 1.1
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-aktivitet AS CHARACTER FORMAT "X(10)":U 
     LABEL "Aktivitet" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Besøkes","Kontaktes","Pleies" 
     DROP-DOWN-LIST
     SIZE 16 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-dm_kode AS CHARACTER FORMAT "X(15)":U 
     LABEL "DM kode" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1 Personlig","2 Meget god","3 God","4 Bearbeides","5 Når de må","6 Negativ" 
     DROP-DOWN-LIST
     SIZE 16 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE COMBO-BOX-saksbeh AS CHARACTER FORMAT "X(256)":U 
     LABEL "Saksbeh." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 26.8 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE COMBO-BOX_kundedistriktnr AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Distrikt" 
     VIEW-AS COMBO-BOX 
     LIST-ITEM-PAIRS "",0
     DROP-DOWN-LIST
     SIZE 36.8 BY 1.05
     BGCOLOR 2 FGCOLOR 1 FONT 2.

DEFINE VARIABLE COMBO-BOX_kundekategori AS CHARACTER FORMAT "X(6)" 
     LABEL "Kategori" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "","R","RG","VENT","AUTO","VVSK","ELK","SK","KULDE","PROD","KONK","LEV","DRIFT" 
     DROP-DOWN-LIST
     SIZE 17 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2.

DEFINE VARIABLE FILL-IN-fra-dato AS DATE FORMAT "99.99.9999":U 
     LABEL "Fom dato" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10.6 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-kundenavn AS CHARACTER FORMAT "X(30)" 
     LABEL "Kunde" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 38.6 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-postnr AS CHARACTER FORMAT "X(7)":U 
     LABEL "Postnr" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10.6 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-poststed AS CHARACTER FORMAT "X(25)":U 
     LABEL "Poststed" 
     VIEW-AS FILL-IN 
     SIZE 22.8 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-til-dato AS DATE FORMAT "99.99.9999":U 
     LABEL "tom" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10.6 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.4 BY 11.71.

DEFINE VARIABLE TOGGLE-ikke-OK AS LOGICAL INITIAL no 
     LABEL "Oppfølging ikke OK" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.8 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     FILL-IN-kundenavn AT ROW 1.86 COL 14 COLON-ALIGNED
     COMBO-BOX_kundekategori AT ROW 2.95 COL 14 COLON-ALIGNED
     FILL-IN-postnr AT ROW 4.14 COL 14 COLON-ALIGNED
     FILL-IN-poststed AT ROW 5.24 COL 14 COLON-ALIGNED
     COMBO-BOX_kundedistriktnr AT ROW 6.29 COL 14 COLON-ALIGNED
     FILL-IN-fra-dato AT ROW 7.48 COL 14 COLON-ALIGNED
     FILL-IN-til-dato AT ROW 7.52 COL 33.2 COLON-ALIGNED
     COMBO-BOX-saksbeh AT ROW 8.57 COL 14 COLON-ALIGNED
     TOGGLE-ikke-OK AT ROW 9.86 COL 16
     COMBO-BOX-aktivitet AT ROW 11 COL 14.4 COLON-ALIGNED
     COMBO-BOX-dm_kode AT ROW 11 COL 43.2 COLON-ALIGNED
     Btn_OK AT ROW 13.57 COL 26.4
     Btn_Cancel AT ROW 13.57 COL 34.8
     RECT-32 AT ROW 1.33 COL 2
     SPACE(0.99) SKIP(1.86)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Utskrift av Kundeoppfølgingsliste"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE
       FRAME Dialog-Frame:PRIVATE-DATA     = 
                "DLGCLOSE".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Utskrift av Kundeoppfølgingsliste */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
  /* Legg verdier i variabler */
  ASSIGN
      cKundenavn = FILL-IN-kundenavn:SCREEN-VALUE
      cKategori = COMBO-BOX_kundekategori:SCREEN-VALUE
      cPostnr = FILL-IN-postnr:SCREEN-VALUE
      cPoststed = FILL-IN-poststed:SCREEN-VALUE
      cDistrikt = string(COMBO-BOX_kundedistriktnr:SCREEN-VALUE)
      dFraDato = DATE(FILL-IN-fra-dato:SCREEN-VALUE)
      dTilDato = DATE(FILL-IN-til-dato:SCREEN-VALUE)
      cSaksbehandler = COMBO-BOX-saksbeh:SCREEN-VALUE
      cAktivitet = COMBO-BOX-aktivitet:SCREEN-VALUE
      cDmKode = COMBO-BOX-dm_kode:SCREEN-VALUE
      iReturVerdi = 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-saksbeh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-saksbeh Dialog-Frame
ON ANY-PRINTABLE OF COMBO-BOX-saksbeh IN FRAME Dialog-Frame /* Saksbeh. */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-saksbeh Dialog-Frame
ON CURSOR-DOWN OF COMBO-BOX-saksbeh IN FRAME Dialog-Frame /* Saksbeh. */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-saksbeh Dialog-Frame
ON CURSOR-UP OF COMBO-BOX-saksbeh IN FRAME Dialog-Frame /* Saksbeh. */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_kundedistriktnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_kundedistriktnr Dialog-Frame
ON ENTRY OF COMBO-BOX_kundedistriktnr IN FRAME Dialog-Frame /* Distrikt */
DO:
  /* Dersom poststed eller postnr er brukt, kan ikke poststed brukes */
  IF (FILL-IN-poststed:SCREEN-VALUE <> "" AND FILL-IN-poststed:SCREEN-VALUE <> ?)
    OR (FILL-IN-postnr:SCREEN-VALUE <> "" AND FILL-IN-postnr:SCREEN-VALUE <> ?) THEN
        RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-postnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-postnr Dialog-Frame
ON ENTRY OF FILL-IN-postnr IN FRAME Dialog-Frame /* Postnr */
DO:
  /* Dersom poststed eller distrikt er brukt, kan ikke poststed brukes */
  IF (FILL-IN-poststed:SCREEN-VALUE <> "" AND FILL-IN-poststed:SCREEN-VALUE <> ?)
    OR (COMBO-BOX_kundedistriktnr:SCREEN-VALUE <> "" AND
    COMBO-BOX_kundedistriktnr:SCREEN-VALUE <> ?) THEN
        RETURN NO-APPLY.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-poststed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-poststed Dialog-Frame
ON ENTRY OF FILL-IN-poststed IN FRAME Dialog-Frame /* Poststed */
DO:
   /* Dersom postnr eller distrikt er brukt, kan ikke poststed brukes */
  IF (FILL-IN-postnr:SCREEN-VALUE <> "" AND FILL-IN-postnr:SCREEN-VALUE <> ?)
    OR (COMBO-BOX_kundedistriktnr:SCREEN-VALUE <> "" AND
    COMBO-BOX_kundedistriktnr:SCREEN-VALUE <> ?) THEN
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


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  RUN fyll_combo.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
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
  DISPLAY FILL-IN-kundenavn COMBO-BOX_kundekategori FILL-IN-postnr 
          FILL-IN-poststed COMBO-BOX_kundedistriktnr FILL-IN-fra-dato 
          FILL-IN-til-dato COMBO-BOX-saksbeh TOGGLE-ikke-OK COMBO-BOX-aktivitet 
          COMBO-BOX-dm_kode 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-32 FILL-IN-kundenavn COMBO-BOX_kundekategori FILL-IN-postnr 
         FILL-IN-poststed COMBO-BOX_kundedistriktnr FILL-IN-fra-dato 
         FILL-IN-til-dato COMBO-BOX-saksbeh TOGGLE-ikke-OK COMBO-BOX-aktivitet 
         COMBO-BOX-dm_kode Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_combo Dialog-Frame 
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
DO WITH FRAME {&FRAME-NAME}:  
    assign 
      COMBO-BOX_kundedistriktnr:DELIMITER = '|' 
      COMBO-BOX_kundedistriktnr:LIST-ITEM-PAIRS = '|0|' + JBoxServerAPI:Instance:FieldList('NPKundedistrikt;KundeDistriktNr|KundeDistriktNavn;kundedistriktnr','where true')
    .
    ASSIGN COMBO-BOX-saksbeh:LIST-ITEMS = temp-string.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

