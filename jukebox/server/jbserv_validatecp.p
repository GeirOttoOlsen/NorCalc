
/*------------------------------------------------------------------------
    File        : jbserv_validatecp.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Administrator
    Created     : Wed Mar 17 17:19:10 CET 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEF INPUT PARAM  icCP        AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ohCP        AS HANDLE NO-UNDO.
DEF OUTPUT PARAM oiErrorNo   AS INT    NO-UNDO INIT 200.
DEF OUTPUT PARAM ocMessage   AS CHAR   NO-UNDO.

DEFINE VARIABLE hCP      AS HANDLE          NO-UNDO.

DEF TEMP-TABLE tt
    FIELD rTarget AS RAW.

CREATE tt.
TEMP-TABLE tt:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD("rTarget"):BUFFER-VALUE = icCP NO-ERROR.
IF ERROR-STATUS:ERROR THEN
  ASSIGN oiErrorNo = 600
         ocMessage = "Ugyldig kall"
         .
ELSE DO:
  CREATE CLIENT-PRINCIPAL hCP. 
  hCP:IMPORT-PRINCIPAL(tt.rTarget) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN 
    ASSIGN oiErrorNo = 500
           ocMessage = "Ugyldig kall".
           
  ELSE CASE hCP:LOGIN-STATE:
    WHEN "login" THEN 
      ohCP = hCP.
    OTHERWISE
      ASSIGN oiErrorNo = 1
             ocMessage = hCP:LOGIN-STATE
             .  
  END CASE.
END.
    
FINALLY:
  IF oiErrorNo NE 200 THEN DO:
    IF oiErrorNo = 500 THEN
      LOG-MANAGER:WRITE-MESSAGE ("Ugylig kall (500) til " + SOURCE-PROCEDURE:FILE-NAME + " " + ERROR-STATUS:GET-MESSAGE(1)).
    ELSE IF oiErrorNo = 600 THEN
      LOG-MANAGER:WRITE-MESSAGE ("Ugylig kall (600) til " + SOURCE-PROCEDURE:FILE-NAME + " " + ERROR-STATUS:GET-MESSAGE(1)).
    ELSE DO:  
      LOG-MANAGER:WRITE-MESSAGE ("Ugylig kall til " + SOURCE-PROCEDURE:FILE-NAME + " for bruker " + hCP:USER-ID + ": " + hCP:LOGIN-STATE).
      DELETE OBJECT hCP.
    END.  
  END.   
END FINALLY.  
        