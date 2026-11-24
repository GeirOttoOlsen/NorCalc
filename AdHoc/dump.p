
/*------------------------------------------------------------------------
    File        : _dump.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Mon Feb 12 16:10:44 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE dir-name AS CHARACTER NO-UNDO FORMAT "X(77)".
   DEFINE VARIABLE db-name AS CHARACTER NO-UNDO.
   DEFINE VARIABLE front-end AS CHARACTER NO-UNDO.
   DEFINE VARIABLE outstring AS CHARACTER NO-UNDO FORMAT "X(100)".
   DEFINE VARIABLE delim AS CHARACTER NO-UNDO FORMAT "X(1)".

   DEFINE STREAM dumpcmds.
   DEFINE STREAM loadcmds.

   SET dir-name.

IF OPSYS = "WIN32" THEN
DO:
        ASSIGN delim = "~\".
       OUTPUT STREAM dumpcmds TO dump.bat.
        OUTPUT STREAM loadcmds TO load.bat.
        ASSIGN front-end = "call proutil " + DBNAME.
   END.
   ELSE
DO:
        ASSIGN delim = "/".
       OUTPUT STREAM dumpcmds TO dump.sh.
        OUTPUT STREAM loadcmds TO load.sh.
       ASSIGN front-end = "proutil " + DBNAME.
   END.

   FOR EACH _file WHERE _file-num > 0 AND _file-num < 32768:
       ASSIGN outstring = front-end + " -C dump " + _file-name + " " + dir-name.
       PUT STREAM dumpcmds outstring SKIP.
       ASSIGN outstring = front-end + " -C load " + dir-name + delim + _file-name + ".bd".
       PUT STREAM loadcmds outstring SKIP.
   END.

   OUTPUT STREAM dumpcmds CLOSE.
   OUTPUT STREAM loadcmds CLOSE.
 