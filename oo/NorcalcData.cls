 
 /*------------------------------------------------------------------------
    File        : NorcalcData
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo
    Created     : Mon Feb 19 14:54:53 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.NorcalcData: 
  def temp-table shuntDimmensjon no-undo
    field dimmType as char
    field dimmVerdi as int
    field dimmovergang as char 
    .
  def temp-table kapsling no-undo
    field kapslingNavn as char
    field kapslingVerdi as char
    field kapslingAlternativ as char
    .
  
  def temp-table Koblingalternativ no-undo
    field KoblingalternativFelt as char
    field koblingalternativTegning as char
    .

  DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS oo.NorcalcData NO-UNDO
         GET():
           IF Instance = ? THEN Instance = NEW oo.NorcalcData().
           RETURN Instance.
         END GET.
         PRIVATE SET.

  def var oKoblingsalternativ as oo.parameter no-undo.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
IF NPSHSYST.type = 'FM' THEN
    DO:
        CASE NPSHSYST.shunt_dimmensjon:
            WHEN '25' THEN   
                ASSIGN tillegg_fm_brakett_overgang = 'MB 23.5 Ø30/Ø10 SETT'.
            WHEN '50' THEN   
                ASSIGN tillegg_fm_brakett_overgang = 'MB 37.5 Ø30/Ø10 SETT'.
            WHEN '65' THEN   
                ASSIGN tillegg_fm_brakett_overgang = 'MB 56.0 Ø30/Ø10 SETT'.
        END CASE.
    END.

    beregnet_anvendelse:RADIO-BUTTONS = 'Varme|Varme|Lavtemperatur|Lavtemperatur|Lavtemp/Kaldt medium|Lavtemp/Kaldt medium|Kjøle|Kjøle|Frys|Frys|Varemegjenvinning|Varemegjenvinning'
     
  ------------------------------------------------------------------------------*/


  CONSTRUCTOR PUBLIC NorcalcData (  ):
    addkapsling('Varme','Varme','Kapsling-Rød front').
    addkapsling('Lavtemperatur','Lavtemperatur','Kapsling-Rød front').
    addkapsling('Kjøle','Kjøle','Kapsling-Blå front').
    addkapsling('Frys','Frys','Kapsling-Blå front').
    addkapsling('Varmegjenvinning','Varmegjenvinning','Kapsling-Grønn front').
    addkapsling('Lavtemp/Kaldt medium','Lavtemp/Kaldt medium','Kapsling-Rød/Blå front').

    addShuntDimmensjon('FM',25,'MB 23.5 Ø30/Ø10 SETT').    
    addShuntDimmensjon('FM',50,'MB 37.5 Ø30/Ø10 SETT').    
    addShuntDimmensjon('FM',65,'MB 56.0 Ø30/Ø10 SETT').

    addKoblingalternativ('1','kobling1.bmp').
    addKoblingalternativ('2','kobling2.bmp').
    addKoblingalternativ('3','kobling3.bmp').
    addKoblingalternativ('4','kobling4.bmp').
    addKoblingalternativ('5','kobling5.bmp').
    addKoblingalternativ('6','kobling6.bmp').
    addKoblingalternativ('7','kobling7.bmp').
    addKoblingalternativ('7a','kobling7a.bmp').
    addKoblingalternativ('xx','koblingx.bmp').
    
    
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD protected VOID addKoblingalternativ(input ipFelt as char, input ipTegning as char ):
    create Koblingalternativ.
    assign 
      Koblingalternativ.KoblingalternativFelt    = ipFelt
      Koblingalternativ.KoblingalternativTegning = ipTegning      
      .
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD protected VOID addShuntDimmensjon(input ipDimmType as char, input ipDimmVerdi as int, ipDimmOvergang as char ):
    create ShuntDimmensjon.
    assign 
      ShuntDimmensjon.DimmType     = ipDimmType
      ShuntDimmensjon.DimmVerdi    = ipDimmVerdi
      ShuntDimmensjon.DimmOvergang = ipDimmOvergang
      .
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD protected VOID addkapsling(input ipkapslingnavn as char, input ipkapslingverdi as char, ipkapslingalternativ as char ):
    create kapsling.
    assign 
      kapsling.kapslingNavn       = ipkapslingnavn
      kapsling.kapslingVerdi      = ipkapslingverdi
      kapsling.kapslingAlternativ = ipkapslingalternativ
      .
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes: Gjelder for både Primær og sekundær
  
           /* Kapasitet er ikke kjent */
           /* FORMEL: KAPASITET = (A * 0.86) / (B - C) /  3600  */
    A = Effekt
    B = TempInn
    C = TempUt
    D = Kapasitet
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC decimal beregnPrimKapasitet(input ipEffekt as handle, input ipTemperaturInn as handle, input ipTemperaturUt as handle, input ipKapasitet as handle ):
    def var teller as dec no-undo.
    def var nevner as dec no-undo.
    def var returVerdi as dec no-undo.
    
/*    if ipEffekt:input-value > 0 and ipTemperaturInn:input-value > 0 and ipTemperaturUt:input-value > 0 and ipKapasitet:input-value = 0 then do:*/
    
      assign 
        teller = ipEffekt:input-value * 0.86
        nevner = ipTemperaturInn:input-value - ipTemperaturUt:input-value      
        .
      returVerdi = absolute(teller / nevner) / 3600.
      return if returVerdi = ? then 0 else returVerdi.
/*    end.*/
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes: Samme som Primærkapasitet
  
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC decimal beregnSekKapasitet(input ipEffekt as handle, input ipTemperaturInn as handle, input ipTemperaturUt as handle, input ipKapasitet as handle ):
    return beregnPrimKapasitet(ipEffekt, ipTemperaturInn, ipTemperaturUt, ipKapasitet).
  END METHOD.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:

            /* Effekt er ikke kjent */
           /* Formel: EFFEKT = (D*  3600) * (B - C) / 0.86 */

    A = Effekt
    B = TempInn
    C = TempUt
    D = Kapasitet

  ------------------------------------------------------------------------------*/
  METHOD PUBLIC decimal beregnSekEffekt(input ipEffekt as handle, input ipTemperaturInn as handle, input ipTemperaturUt as handle, input ipKapasitet as handle  ):
    def var teller as dec no-undo.
    def var nevner as dec no-undo.
    def var returVerdi as dec no-undo.
    
/*    if ipEffekt:input-value = 0 and ipTemperaturInn:input-value > 0 and ipTemperaturUt:input-value > 0 and ipKapasitet:input-value > 0 then do:*/
      /* Effekt er ikke kjent */
      /* Formel: EFFEKT = (D*  3600) * (B - C) / 0.86 */
      assign 
        teller = (ipKapasitet:input-value * 3600) * (ipTemperaturInn:input-value - ipTemperaturUt:input-value).
        nevner = 0.86.
        .
      returVerdi =  absolute(teller / nevner).
      return if returVerdi = ? then 0 else returVerdi.
/*    end.*/
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
      /* Temperatur inn er ikke kjent */
      /* FORMEL: TEMPERATUR INN = C + (A * 0.86) / (D* 3600) */
    A = Effekt
    B = TempInn
    C = TempUt
    D = Kapasitet
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC decimal beregnSekTempINN(input ipEffekt as handle, input ipTemperaturInn as handle, input ipTemperaturUt as handle, input ipKapasitet as handle  ):
    def var teller as dec no-undo.
    def var nevner as dec no-undo.
    def var returVerdi as dec no-undo.
    
/*    if ipEffekt:input-value > 0 and ipTemperaturInn:input-value = 0 and ipTemperaturUt:input-value > 0 and ipKapasitet:input-value > 0 then do:*/
      assign 
        teller = ipEffekt:input-value * 0.86 
        nevner = ipKapasitet:input-value * 3600
        .
      returVerdi = ipTemperaturUt:input-value + (teller / nevner).
      return if returVerdi = ? then 0 else returVerdi.
/*    end.*/
  END METHOD.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
            /* Temperatur ut er ikke kjent */
            /* FORMEL: TEMPERATUR UT = B - (A * 0.86) / (D* 3600) */
    A = Effekt
    B = TempInn
    C = TempUt
    D = Kapasitet
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC decimal beregnSekTempUT(input ipEffekt as handle, input ipTemperaturInn as handle, input ipTemperaturUt as handle, input ipKapasitet as handle  ):
    def var teller as dec no-undo.
    def var nevner as dec no-undo.
    def var returVerdi as dec no-undo.
    
/*    if ipEffekt:input-value > 0 and ipTemperaturInn:input-value > 0 and ipTemperaturUt:input-value = 0 and ipKapasitet:input-value > 0 then do:*/
      assign 
        teller = ipEffekt:input-value * 0.86
        nevner = ipKapasitet:input-value * 3600 
        .
      returVerdi = ipTemperaturInn:input-value - absolute(teller / nevner). 
      return if returVerdi = ? then 0 else returVerdi.
/*    end.*/
  END METHOD.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getkapslingsAlternativ( input ipkapslingsnavn as char ):
    for each kapsling where kapsling.kapslingNavn = ipkapslingsnavn: leave. end.
    if not avail kapsling then 
      undo, throw new Progress.Lang.AppError('Fant ikke kapslingsalternativ',0).
    
    return kapsling.kapslingAlternativ.
  
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getKoblingsAlternativList():
    def var liste as char no-undo.
    for each Koblingalternativ: 
      liste = liste + (if liste = '' then '' else '|') + Koblingalternativ.KoblingalternativFelt.
    end.    
    return Liste.
  
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getDimmOvergang( input ipDimmType as char, ipDimmVerdi as int ):
    for each ShuntDimmensjon where ShuntDimmensjon.DimmType = ipDimmType
                               and shuntDimmensjon.dimmVerdi = ipDimmVerdi: leave. end.
    if not avail shuntDimmensjon then 
      undo, throw new Progress.Lang.AppError(substitute('Fant ikke ShuntDimmensjon for type:&1 verdi:&2',ipDimmType,ipDimmVerdi),0).
    
    return shuntDimmensjon.dimmovergang.
  
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC decimal extent getPRChastighet(input ipShuntDimmensjon as char, input ipPrimKapasitet as dec, input ipSekKapasitet as dec  ):
    define var v_prim as decimal format ">>>9,999999".
    define var v_sek as decimal format ">>>9,999999".
    def var returnValues as dec extent 2 no-undo.
    define var pi as decimal initial 3.14.
    def var indreDiameter as dec no-undo.
    
    
    if jboxserverapi:Instance:Find('NPindrediam',substitute('where dimm = "&1"',ipShuntDimmensjon)) then do:
      assign 
        indreDiameter = dec(jboxserverapi:Instance:FieldValue('NPIndreDiam.indre_diameter'))
        v_prim        = ipPrimKapasitet * 1000 /  ((indreDiameter * indreDiameter * pi) / 4)
        v_sek         = ipSekKapasitet * 1000 /   ((indreDiameter * indreDiameter * pi) / 4)
        returnValues[1] = v_prim
        returnValues[2] = v_sek
        .
    end.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:

  ------------------------------------------------------------------------------*/

  METHOD PUBLIC character getTegning(input ipKoblingsalternativFelt as char):
    def var oFI as class System.IO.FileInfo no-undo.
    def var Filnavn as char no-undo.

    find first Koblingalternativ where Koblingalternativ.KoblingalternativFelt = ipKoblingsalternativFelt no-error.
    if not avail Koblingalternativ then 
      undo, throw new Progress.Lang.AppError(substitute('Fant ikke kobling med felt: &1, må legges inn',ipKoblingsalternativFelt),0).
    filnavn = Koblingalternativ.koblingalternativTegning.
    
    if search(filnavn) = ? then 
      filnavn = 'img\bmp\' + filnavn.
    
    if search(filnavn) = ? then
      undo, throw new Progress.Lang.AppError('Filen ble ikke funnet:' + filnavn,0). 
    
    
    if not System.IO.File:Exists(search(filnavn)) then
      undo, throw new Progress.Lang.AppError(substitute('Fant ikke tegning med navn: &1, må legges inn',filnavn),0).

     
    oFI = new System.IO.FileInfo(filnavn).
    return oFI:FullName.
  END METHOD.

END CLASS.