DEF INPUT PARAM icLDBname AS CHAR NO-UNDO.

DEFINE SHARED TEMP-TABLE ttLock NO-UNDO
    FIELD cDb    AS CHAR 
    FIELD cTABLE AS CHARACTER
    FIELD iUSER AS INTEGER
    FIELD cName AS CHARACTER
    FIELD rRECID AS INTEGER
    FIELD iTABLE AS INTEGER
    INDEX UserName cName ASCENDING.

{incl/validatecaller.i}

FOR EACH dictdb._Lock WHERE
    dictdb._Lock._Lock-Usr <> ? AND
    dictdb._Lock._Lock-Recid <> ? NO-LOCK:

    /* Comment the next two statements to list the locked records individually */

FIND FIRST ttLock WHERE   ttLock.iUSER = _Lock._Lock-Usr AND ttLock.iTABLE = _Lock._Lock-Table NO-LOCK NO-ERROR.
    IF AVAILABLE ttLock THEN NEXT.
    CREATE ttLock.
    ASSIGN
        ttLock.iUSER = _Lock._Lock-Usr
        ttLock.cName = _Lock._Lock-Name
        ttLock.rRECID = _Lock._Lock-Recid
        ttLock.iTABLE = _Lock._Lock-Table.
END.

FOR EACH ttLock NO-LOCK:
    FIND FIRST dictdb._File WHERE dictdb._File._File-Number = iTABLE NO-LOCK NO-ERROR.
    ASSIGN
        ttLock.cTABLE = dictdb._File._File-Name
        ttLock.cDb    = icLDBname.
END.
 
