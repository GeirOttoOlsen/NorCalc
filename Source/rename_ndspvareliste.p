def var varenavn as char format "x(50)" no-undo.
def frame a npspvareliste.varenr varenavn format "x(30)" with size 70 by 30.

def var cList as char extent 15 no-undo.
def var cValue as char extent 15 no-undo.
def var ii as int no-undo.

assign 
  cList[1] = "Spirovent Air"
  cValue[1] = "SpiroVent"
  
  cList[2] = "Spirovent Air & Dirt"
    cValue[2] = "SpiroCombi"
    
  cList[3] = "Spirovent Air & Dirt Demonterbar"
    cValue[3] = "SpiroCombi Demonterbar"

  cList[4] = "Spirovent Air & Dirt Demonterbar Hi-Flow"
  cValue[4] = "SpiroCombi Demonterbar Hi-Flow"

  cList[5] = "Spirovent Air & Dirt Hi-Flow"
  cValue[5] ="SpiroCombi Hi-Flow"

  cList[6] = "Spirovent Air Hi-Flow"
  cValue[6] ="SpiroVent Hi-Flow"

  cList[7] = "Spirovent Dirt Separator"
  cValue[7] ="SpiroTrap"

  cList[8] = "Spirovent Dirt Separator Demonterbar"
  cValue[8] ="SpiroTrap Demonterbar"

  cList[9] = "Spirovent Dirt Separator Demonterbar Hi-Flow"
  cValue[9] ="SpiroTrap Demonterbar Hi-Flow"

  cList[10] = "Spirovent Dirt Separator Hi-Flow"
  cValue[10] ="SpiroTrap Hi-Flow"
.
output to ./npspvareliste.txt.
do ii = 1 to 10:
  put unformatted 'Søk=' cList[ii]  '---->' cValue[ii] skip.
  for each npspvareliste where produktnavn =  cList[ii] :
    put unformatted '  ' varenr  ' '  produktnavn '--->' cValue[ii] skip.
    npspvareliste.produktnavn = cValue[ii].
  end.
  put unformatted skip(2).
end.


