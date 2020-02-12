
/*------------------------------------------------------------------------
    File        : find_nesteid.p
    Purpose     : 

    Syntax      :

    Description : Omskrivning av neste_id.p til jukebox struktur

    Author(s)   : 
    Created     : Sun Nov 05 11:51:15 CET 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

ROUTINE-LEVEL ON ERROR UNDO, THROW.

DEFINE INPUT  PARAMETER icParam     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER bhTransfer  AS HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER icSessionId AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER ocReturn    AS CHARACTER init '' NO-UNDO.
DEFINE OUTPUT PARAMETER obOK        AS LOG init true NO-UNDO.

/* PROCEDURE Neste_Id.p
    Hensikt:    Returnerer neste gyldige id for en gitt tabell
    Parameter: Tabellnavn
    Retur:          Neste id. Ved feil returneres 0
*/

DEFINE INPUT PARAMETER cp_tabell_navn AS CHAR.
DEFINE OUTPUT PARAMETER ip_neste_id AS INTEGER INITIAL 0.

do transaction:
  FIND NPSEKVENS WHERE tabell_navn = cp_tabell_navn EXCLUSIVE-LOCK 
      NO-WAIT NO-ERROR.
  IF AVAILABLE NPSEKVENS THEN DO:
    ip_neste_id = NPSEKVENS.sist_brukt + 1.
    ASSIGN NPSEKVENS.sist_brukt = ip_neste_id.
  END.
end.
CATCH eAny AS Progress.Lang.Error :
  assign 
    ocReturn = eAny:GetMessage(1)
    obOk     = false
  .
END CATCH.