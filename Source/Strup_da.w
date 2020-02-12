&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME MOTSTAND-STRUPEVENTIL
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS MOTSTAND-STRUPEVENTIL 
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE SHARED VAR anleggsnrParam LIKE NPSHANLG.anleggsnr.
DEFINE SHARED VAR systemnrParam LIKE NPSHSYST.systemnr.

DEFINE INPUT PARAMETER  ventilSide AS CHAR.
DEFINE INPUT PARAMETER c_kapasitet AS DECIMAL.
DEFINE OUTPUT PARAMETER  c_strupe_kvs AS DECIMAL.
DEFINE OUTPUT PARAMETER  c_delta_Pstr  AS DECIMAL.
DEFINE OUTPUT PARAMETER c_dimm LIKE NPSHSDIM.dimmensjon.

DEFINE  VAR  c_sub_delta_Pstr AS DECIMAL.
DEFINE VAR i AS INTEGER INITIAL 1.
DEFINE VAR selectedRow AS LOGICAL. 
DEFINE VAR Current-Rec AS RECID.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME MOTSTAND-STRUPEVENTIL
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES STRUPE_DA

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 STRUPE_DA.dimmensjon ~
STRUPE_DA.da_kvs STRUPE_DA.motstand STRUPE_DA.dimm_id 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH STRUPE_DA NO-LOCK ~
    BY STRUPE_DA.dimm_id.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 STRUPE_DA
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 STRUPE_DA


/* Definitions for DIALOG-BOX MOTSTAND-STRUPEVENTIL                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-MOTSTAND-STRUPEVENTIL ~
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
      STRUPE_DA SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 MOTSTAND-STRUPEVENTIL _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      STRUPE_DA.dimmensjon FORMAT "X(5)":U
      STRUPE_DA.da_kvs FORMAT ">>9.99":U
      STRUPE_DA.motstand FORMAT ">>>>>>9.99":U
      STRUPE_DA.dimm_id FORMAT "->,>>>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 63 BY 8.84
         BGCOLOR 15 FGCOLOR 4 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME MOTSTAND-STRUPEVENTIL
     BROWSE-1 AT ROW 1.53 COL 4.64
     SPACE(3.35) SKIP(1.82)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 8 
         TITLE BGCOLOR 8 "Motstand strupeventil DA":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX MOTSTAND-STRUPEVENTIL
   UNDERLINE                                                            */
/* BROWSE-TAB BROWSE-1 1 MOTSTAND-STRUPEVENTIL */
ASSIGN 
       FRAME MOTSTAND-STRUPEVENTIL:SCROLLABLE       = FALSE
       FRAME MOTSTAND-STRUPEVENTIL:PRIVATE-DATA     = 
                "DLGCLOSE".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "norcalc.STRUPE_DA"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.STRUPE_DA.dimm_id|yes"
     _FldNameList[1]   = norcalc.STRUPE_DA.dimmensjon
     _FldNameList[2]   = norcalc.STRUPE_DA.da_kvs
     _FldNameList[3]   > norcalc.STRUPE_DA.motstand
"STRUPE_DA.motstand" ? ">>>>>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   = norcalc.STRUPE_DA.dimm_id
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 MOTSTAND-STRUPEVENTIL
ON GO OF BROWSE-1 IN FRAME MOTSTAND-STRUPEVENTIL
DO:

  Current-Rec  = RECID(STRUPE_DA).
  FIND STRUPE_DA WHERE RECID(STRUPE_DA) = Current-Rec.
  c_dimm = STRUPE_DA.dimmensjon.
  c_strupe_kvs = STRUPE_DA.da_kvs.
  c_delta_Pstr = STRUPE_DA.motstand.
  APPLY "GO" TO SELF.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 MOTSTAND-STRUPEVENTIL
ON LEFT-MOUSE-DBLCLICK OF BROWSE-1 IN FRAME MOTSTAND-STRUPEVENTIL
DO:
  Current-Rec  = RECID(STRUPE_DA).
  FIND STRUPE_DA WHERE RECID(STRUPE_DA) = Current-Rec.
  c_strupe_kvs = STRUPE_DA.da_kvs.
  c_delta_Pstr = STRUPE_DA.motstand.
  APPLY "GO" TO SELF.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 MOTSTAND-STRUPEVENTIL
ON RETURN OF BROWSE-1 IN FRAME MOTSTAND-STRUPEVENTIL
DO:
  Current-Rec  = RECID(STRUPE_DA).
  FIND STRUPE_DA WHERE RECID(STRUPE_DA) = Current-Rec.
  c_strupe_kvs = STRUPE_DA.da_kvs.
  c_delta_Pstr = STRUPE_DA.motstand.
  APPLY "GO" TO SELF.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK MOTSTAND-STRUPEVENTIL 


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
   /* T›m tabell */
   FOR EACH STRUPE_DA:
       DELETE STRUPE_DA.
   END.
    IF  ventilSide = 'Prim' THEN
       RUN beregnMotstandPrim.  
    ELSE IF ventilSide = 'Sek' THEN
        RUN beregnMotstandSek.        
    RUN enable_UI.

  DEF VAR v_recid AS recid.
  i = i - 1.
  DO WHILE i > 0:
      GET NEXT BROWSE-1.
      i = i - 1.
  END.
  ASSIGN v_recid = RECID(STRUPE_DA).
  REPOSITION BROWSE-1 TO RECID v_recid.
  selectedRow = BROWSE-1:SELECT-FOCUSED-ROW().  

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnMotstandPrim MOTSTAND-STRUPEVENTIL 
PROCEDURE beregnMotstandPrim :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VAR c_id AS INTEGER INITIAL 1.
  DEFINE VAR c_anbefalt AS DECIMAL.  

  
    FOR EACH NPSHSDIM BY NPSHSDIM.dimm_id:
        CREATE STRUPE_DA.
        c_sub_delta_Pstr  = (((c_kapasitet * 60) * 0.6) / NPSHSDIM.da_kvs).
        c_delta_Pstr = EXP(c_sub_delta_Pstr, 2).
        
        ASSIGN
            STRUPE_DA.dimm_id = c_id
            STRUPE_DA.dimmensjon = NPSHSDIM.dimmensjon
            STRUPE_DA.da_kvs = NPSHSDIM.da_kvs
            STRUPE_DA.motstand = c_delta_Pstr.
        c_id = c_id + 1.
     END.

      /* Tilordne anbefalt verdi */           
                  
    FIND NPSHSDIM WHERE NPSHSDIM.q_max >=  c_kapasitet
        AND NPSHSDIM.q_min <= c_kapasitet NO-ERROR.
    IF AVAILABLE(NPSHSDIM) THEN
            i = NPSHSDIM.dimm_id.
    ELSE
        i = 1.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnMotstandSek MOTSTAND-STRUPEVENTIL 
PROCEDURE beregnMotstandSek :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VAR c_id AS INTEGER INITIAL 1.
  DEFINE VAR c_anbefalt AS DECIMAL.  

    FOR EACH NPSHSDIM BY NPSHSDIM.dimm_id:
        CREATE STRUPE_DA.
        c_sub_delta_Pstr  = (((c_kapasitet * 60) * 0.6) / NPSHSDIM.da_kvs).
        c_delta_Pstr = EXP(c_sub_delta_Pstr, 2).

        ASSIGN
            STRUPE_DA.dimm_id = c_id
            STRUPE_DA.dimmensjon = NPSHSDIM.dimmensjon
            STRUPE_DA.da_kvs = NPSHSDIM.da_kvs
            STRUPE_DA.motstand = c_delta_Pstr.
        c_id = c_id + 1.
     END.

      /* Tilordne anbefalt verdi */                          
    FIND NPSHSDIM WHERE NPSHSDIM.q_max >=  c_kapasitet
        AND NPSHSDIM.q_min <= c_kapasitet NO-ERROR.
    IF AVAILABLE(NPSHSDIM) THEN
            i = NPSHSDIM.dimm_id.
    ELSE
        i = 1.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI MOTSTAND-STRUPEVENTIL  _DEFAULT-DISABLE
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
  HIDE FRAME MOTSTAND-STRUPEVENTIL.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI MOTSTAND-STRUPEVENTIL  _DEFAULT-ENABLE
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
      WITH FRAME MOTSTAND-STRUPEVENTIL.
  {&OPEN-BROWSERS-IN-QUERY-MOTSTAND-STRUPEVENTIL}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

