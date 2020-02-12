&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : adecomm/as-utils.w
    Purpose     : Appserver Utilities

    Syntax      :

    Description : Utilities to aid in the deployment of distributed applications

    Author(s)   : Ross Hunter
    Created     : 12/01/97
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{adecomm/appsrvtt.i "NEW GLOBAL"}
{adecomm/_adetool.i}

DEFINE VARIABLE usr-id AS CHARACTER FORMAT "X(256)":U 
     LABEL "User ID" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1 TOOLTIP "Enter your User ID" NO-UNDO.

DEFINE VARIABLE psswrd AS CHARACTER FORMAT "X(256)":U 
     LABEL "Password" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1 TOOLTIP "Enter your password" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD definedPartitions Procedure 
FUNCTION definedPartitions RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* The first thing to do is load up the service records into the
   AppSrv-TT.  This is only done here and this adecomm/as-utils.w
   should only be called once per session so there never should be
   any records already there.  But it is cheap to check it anyway.     */

DEFINE VARIABLE tt-file AS CHARACTER                             NO-UNDO.

FIND FIRST AppSrv-TT NO-ERROR.
IF NOT AVAILABLE AppSrv-TT THEN DO:
  tt-file = SEARCH("appsrvtt.d").
  IF tt-file ne ? THEN DO:  /* We found the file */
    INPUT FROM value(tt-file) NO-ECHO.
    REPEAT TRANSACTION:
      CREATE AppSrv-TT.
      IMPORT AppSrv-TT.Partition 
             AppSrv-TT.Host
             AppSrv-TT.Service
             AppSrv-TT.Configuration
             AppSrv-TT.Security
             AppSrv-TT.Info
             AppSrv-TT.App-Service.
      IF AppSrv-TT.App-Service = "" THEN /* Convert from 9.0A to 9.0B */
        AppSrv-TT.App-Service = AppSrv-TT.Partition.
      ASSIGN AppSrv-TT.AS-Handle = ?.
      VALIDATE AppSrv-TT.
    END. /* Repeat */
    INPUT CLOSE.
  END. /* If we found the appsrvtt.d file */
END.  /* If the AppSrv-TT is empty */
ELSE
  MESSAGE "The Application Server Service Table has been previously defined."
          VIEW-AS ALERT-BOX ERROR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appServerConnect Procedure 
PROCEDURE appServerConnect :
/*------------------------------------------------------------------------------
  Purpose:  appServerConnect calls the AppServer CONNECT method.  The extra
            layer facilitates the switching between running locally and running
            remotely (through AppServer Technology) at run time without
            modifying source code.  This is achieved by managing service name
            records in the AppSrv-TT temp-table.
  Parameters:  service_name    the name of partition or service name to be 
                               connected.
               security_prompt Yes causes a prompt for a userid/password which
                               is included in the AppServer CONNECT method.
                               No passes blanks to the AppServer.
               app_server_info Any string is put into the 4Th argument of the
                               AppServer CONNECT method.
               conn-hdl        The connection handle for the AppServer session
  Notes:  
------------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER partition_name  AS CHARACTER                    NO-UNDO.
DEFINE INPUT  PARAMETER security_prompt AS LOGICAL                      NO-UNDO.
DEFINE INPUT  PARAMETER app_server_info AS CHARACTER                    NO-UNDO.
DEFINE OUTPUT PARAMETER conn-hdl        AS HANDLE                       NO-UNDO.

DEFINE VARIABLE ret        AS LOGICAL                                   NO-UNDO.
DEFINE BUFFER   xAppSrv-TT FOR AppSrv-TT.

FIND FIRST AppSrv-TT WHERE AppSrv-TT.Partition = partition_name NO-ERROR.
IF NOT AVAILABLE AppSrv-TT THEN DO:
  MESSAGE "Attempt to connect a partition named" partition_name + "."
          SKIP
          "This partition is not currently defined in the"
          "AppServer Partition Deployment tool." VIEW-AS ALERT-BOX ERROR.
          RETURN "ERROR".
END.  /* If not record is available for this partiton */

/* Determine whether or not to override the defaults */
IF security_prompt = ? THEN security_prompt = AppSrv-TT.Security.
IF app_server_info = ? THEN app_server_info = AppSrv-TT.Info.

/* Return the Session handle if this service isn't remote */
IF NOT AppSrv-TT.Configuration THEN DO:  /* Remote = true : Local = false */
  ASSIGN AppSrv-TT.AS-HANDLE = SESSION:HANDLE
         conn-hdl            = SESSION:HANDLE.
  RETURN.
END.  /* If this service is to be run locally */

/* We have found the record, return the handle if it is already connected */
ASSIGN conn-hdl             = AppSrv-TT.AS-Handle
       AppSrv-TT.Conn-Count = AppSrv-TT.Conn-Count + 1.
IF VALID-HANDLE(conn-hdl) THEN RETURN.  /* Return the existing handle */

/* See if any other partition with the same handle is connected - if so
   use that handle                                                        */
FIND FIRST xAppSrv-TT WHERE xAppSrv-TT.App-Service = AppSrv-TT.App-Service AND
                            xAppSrv-TT.Partition  NE AppSrv-TT.Partition AND
                            VALID-HANDLE(xAppSrv-TT.AS-HANDLE) NO-ERROR.
IF AVAILABLE xAppSrv-TT THEN DO:
  ASSIGN AppSrv-TT.AS-Handle = xAppSrv-TT.AS-Handle
         conn-hdl            = xAppSrv-TT.AS-HANDLE.
  RETURN.
END.  /* We found another partition that is currently connected to this AppService */


/* We need to make a connection. */
CREATE SERVER conn-hdl.

/*  Check to see if we need to prompt for userid/password */
IF security_prompt THEN DO:
  IF NUM-DBS > 0 THEN RUN adecomm/get-user.p (OUTPUT usr-id).
  RUN security_prompt.
END.

/* Do the connection */
ASSIGN ret = conn-hdl:CONNECT(
             (IF AppSrv-TT.Service NE "" THEN " -S " + AppSrv-TT.Service ELSE "") +
             (IF AppSrv-TT.Host    NE "" THEN " -H " + AppSrv-TT.Host ELSE "") +
             " -AppService " + AppSrv-TT.App-Service,
                              usr-id, psswrd, app_server_info).
IF NOT ret THEN DO:
  MESSAGE "Unable to connect to the AppServer for the" AppSrv-TT.App-Service
          "service." VIEW-AS ALERT-BOX ERROR.
  ASSIGN conn-hdl = SESSION:HANDLE.
END.

AppSrv-TT.AS-HANDLE = conn-hdl.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appServerDisconnect Procedure 
PROCEDURE appServerDisconnect :
/*------------------------------------------------------------------------------
  Purpose:     To disconnect from a named service (a Partition)
  Parameters:  service_name  The name of the service to be disconnected from
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER partition_name AS CHARACTER                     NO-UNDO.

  DEFINE VARIABLE        ret            AS LOGICAL                       NO-UNDO.
  DEFINE BUFFER          xAppSrv-TT     FOR AppSrv-TT.

  FIND FIRST AppSrv-TT WHERE AppSrv-TT.Partition = partition_name NO-ERROR.
  
  IF NOT AVAILABLE AppSrv-TT THEN RETURN.

  /* This was being run locally don't disconnect, just null out the handle */ 
  IF NOT VALID-HANDLE(AppSrv-TT.AS-Handle) OR
     (AppSrv-TT.AS-Handle = SESSION:HANDLE) THEN DO:
    AppSrv-TT.AS-Handle = ?.
    RETURN.
  END.

  AppSrv-TT.Conn-Count = AppSrv-TT.Conn-Count - 1.
  
  IF AppSrv-TT.Conn-Count < 1 THEN DO:  /* This partition is tapped out - disconnect it */
    /* Check to see if another partition is still using the connection */
    IF CAN-FIND(FIRST xAppSrv-TT WHERE xAppSrv-TT.App-Service = AppSrv-TT.App-Service AND
                                       xAppSrv-TT.Partition  NE partition_name AND
                                       VALID-HANDLE(xAppSrv-TT.AS-Handle)) THEN DO:
      AppSrv-TT.AS-Handle = ?.         /* Keep the connection for this other partition */
      RETURN.
    END. /* Found another active connection */
 
    /* Disconnect here */
    ret = AppSrv-TT.AS-Handle:DISCONNECT().
    IF ret THEN DO:  /* Disconnection was succesful */
      DELETE OBJECT AppSrv-TT.AS-HANDLE.
      AppSrv-TT.AS-Handle = ?.
    END.
    ELSE MESSAGE "There is an error disconnecting from the" AppSrv-TT.App-Service
                 "AppServer Service." VIEW-AS ALERT-BOX ERROR.
  END. /* If the partition has no active connections (Conn-Count < 1) */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE security_prompt Procedure 
PROCEDURE security_prompt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .



/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Security-Dialog
     usr-id AT ROW 1.71 COL 11 COLON-ALIGNED
     psswrd AT ROW 2.91 COL 11 COLON-ALIGNED BLANK 
     Btn_OK AT ROW 1.52 COL 42
     Btn_Cancel AT ROW 2.76 COL 42
     Btn_Help AT ROW 4.76 COL 42
     SPACE(1.99) SKIP(0.28)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Security Check"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.

  UPDATE usr-id psswrd Btn_OK Btn_Cancel Btn_Help 
         WITH FRAME Security-Dialog.
  HIDE FRAME Security-Dialog.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION definedPartitions Procedure 
FUNCTION definedPartitions RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of defined Partitions (separated by CHR(3))
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE partition-list AS CHARACTER                           NO-UNDO.
  
  FOR EACH AppSrv-TT:
    IF LOOKUP(AppSrv-TT.Partition, partition-list, CHR(3)) = 0 THEN
      partition-list = partition-list + AppSrv-TT.partition + CHR(3).
  END.
  partition-list = TRIM(partition-list,CHR(3)).
  RETURN partition-list.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


