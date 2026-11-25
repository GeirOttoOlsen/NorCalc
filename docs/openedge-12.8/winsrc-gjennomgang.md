# Gjennomgang av winsrc

25. november 2026. Referansen var versjonen av `wGruppe.w` i arbeidsmappen ved gjennomgangen.

## Endringer

- Vinduer kobler browse, feltkart og verktøylinje direkte med JukeBox-klassene. De midlertidige hjelpeklassene for gruppe-, kontakt- og vedlikeholdsvinduene ble fjernet etter gjennomgangen.
- Selvstendige vedlikeholdsvinduer i endringen bruker `AdvGuiWin` og beregner X-grensen i `InitResize` fra browse-kanten. Y-grensen følger den eksisterende layouten. Vinduer med eget søkefelt beholder det, mens de øvrige i denne gruppen får kolonnefilter.
- Innebygde vinduer, faner og vinduer med egendefinert størrelse beholdt eksisterende vindusmodus og resize-regler.

## Verifisering

- OpenEdge 12.8 64-bit kompilerte 77 av 86 kompileringsmål både før og etter den opprinnelige gjennomgangen. Samme ni filer feilet i begge kjøringer. Oppstarts-include-filen er registrert separat.
- Etter fjerning av hjelpeklassene ga hele byggkjøringen samme resultat. Gruppe, Kontaktperson og Distrikt bestod en ny åpne-, resize- og lukketest. Et kall til Person-funksjonen uten aktiv gruppe lot vinduet være tilgjengelig.
- 14 vinduer åpnet, ble utvidet med 100 × 80 piksler og lukket i en lokal GUI-test. Avstanden mellom browse og det målte detaljfeltet var uendret i alle 14.
- Fire vinduer stoppet under initialisering både før og etter endringen i den lokale testen: `wForstillingsorgan.w`, `wNPSHmkvs.w`, `wNPSHventiltype.w` og `wNPSPVareliste.w`. En instrumentert kjøring av `wNPSHmkvs.w` stoppet ved det eksisterende oppslaget som fyller Ventiltype-listen.
- Testene brukte den lokale Norcalc-brokeren og en isolert byggmappe. Innlogget Ribbon og lagring av forretningsdata inngikk ikke.

## Status per fil

| Fil | Gjennomgang | 12.8-kompilering |
| --- | --- | --- |
| [Avdeling.w](../../winsrc/Avdeling.w) | Egen vindusstruktur | OK |
| [DbDesign.w](../../winsrc/DbDesign.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [Drilldown.w](../../winsrc/Drilldown.w) | Egen vindusstruktur | OK |
| [incl/appstartconnect.i](../../winsrc/incl/appstartconnect.i) | Oppstarts-include | Via kallende program |
| [initNorcalc.p](../../winsrc/initNorcalc.p) | Prosedyre eller klasse uten standardvindusoppsett | OK |
| [JBoxSetFilter.cls](../../winsrc/JBoxSetFilter.cls) | Prosedyre eller klasse uten standardvindusoppsett | OK |
| [JBoxWebLogin.w](../../winsrc/JBoxWebLogin.w) | Påloggingsvindu med egen livssyklus | OK |
| [JBoxWebLogin__.w](../../winsrc/JBoxWebLogin__.w) | Påloggingsvindu med egen livssyklus | OK |
| [NorCalcStart.p](../../winsrc/NorCalcStart.p) | Prosedyre eller klasse uten standardvindusoppsett | OK |
| [pdf_tilbud.p](../../winsrc/pdf_tilbud.p) | Prosedyre eller klasse uten standardvindusoppsett | Feil fra før |
| [Person.w](../../winsrc/Person.w) | Egen vindusstruktur | OK |
| [PersonView.w](../../winsrc/PersonView.w) | Egen vindusstruktur | OK |
| [Test/wNPProsjektBrw.w](../../winsrc/Test/wNPProsjektBrw.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [testmelding.p](../../winsrc/testmelding.p) | Prosedyre eller klasse uten standardvindusoppsett | OK |
| [velgNPSHGruppe.w](../../winsrc/velgNPSHGruppe.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wDistrikt.w](../../winsrc/wDistrikt.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wForstillingsorgan.w](../../winsrc/wForstillingsorgan.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wGruppe.w](../../winsrc/wGruppe.w) | Allerede modernisert | OK |
| [wJBoxContact.w](../../winsrc/wJBoxContact.w) | Eksisterende JukeBox-kobling og layout | OK |
| [wKommune.w](../../winsrc/wKommune.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wKundekontakt.w](../../winsrc/wKundekontakt.w) | Eksisterende JukeBox-kobling og layout | OK |
| [wLand.w](../../winsrc/wLand.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wLeveringsmaate.w](../../winsrc/wLeveringsmaate.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wNPBetalingsbetingelse.w](../../winsrc/wNPBetalingsbetingelse.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wNPFabrikat.w](../../winsrc/wNPFabrikat.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wNPKontakt.w](../../winsrc/wNPKontakt.w) | Allerede modernisert | OK |
| [wNPkontakt2.w](../../winsrc/wNPkontakt2.w) | Eksisterende JukeBox-kobling og layout | OK |
| [wNPKunde.w](../../winsrc/wNPKunde.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wNPKundeDetalj.w](../../winsrc/wNPKundeDetalj.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wNPkundedistrikt.w](../../winsrc/wNPkundedistrikt.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wNPkundekategori.w](../../winsrc/wNPkundekategori.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wNPKundeoppfolging.w](../../winsrc/wNPKundeoppfolging.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wNPLeveringsbetingelse.w](../../winsrc/wNPLeveringsbetingelse.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wNPSHmkvs.w](../../winsrc/wNPSHmkvs.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wNPSHsystemDetail.w](../../winsrc/wNPSHsystemDetail.w) | Egen vindusstruktur | OK |
| [wNPSHsystemDetails.w](../../winsrc/wNPSHsystemDetails.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | Feil fra før |
| [wNPSHventiltype.w](../../winsrc/wNPSHventiltype.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wNPSPTilbud.w](../../winsrc/wNPSPTilbud.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | Feil fra før |
| [wNPSPVareliste.w](../../winsrc/wNPSPVareliste.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wNPVare.w](../../winsrc/wNPVare.w) | Eksisterende JukeBox-kobling og layout | OK |
| [wNPVareBrw.w](../../winsrc/wNPVareBrw.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wNPVareGruppe.w](../../winsrc/wNPVareGruppe.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wNPVareType.w](../../winsrc/wNPVareType.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wPerson.w](../../winsrc/wPerson.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wPersonDetalj.w](../../winsrc/wPersonDetalj.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wPostNummer.w](../../winsrc/wPostNummer.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wProsjekt.w](../../winsrc/wProsjekt.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wRapportlayout.w](../../winsrc/wRapportlayout.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wReporttest.w](../../winsrc/wReporttest.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSequence.w](../../winsrc/wSequence.w) | Eksisterende JukeBox-kobling og layout | OK |
| [wSHAnlegg.w](../../winsrc/wSHAnlegg.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHAnleggBrw.w](../../winsrc/wSHAnleggBrw.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHAnleggBrw2.w](../../winsrc/wSHAnleggBrw2.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | Feil fra før |
| [wSHanleggBrw3.w](../../winsrc/wSHanleggBrw3.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHAnleggDetalj.w](../../winsrc/wSHAnleggDetalj.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wshendsys.w](../../winsrc/wshendsys.w) | Egen vindusstruktur | Feil fra før |
| [wSHGruppe.w](../../winsrc/wSHGruppe.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wSHGruppeType.w](../../winsrc/wSHGruppeType.w) | Vindusmodus, resize og eventuelt kolonnefilter | OK |
| [wSHOrdre.w](../../winsrc/wSHOrdre.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHordreBrw.w](../../winsrc/wSHordreBrw.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHOrdreDetalj.w](../../winsrc/wSHOrdreDetalj.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHOrdreDokument.w](../../winsrc/wSHOrdreDokument.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHOrdrekobling.w](../../winsrc/wSHOrdrekobling.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHSystem.w](../../winsrc/wSHSystem.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHsystemdetalj.w](../../winsrc/wSHsystemdetalj.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHTilbud.w](../../winsrc/wSHTilbud.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHTilbudBrw.w](../../winsrc/wSHTilbudBrw.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHTilbudBrw2.w](../../winsrc/wSHTilbudBrw2.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHTilbudDetalj.w](../../winsrc/wSHTilbudDetalj.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHTilbudOppfolging.w](../../winsrc/wSHTilbudOppfolging.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSHTillegg.w](../../winsrc/wSHTillegg.w) | Eksisterende JukeBox-kobling og layout | OK |
| [wSPAnlegg.w](../../winsrc/wSPAnlegg.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSPanleggBrw.w](../../winsrc/wSPanleggBrw.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSPanleggDetalj.w](../../winsrc/wSPanleggDetalj.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | Feil fra før |
| [wSPOrdreBrw.w](../../winsrc/wSPOrdreBrw.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSPSYSbmp.w](../../winsrc/wSPSYSbmp.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | Feil fra før |
| [wSPSystem.w](../../winsrc/wSPSystem.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | Feil fra før |
| [wSPTilbud.w](../../winsrc/wSPTilbud.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSPTilbudBrw.w](../../winsrc/wSPTilbudBrw.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSPTilbudDetalj.w](../../winsrc/wSPTilbudDetalj.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | Feil fra før |
| [wSPTilbudoppf.w](../../winsrc/wSPTilbudoppf.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wSPTilleggBrw.w](../../winsrc/wSPTilleggBrw.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wTilbudrapport.w](../../winsrc/wTilbudrapport.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wVare.w](../../winsrc/wVare.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wVareDetalj.w](../../winsrc/wVareDetalj.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wVaredokument.w](../../winsrc/wVaredokument.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
| [wVarekobling.w](../../winsrc/wVarekobling.w) | Eksisterende JukeBox-oppsett med egen komponentstruktur | OK |
