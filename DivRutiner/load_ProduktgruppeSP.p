def buffer bh for JboxGenCode.

for each npspvarelist no-lock break by NPSPVARELISTE.produktnavn : 
  if first-of(NPSPVARELISTE.produktnavn) then
  do: 
    disp npspvarelist.produktnavn with size 80 by 40.
    find bh where bh.cCodeType = 'ProduktGruppeSP' and bh.iJBoxCompanyId = 1 and bh.cCodeValue = npspvarelist.produktnavn no-lock no-error.
    if not avail bh then
    do transaction:
      create jboxGenCode.
      assign
        JBoxGenCode.cCodeType  = 'ProduktGruppeSP'
        JBoxGenCode.cLanguage  = "NO"  
        JBoxGenCode.cCodeValue = npspvarelist.produktnavn
      .
      end.
  end.
end.

