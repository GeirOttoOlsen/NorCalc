
/*------------------------------------------------------------------------
    File        : jbserv_init_jboxserverquery.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Fri Apr 24 18:28:49 CEST 2020
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

DEF INPUT  PARAM icSessionId   AS CHAR   NO-UNDO.
DEF INPUT  PARAM ihSourceProc  AS HANDLE NO-UNDO.
DEF OUTPUT PARAM ocReturn      AS CHAR   NO-UNDO.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
{incl/validatecaller.i}
/*
IF icSessionId = "validsession" AND PROGRESS NE "Full" AND CAN-DO("WEBSPEED,APPSERVER",SESSION:TYPE) THEN DO:
  ocReturn = "Invalid session".
  RETURN.
END.
*/
JBoxServerQuery:Instance:InitializeObject(icSessionId, ihSourceProc). 