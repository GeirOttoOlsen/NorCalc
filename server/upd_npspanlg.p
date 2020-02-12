/*------------------------------------------------------------------------
    File        : npspanlg.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Mon Sep 26 08:53:02 CEST 2011
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

ROUTINE-LEVEL ON ERROR UNDO, THROW.
DEF INPUT  PARAM icRowid     AS CHAR NO-UNDO.
DEF INPUT  PARAM icFields    AS CHAR NO-UNDO.
DEF INPUT  PARAM icValues    AS CHAR NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.

FIND FIRST npspanlg WHERE ROWID(npspanlg) = TO-ROWID(icRowid) NO-ERROR.

find first NORPROSJEKT where NORPROSJEKT.prosjektid = npspanlg.prosjektid no-error.
if avail NORPROSJEKT then NORPROSJEKT.spirovent = 'Ja'.
