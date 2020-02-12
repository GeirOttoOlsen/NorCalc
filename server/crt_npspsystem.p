
/*------------------------------------------------------------------------
    File        : crt_npspsystem.p
    Purpose     : 

    Syntax      :

    Description : Kalt fra CallServerProc

    Author(s)   : 
    Created     : Tue Jun 20 12:53:02 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

ROUTINE-LEVEL ON ERROR UNDO, THROW.
//BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */



DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

def var ipAnleggsnr as int no-undo.
def var ipVareId    as int no-undo.

assign 
  ipAnleggsnr = integer(entry(1,icParam,'|'))
  ipVareId    = integer(entry(2,icParam,'|'))
  .
obOk = ocReturn = "".                                                    

JBoxLogging:Instance:LOG('Nytt system for anleggsnr ' + string(ipAnleggsnr)).

find first NPVare where NPVare.iNPVareId = iNPVareId no-lock no-error.
find first NPVaregruppe of NPVare no-lock no-error.
find first NPVareType   of NPVare no-lock no-error.

if not avail NPVare then obOk = false.
do transaction:
  create NPSPSYST.
  assign 
    NPSPSYST.anleggsnr = ipAnleggsnr
    NPSPSYST.nrf_nr    = NPVare.NRFnr
    NPSPSYST.varenr    = NPVare.Varenr
    NPSPSYST.produktnavn = NPVaregruppe.VaregruppeNavn
    NPSPSYST.produkttype = NPVareType.VareTypeNavn
    NPSPSYST.antall    = 1
    NPSPSYST.listepris = NPVare.VareEnhetspris
    NPSPSYST.max_trykk = NPVare.VareMaxtrykk
  .
    
end.
