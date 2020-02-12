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
DEFINE INPUT PARAMETER parameter1 AS DECIMAL.
DEFINE INPUT PARAMETER parameter2 AS DECIMAL.
DEFINE INPUT PARAMETER tittelParam AS CHAR. 
DEFINE INPUT PARAMETER port AS INTEGER.

IF tittelParam = "" THEN
    tittelParam = "(Tittel)".
 
/* Local Variable Definitions ---                                       */
DEFINE VAR Current-Rec AS ROWID.
def var hParent as handle no-undo.
def var editModus as int no-undo.
def var system-rec as rowid no-undo.

DEFINE VARIABLE kpa_verdi LIKE NPKPA_Table.w_kpa.
DEFINE VARIABLE kvs_verdi LIKE NPKPA_Table.w_kvs.
DEFINE VARIABLE autoritetParam LIKE NPKPA_Table.w_autoritet.
DEFINE VARIABLE anleggsnrParam LIKE NPSHSYST.anleggsnr.
DEFINE VARIABLE systemnrParam LIKE NPSHSYST.systemnr.
DEFINE VAR koblingsAlternativ AS CHAR INITIAL '  '.
DEFINE VAR selectedRow AS LOGICAL.
DEFINE VAR  i  AS INTEGER  INITIAL 1.
DEFINE VAR cMSVentilType AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DLGCLOSE
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPKPA_Table

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 NPKPA_Table.w_kpa NPKPA_Table.w_kvs ~
NPKPA_Table.w_autoritet 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH NPKPA_Table NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 NPKPA_Table
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 NPKPA_Table


/* Definitions for DIALOG-BOX DLGCLOSE                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DLGCLOSE ~
    ~{&OPEN-QUERY-BROWSE-1}
&Scoped-define OPEN-QUERY-DLGCLOSE OPEN QUERY DLGCLOSE FOR EACH NPKPA_Table NO-LOCK.
&Scoped-define TABLES-IN-QUERY-DLGCLOSE NPKPA_Table
&Scoped-define FIRST-TABLE-IN-QUERY-DLGCLOSE NPKPA_Table


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
      NPKPA_Table SCROLLING.

DEFINE QUERY DLGCLOSE FOR 
      NPKPA_Table SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 DLGCLOSE _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      NPKPA_Table.w_kpa FORMAT ">>>>>>.99"
      NPKPA_Table.w_kvs FORMAT ">>>>>>.99"
      NPKPA_Table.w_autoritet
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 33 BY 7.57
         BGCOLOR 15 FGCOLOR 4 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGCLOSE
     BROWSE-1 AT ROW 1 COL 2.4
     SPACE(0.99) SKIP(0.09)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 8  .

/*          TITLE BGCOLOR 8 tittelParam. */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

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
     _TblList          = "norcalc.NPKPA_Table"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > norcalc.NPKPA_Table.w_kpa
"NPKPA_Table.w_kpa" ? ">>>>>>.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[2]   > norcalc.NPKPA_Table.w_kvs
"NPKPA_Table.w_kvs" ? ">>>>>>.99" "decimal" ? ? ? ? ? ? no ?
     _FldNameList[3]   = norcalc.NPKPA_Table.w_autoritet
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DLGCLOSE
/* Query rebuild information for DIALOG-BOX DLGCLOSE
     _TblList          = "norcalc.NPKPA_Table"
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX DLGCLOSE */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 DLGCLOSE
ON GO OF BROWSE-1 IN FRAME DLGCLOSE
DO:
  Current-Rec = ROWID(NPKPA_Table).
  FIND NPKPA_Table WHERE ROWID (NPKPA_Table) = Current-Rec.
  kpa_verdi = NPKPA_Table.w_kpa.
  kvs_verdi = NPKPA_Table.w_kvs. 
  autoritetParam = NPKPA_Table.w_autoritet.
  JBoxRelation:instance:addParameter(hParent,'kpa_verdi', string(kpa_verdi)).
  JBoxRelation:instance:addParameter(hParent,'kvs_verdi', string(kvs_verdi)).
  JBoxRelation:instance:addParameter(hParent,'autoritetParam', string(autoritetParam)).
  MESSAGE kpa_verdi skip kvs_verdi skip autoritetParam skip hparent:name
  VIEW-AS ALERT-BOX.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 DLGCLOSE
ON LEFT-MOUSE-DBLCLICK OF BROWSE-1 IN FRAME DLGCLOSE
DO:
  Current-Rec = ROWID(NPKPA_Table).
  FIND NPKPA_Table WHERE ROWID (NPKPA_Table) = Current-Rec.
  kpa_verdi = NPKPA_Table.w_kpa.
  kvs_verdi = NPKPA_Table.w_kvs. 
  autoritetParam = NPKPA_Table.w_autoritet.
  APPLY "GO" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 DLGCLOSE
ON RETURN OF BROWSE-1 IN FRAME DLGCLOSE
DO:
  Current-Rec = ROWID(NPKPA_Table).
  FIND NPKPA_Table WHERE ROWID (NPKPA_Table) = Current-Rec.
  kpa_verdi = NPKPA_Table.w_kpa.
  kvs_verdi = NPKPA_Table.w_kvs. 
  autoritetParam = NPKPA_Table.w_autoritet.
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
   hParent = source-procedure.
   editModus = int(JBoxRelation:instance:getParameter(hParent,'editModus')).
   system-rec = to-rowid(JBoxRelation:instance:getParameter(hParent,'CurrentRec')). /*npshsyst*/
    /* Bereg kpa og legg i tabell, tøm først */
    FOR EACH NPKPA_Table:
        DELETE NPKPA_Table.
    END.
    RUN beregnKpa.
    RUN enable_UI.

    DEF VAR v_recid AS ROWID.
    i = i - 1.
    DO WHILE i  >  0:  
        GET NEXT BROWSE-1.
       i = i - 1.
    END.                                                             
    if avail NPKPA_Table then 
    do:
      ASSIGN v_recid = ROWID(NPKPA_Table).
      REPOSITION BROWSE-1 TO ROWID v_recid.
    end.
    selectedRow = BROWSE-1:SELECT-FOCUSED-ROW(). 

/*  Denne versjonen 'blinker' ved store i-verdier
  selectedRow = BROWSE-1:SELECT-ROW(1).
    DO WHILE  i  > 1:
       selectedRow = BROWSE-1:SELECT-NEXT-ROW().       
       i = i - 1.
    END. 
*/
    
 WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregn1_5 DLGCLOSE 
PROCEDURE beregn1_5 :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
FOR EACH norcalc.NPKPA_Table   BY norcalc.NPKPA_Table.w_kpa:
      IF NPKPA_Table.w_kpa > 3 THEN            
             LEAVE.            
      ELSE
             i = i + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregn2 DLGCLOSE 
PROCEDURE beregn2 :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
FOR EACH norcalc.NPKPA_Table   BY norcalc.NPKPA_Table.w_kpa:
     IF NPKPA_Table.w_autoritet > 0.5 THEN
           LEAVE.            
     ELSE
           i = i + 1.
END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregn3_4 DLGCLOSE 
PROCEDURE beregn3_4 :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
IF  port = 2 THEN
    DO:
      FOR EACH norcalc.NPKPA_Table   BY norcalc.NPKPA_Table.w_kpa:
          IF NPKPA_Table.w_kpa > 3 THEN
               LEAVE.            
          ELSE
               i = i + 1.
      END.
    END.
ELSE IF port = 3 THEN
    DO:
         FOR EACH norcalc.NPKPA_Table   BY norcalc.NPKPA_Table.w_kpa:
              IF NPKPA_Table.w_autoritet  > 0.5 THEN
                    LEAVE.            
             ELSE
                    i = i + 1.
        END.
    END. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregn6 DLGCLOSE 
PROCEDURE beregn6 :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
IF  port = 2 THEN
     FOR EACH norcalc.NPKPA_Table   BY norcalc.NPKPA_Table.w_kpa:
         IF NPKPA_Table.w_kpa > 7 THEN
             LEAVE.            
         ELSE
             i = i + 1.
     END.
ELSE IF port = 3 THEN
     FOR EACH norcalc.NPKPA_Table   BY norcalc.NPKPA_Table.w_kpa:
         IF NPKPA_Table.w_autoritet  > 0.5 THEN
             DO:
                  i = i - 1. 
                  LEAVE.            
             END.
         ELSE
              i = i + 1.
     END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregn7 DLGCLOSE 
PROCEDURE beregn7 :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
/* Anbefalt ventilmotstand må være > 50% av inngående trykk (parameter1) */
DEFINE VAR anbefalt AS DECIMAL.
anbefalt = (parameter1 * 0.5).
   
FOR EACH norcalc.NPKPA_Table   BY norcalc.NPKPA_Table.w_kpa:
     IF NPKPA_Table.w_kpa > anbefalt THEN
           LEAVE.            
    ELSE
           i = i + 1.
END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnKpa DLGCLOSE 
PROCEDURE beregnKpa :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
/*  DEFINE VAR c_storrelse LIKE NPSHFMGR.storrelse.*/
  DEFINE VAR c_storrelse as char no-undo.
  DEFINE VAR c_nedre AS DECIMAL.
  DEFINE VAR c_ovre AS DECIMAL.
  DEFINE VAR c_nevner_kpa AS DECIMAL.
  DEFINE VAR c_utregnet_kpa AS DECIMAL.
  DEFINE VAR c_element2_nevner_autoritet AS DECIMAL.
  DEFINE VAR c_nevner_autoritet AS DECIMAL.
  DEFINE VAR c_utregnet_autoritet  AS DECIMAL INITIAL 0.00000.
  DEFINE VAR c_konstant AS INTEGER.
  DEFINE VAR c_kap_prim LIKE NPSHSYST.prim_kapasitet.
  DEFINE VAR c_kap_sek LIKE NPSHSYST.sek_kapasitet.
  DEFINE VAR c_type LIKE NPSHSYST.type.
  
/*  anleggsnrParam = int(JBoxRelation:instance:getParameter(hParent,'anleggsnrParam')).*/
/*  SystemnrParam = int(JBoxRelation:instance:getParameter(hParent,'SystemNrParam')).  */
/*                                                                                     */
/*  /* Hent dimmensjon fra System - type er både FM og MS*/                            */
/*  FIND NPSHSYST WHERE NPSHSYST.anleggsnr = anleggsnrParam AND                        */
/*  NPSHSYST.systemnr = systemnrParam NO-LOCK NO-WAIT NO-ERROR.                        */
  
  /*Fjernet det over, og la inn current-rec fra parent*/
 find npshsyst where rowid(npshsyst) = system-rec no-lock no-error.
 IF AVAILABLE(NPSHSYST) THEN DO:
    c_storrelse        = NPSHSYST.shunt_dimmensjon.
    c_kap_prim         = NPSHSYST.prim_kapasitet.
    c_kap_sek          = NPSHSYST.sek_kapasitet.
    koblingsAlternativ = NPSHSYST.koblings_alternativ.   
    cMSVentilType      = NPSHSYST.ms_ventiltype.
 END.
/* MESSAGE                                        */
/*   'c_storrelse:' c_storrelse skip              */
/*   'c_kap_prim:' c_kap_prim skip                */
/*   'c_kap_sek:' c_kap_sek skip                  */
/*   'koblingsalternativ:' Koblingsalternativ skip*/
/*   'cMSVentiltype:' cMSVentiltype               */
/* VIEW-AS ALERT-BOX.                             */

     /*Regn ut KPA for alle KVS - verdier */
  CASE c_storrelse:
      WHEN '25' THEN
          c_konstant = 15.
      WHEN '32' THEN
          c_konstant = 28.
      WHEN '40' THEN
          c_konstant = 36.
      WHEN '50' THEN
          c_konstant = 45.
      WHEN '65' THEN
          c_konstant = 120.
      WHEN '80' THEN
          c_konstant = 195.
      WHEN '100' THEN
          c_konstant = 230.
      WHEN '125' THEN
          c_konstant = 290.
      WHEN '150' THEN
          c_konstant = 485.
  END CASE.

  c_Type = NPSHSYST.type.
  IF c_type = 'FM' THEN DO:     
    FOR EACH NPSHFKVS NO-LOCK BY NPSHFKVS.kvs_verdi:
      IF NPSHFKVS.shunt_dimmensjon = c_storrelse THEN DO:
        CREATE NPKPA_Table.
        ASSIGN NPKPA_Table.w_kvs  = NPSHFKVS.kvs_verdi.
        CASE koblingsAlternativ:
          WHEN '5' OR WHEN '7' THEN c_utregnet_kpa = EXP((((c_kap_prim * 60) * 0.6) / NPSHFKVS.kvs_verdi), 2).               
          OTHERWISE                 c_utregnet_kpa = EXP((((c_kap_sek * 60) * 0.6) / NPSHFKVS.kvs_verdi), 2).               
        END CASE.
        ASSIGN NPKPA_Table.w_kpa = c_utregnet_kpa. 
        /* Regn ut autoritet ihht. valgt koblingsalternativ */               
        CASE koblingsAlternativ:
            WHEN '5' OR WHEN '7' THEN c_element2_nevner_autoritet =  EXP((((c_kap_prim * 60) * 0.6) / c_konstant), 2).
            OTHERWISE                 c_element2_nevner_autoritet =  EXP((((c_kap_sek * 60) * 0.6) / c_konstant), 2).
        END CASE.
        CASE koblingsAlternativ:
             WHEN '1' OR WHEN '5' OR WHEN  '7A' THEN c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet.
             WHEN '2' OR WHEN '3' OR WHEN '7'   THEN c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet + parameter1.
             WHEN '4' OR WHEN '6'               THEN c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet + parameter1 + parameter2.
        END CASE.                                           
        c_utregnet_autoritet = c_utregnet_kpa / c_nevner_autoritet.
       ASSIGN NPKPA_Table.w_autoritet =   c_utregnet_autoritet.
      END.
    END.
  END.
  ELSE DO:     
    FOR EACH NPSHMKVS NO-LOCK WHERE NPSHMKVS.ventiltype = cMSVentiltype BY NPSHMKVS.kvs_verdi:
      IF NPSHMKVS.shunt_dimmensjon = c_storrelse THEN DO:
        CREATE NPKPA_Table.
        ASSIGN NPKPA_Table.w_kvs  = NPSHMKVS.kvs_verdi.
        CASE koblingsAlternativ:
          WHEN '5' OR WHEN '7' THEN c_utregnet_kpa = EXP((((c_kap_prim * 60) * 0.6) / NPSHMKVS.kvs_verdi), 2).               
          OTHERWISE                 c_utregnet_kpa = EXP((((c_kap_sek * 60) * 0.6) / NPSHMKVS.kvs_verdi), 2).               
        END CASE.
        ASSIGN NPKPA_Table.w_kpa = c_utregnet_kpa. 
  
      /* Regn ut autoritet ihht. valgt koblingsalternativ */               
        CASE koblingsAlternativ:
          WHEN '5' OR WHEN '7' THEN c_element2_nevner_autoritet =  EXP((((c_kap_prim * 60) * 0.6) / c_konstant), 2).
          OTHERWISE                 c_element2_nevner_autoritet =  EXP((((c_kap_sek * 60) * 0.6) / c_konstant), 2).
        END CASE.
  
        CASE koblingsAlternativ:
          WHEN '1' OR WHEN '5' OR WHEN  '7A' THEN c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet.
          WHEN '2' OR WHEN '3' OR WHEN '7'   THEN c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet + parameter1.
          WHEN '4' OR WHEN '6'               THEN c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet + parameter1 + parameter2.
        END CASE.                                           
        assign 
          c_utregnet_autoritet = c_utregnet_kpa / c_nevner_autoritet
          NPKPA_Table.w_autoritet =   c_utregnet_autoritet
          .
      END.
    END.
  END.   
/*Tilordne rett anbefalt verdi */
  CASE koblingsAlternativ:   
    WHEN '1' OR WHEN '5' OR WHEN  '7A' THEN RUN beregn1_5.
    WHEN '2'                           THEN RUN beregn2.
    WHEN '3' OR WHEN '4'               THEN RUN beregn3_4.
    WHEN '6'                           THEN RUN beregn6.
    WHEN '7'                           THEN RUN beregn7.
   END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DLGCLOSE _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DLGCLOSE _DEFAULT-ENABLE
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

  {&OPEN-QUERY-DLGCLOSE}
  GET FIRST DLGCLOSE.
  ENABLE BROWSE-1 
      WITH FRAME DLGCLOSE.
  {&OPEN-BROWSERS-IN-QUERY-DLGCLOSE}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


