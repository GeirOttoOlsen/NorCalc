
/*------------------------------------------------------------------------
    File        : export_salgsdistrikt.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu May 04 08:01:04 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

ROUTINE-LEVEL ON ERROR UNDO, THROW.
def var nr as int no-undo.
def var navn as char format "x(40)" no-undo.
/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
for each NPKUNDE no-lock break by NPKUNDE.kundedistrikt:
  if first-of(NPKUNDE.kundedistrikt) then 
  do:
    if index(NPKUNDE.kundedistrikt,'-') gt 0 then 
    do:
      assign 
        nr = int(entry(1,NPKUNDE.kundedistrikt,'-'))
        navn =  entry(2,NPKUNDE.kundedistrikt,'-')
      .
      create NPkundedistrikt. 
      assign NPkundedistrikt.kundedistriktNr = nr
      NPkundedistrikt.kundedistriktnavn = navn
      .
    end.
  end.
      CATCH eAny AS Progress.Lang.Error :
          MESSAGE NPKUNDE.kundedistrikt
          VIEW-AS ALERT-BOX.
      END CATCH.
end.
