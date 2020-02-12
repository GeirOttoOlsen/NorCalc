&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES RBREPORT
&Scoped-define FIRST-EXTERNAL-TABLE RBREPORT


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR RBREPORT.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS RBREPORT.RB-REPORT-NAME ~
RBREPORT.RB-REPORT-LIBRARY RBREPORT.RB-DB-CONNECTION RBREPORT.RB-FILTER ~
RBREPORT.RB-PRINTER-NAME RBREPORT.RB-STATUS RBREPORT.RB-OUTPUT-FILE ~
RBREPORT.RB-DISPLAY-STATUS RBREPORT.RB-DISPLAY-ERRORS ~
RBREPORT.RB-TEST-PATTERN RBREPORT.RB-TAG RBREPORT.RB-INCLUDE-RECORDS ~
RBREPORT.RB-WINDOW-TITLE RBREPORT.RB-PRINTER-PORT RBREPORT.RB-MEMO-FILE ~
RBREPORT.RB-OTHER-PARAMETERS RBREPORT.RB-BEGIN-PAGE RBREPORT.RB-END-PAGE ~
RBREPORT.RB-PRINT-DESTINATION RBREPORT.RB-NUMBER-COPIES 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}RB-REPORT-NAME ~{&FP2}RB-REPORT-NAME ~{&FP3}~
 ~{&FP1}RB-REPORT-LIBRARY ~{&FP2}RB-REPORT-LIBRARY ~{&FP3}~
 ~{&FP1}RB-DB-CONNECTION ~{&FP2}RB-DB-CONNECTION ~{&FP3}~
 ~{&FP1}RB-FILTER ~{&FP2}RB-FILTER ~{&FP3}~
 ~{&FP1}RB-PRINTER-NAME ~{&FP2}RB-PRINTER-NAME ~{&FP3}~
 ~{&FP1}RB-STATUS ~{&FP2}RB-STATUS ~{&FP3}~
 ~{&FP1}RB-OUTPUT-FILE ~{&FP2}RB-OUTPUT-FILE ~{&FP3}~
 ~{&FP1}RB-DISPLAY-STATUS ~{&FP2}RB-DISPLAY-STATUS ~{&FP3}~
 ~{&FP1}RB-DISPLAY-ERRORS ~{&FP2}RB-DISPLAY-ERRORS ~{&FP3}~
 ~{&FP1}RB-TEST-PATTERN ~{&FP2}RB-TEST-PATTERN ~{&FP3}~
 ~{&FP1}RB-TAG ~{&FP2}RB-TAG ~{&FP3}~
 ~{&FP1}RB-INCLUDE-RECORDS ~{&FP2}RB-INCLUDE-RECORDS ~{&FP3}~
 ~{&FP1}RB-WINDOW-TITLE ~{&FP2}RB-WINDOW-TITLE ~{&FP3}~
 ~{&FP1}RB-PRINTER-PORT ~{&FP2}RB-PRINTER-PORT ~{&FP3}~
 ~{&FP1}RB-MEMO-FILE ~{&FP2}RB-MEMO-FILE ~{&FP3}~
 ~{&FP1}RB-OTHER-PARAMETERS ~{&FP2}RB-OTHER-PARAMETERS ~{&FP3}~
 ~{&FP1}RB-BEGIN-PAGE ~{&FP2}RB-BEGIN-PAGE ~{&FP3}~
 ~{&FP1}RB-END-PAGE ~{&FP2}RB-END-PAGE ~{&FP3}~
 ~{&FP1}RB-PRINT-DESTINATION ~{&FP2}RB-PRINT-DESTINATION ~{&FP3}~
 ~{&FP1}RB-NUMBER-COPIES ~{&FP2}RB-NUMBER-COPIES ~{&FP3}
&Scoped-define ENABLED-TABLES RBREPORT
&Scoped-define FIRST-ENABLED-TABLE RBREPORT
&Scoped-Define DISPLAYED-FIELDS RBREPORT.RB-REPORT-NAME ~
RBREPORT.RB-REPORT-LIBRARY RBREPORT.RB-DB-CONNECTION RBREPORT.RB-FILTER ~
RBREPORT.RB-PRINTER-NAME RBREPORT.RB-STATUS RBREPORT.RB-OUTPUT-FILE ~
RBREPORT.RB-DISPLAY-STATUS RBREPORT.RB-DISPLAY-ERRORS ~
RBREPORT.RB-TEST-PATTERN RBREPORT.RB-TAG RBREPORT.RB-INCLUDE-RECORDS ~
RBREPORT.RB-WINDOW-TITLE RBREPORT.RB-PRINTER-PORT RBREPORT.RB-MEMO-FILE ~
RBREPORT.RB-OTHER-PARAMETERS RBREPORT.RB-BEGIN-PAGE RBREPORT.RB-END-PAGE ~
RBREPORT.RB-PRINT-DESTINATION RBREPORT.RB-NUMBER-COPIES 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     RBREPORT.RB-REPORT-NAME AT ROW 1.29 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 32 BY 1
     RBREPORT.RB-REPORT-LIBRARY AT ROW 1.19 COL 64.4 COLON-ALIGNED
          LABEL "Library"
          VIEW-AS FILL-IN NATIVE 
          SIZE 60 BY 1
     RBREPORT.RB-DB-CONNECTION AT ROW 2.38 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 60 BY 1
     RBREPORT.RB-FILTER AT ROW 3.48 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 60 BY 1
     RBREPORT.RB-PRINTER-NAME AT ROW 4.52 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 32 BY 1
     RBREPORT.RB-STATUS AT ROW 4.52 COL 74 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 50 BY 1
     RBREPORT.RB-OUTPUT-FILE AT ROW 5.57 COL 22.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 60 BY 1
     RBREPORT.RB-DISPLAY-STATUS AT ROW 6.67 COL 46.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 8 BY 1
     RBREPORT.RB-DISPLAY-ERRORS AT ROW 6.71 COL 22.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 8 BY 1
     RBREPORT.RB-TEST-PATTERN AT ROW 6.76 COL 68.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 10 BY 1
     RBREPORT.RB-TAG AT ROW 6.76 COL 89.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 32 BY 1
     RBREPORT.RB-INCLUDE-RECORDS AT ROW 7.81 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 3 BY 1
     RBREPORT.RB-WINDOW-TITLE AT ROW 7.86 COL 40.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 33 BY 1
     RBREPORT.RB-PRINTER-PORT AT ROW 7.91 COL 89.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 32 BY 1
     RBREPORT.RB-MEMO-FILE AT ROW 8.95 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 60 BY 1
     RBREPORT.RB-OTHER-PARAMETERS AT ROW 10.43 COL 39.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 60 BY 1
     RBREPORT.RB-BEGIN-PAGE AT ROW 11.62 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 10 BY 1
     RBREPORT.RB-END-PAGE AT ROW 11.76 COL 50 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 10 BY 1
     RBREPORT.RB-PRINT-DESTINATION AT ROW 11.86 COL 78.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 3 BY 1
     RBREPORT.RB-NUMBER-COPIES AT ROW 11.86 COL 104 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 4 BY 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: norcalc.RBREPORT
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 11.95
         WIDTH              = 126.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN RBREPORT.RB-REPORT-LIBRARY IN FRAME F-Main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "RBREPORT"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "RBREPORT"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "RBREPORT"}

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


