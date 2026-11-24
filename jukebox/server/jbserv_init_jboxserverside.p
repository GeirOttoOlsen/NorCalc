
/*------------------------------------------------------------------------
    File        : jbserv_init_jboxserverside.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Fri Apr 24 18:35:24 CEST 2020
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

DEF INPUT  PARAM icSessionId   AS CHAR   NO-UNDO.
DEF INPUT  PARAM ihSourceProc  AS HANDLE NO-UNDO.
DEF INPUT-OUTPUT PARAM iohServerLib   AS HANDLE NO-UNDO.
DEF OUTPUT PARAM ocReturn      AS CHAR   NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
IF PROGRAM-NAME(3) NE "InitializeObject JBoxServerSide" THEN  /* added for 12.5 to avoid endless loop */ 
  iohServerLib = JBoxServerSide:Instance:InitializeObject(?,icSessionId).
