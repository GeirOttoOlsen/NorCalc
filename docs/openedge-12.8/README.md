# Norcalc på OpenEdge 12.8

Første gjennomgang: meny og databaseskjema, 24. november 2026.

## Databasetilgang og versjon

En lokal ABL-batch koblet til den aktive databasen `E:\dbs\norcalc12\norcalc` via ABL-brokeren. Databaseloggen identifiserer serveren som OpenEdge **12.8 SP03, build 1217**. Batchklienten rapporterte 12.8. Uttrekket brukte `NO-LOCK` for alle lesinger. Det verifiserer lesetilgang til metadata og menytabeller. Skriverettigheter, DBA-tilgang og tilgang til øvrige forretningsdata er uavklart.

## Menyen i databasen

Hovedmenyen `Main` (ID 1) er konfigurert som `RIBBON`. Den har 51 noder og 50 koblinger. Alle nodene er tilgjengelige fra roten i selve menystrukturen, og alle koblinger peker på gyldige noder. Hvilke valg som vises for en bruker, avhenger av tilgangsfiltreringen.

| Nodekategori | Antall |
| --- | ---: |
| Hovedmeny | 1 |
| Navigasjonskontroll (`TV-NAV-BAR`) | 1 |
| Menylinjer (`Menubar` og `Backstage`) | 2 |
| Undermenyer | 7 |
| Menyvalg | 39 |
| Regel | 1 |

De 39 menyvalgene omfatter blant annet System, NorShunt, administrasjon og rapporter. NorShunt har blant annet Prosjekt, Gammel oppstart og valg for shuntanlegg, ordre og tilbud. Menyvedlikehold finnes både i System og i Backstage.

### Oppstart og tilgang

1. [JBoxAppStart.p](../../jukebox/winsrc/JBoxAppStart.p#L59) kobler opp sesjonen, kjører JBox-innlogging og velger menyimplementasjon ut fra menytype, brukerinnstillinger og tilgjengelige komponenter. Koden har grener for Ribbon, Plain og JLW-navigasjon.
2. [JBoxRibbonMenu.p](../../jukebox/oo/JBoxRibbonMenu.p#L1490) bruker [jbsetup_getuser_mainmenu.p](../../jukebox/server/jbsetup_getuser_mainmenu.p#L104) til å velge hovedmeny og [jbsetup_getmenustruct.p](../../jukebox/server/jbsetup_getmenustruct.p#L224) til å hente menytreet. Ribbon bruker Infragistics-komponenter og krever at riktig assembly-konfigurasjon lastes.
3. `JBoxMenu` inneholder node-ID, etikett, type og programstart. `JBoxMenuToMenu` knytter barn (`iFromMenuId`) til forelder (`iToMenuId`) og sorterer søsken etter `iSeq`. Bruker- og firmakoblinger ligger i `JBoxUserMenu` og `JBoxCompanyMenu`. JukeBox-koden sjekker også brukergrupper og særregler.

### Migreringsfunn

| Funn | Betydning for 12.8 |
| --- | --- |
| To aktive programreferanser bruker eksplisitt `.r` | `wSHGruppetype.r` og `wSHGruppe.r` har tilsvarende `.w`-kilder. Bygget må legge ny r-kode der klientens PROPATH finner den. |
| Tre programreferanser mangler verifisert kildefil med samme navn | `wshanleggdrilldown.w`, `wspanleggdrilldown.w` og `wfmkvsverdier.w`. Oppslag via den faktiske klientens PROPATH og eventuelle PL-biblioteker gjenstår. |
| Plain-menyen bruker eldre felter | [JBoxDynMenu.w](../../jukebox/obj/JBoxDynMenu.w#L459) spør etter `JBoxMenu.iParentMenuId` og `iNodeIndex`. Begge mangler i aktivt skjema. Plain-grenen trenger derfor egen verifisering før den kan brukes som reserve for Ribbon. |
| Eksisterende klientkonfigurasjon peker mot andre versjoner | [progress.ini](../../progress.ini#L9) har stier til `OE127x64`, som mangler lokalt. [progress117.ini](../../progress117.ini#L13) har en egen 11.7-konfigurasjon. |
| Eldre oppstart er fortsatt et menyvalg | Gammel oppstart peker på [Source/NORMENY.W](../../Source/NORMENY.W) og må inngå i klienttesten. |

## Aktivt databaseskjema

| Objekt | Aktiv database | Lokal DF-dump |
| --- | ---: | ---: |
| Tabeller | 266 | 266 |
| Felt | 3 720 | 3 720 |
| Indekser | 769 | 753 |
| Indeksfelt | 887 | 871 |
| Sekvenser | 156 | 156 |

Ved sammenligning av tabell- og indeksnavn er de 16 ekstra indeksene i aktiv database alle kalt `default`, fordelt på 16 tabeller. De omfatter eldre produkttabeller, `RBREPORT`, `spimport` og `tmpKundeoppf`. Det er et konkret avvik å ta hensyn til ved skjemaetablering og rekompilering. Like antall tabeller, felt og sekvenser bekrefter bare antallene.

De logiske koblingene i menyen følger JukeBox-koden. Den aktive indeksdefinisjonen for `JBoxMenuToMenu` har oppslag på barn, sortering på forelder og rekkefølge, og en sammensatt nøkkel på forelder og barn. `JBoxMenu.idxMenuId` er unik og primær.

Den fysiske strukturen har Schema Area, to dataområder, to indeksområder og et BLOB-område. Live-uttrekket viser 1 614 character-felt, 1 075 integer-felt, 420 date-felt, 408 decimal-felt, 199 logical-felt, to datetime-felt og to BLOB-felt.

## Grunnlag og videre verifisering

- [ABL-uttrekk](norcalc-analysis-session.p), [skjemauttrekk](norcalc-analysis-session.txt) og [menyuttrekk](norcalc-analysis-menu.txt). Skjemauttrekket dekker felt, datatyper, obligatoriske felt, extents, indeksdefinisjoner, indeksfelt og sekvensnavn. Menyuttrekket dekker registrerte noder og koblinger.
- Lokal sammenligningsdump `E:\dbs\norcalc12\dump\norcalc.df`. Fysiske områder kommer fra `norcalc.st`.
- Klienttesten nedenfor bygger videre på dette grunnlaget.

## Verifisering av 12.8-klienten

### Norcalcs egen oppstartsvei

[NorCalcStart.p](../../winsrc/NorCalcStart.p) henter Windows-brukeren og velger lokal ABL-sesjon eller AppServer ut fra oppstartsparameteren. [initNorcalc.p](../../winsrc/initNorcalc.p) kjører JukeBox-innlogging og kaller deretter JBoxMainMenu:InitializeObject(1). [JBoxMainMenu.cls](../../jukebox/oo/JBoxMainMenu.cls) starter Ribbon-prosedyren. Dette er Norcalcs egen oppstartsvei. Den generelle JBoxAppStart-prosedyren forklarer rammeverkets alternative menymoduser. Oppstartskommandoen til den eksisterende klientprosessen kunne ikke leses med den aktive Windows-tilgangen.

### Bygg og programoppslag

GUI-klienten prowin.exe rapporterte OpenEdge 12.8, 64-bit. Bygget brukte katalogene og PL-bibliotekene i .propath, den lokale 12.8-installasjonen, repoets assemblies-katalog og en separat midlertidig katalog foran prosjektet på PROPATH. Kompileringen brukte skjemaet fra den lokale ABL-brokeren.

| Kontroll | Resultat |
| --- | --- |
| Oppstart, menyklasser, menytjenester, reserveimplementasjoner og utvalgte vinduer | 13 av 13 kompilert og lagret som ny r-kode. Dette inkluderer NORMENY.W og kilden til begge eksplisitte .r-mål. |
| Unike programreferanser fra de 39 menyvalgene | 34 av 37 kompilert. Begge AdHoc-programmene inngår. |
| Programoppslag uten treff | wshanleggdrilldown.w, wspanleggdrilldown.w og wfmkvsverdier.w. |
| .NET-komponent | En separat OpenEdge 12.8-prosess opprettet og frigjorde JBoxMainForm med repoets assemblies. |
| Oppstart av GUI | NorCalcStart ble startet med den lokale brokeren. Klienten koblet til databasen og Windows registrerte et hovedvindu. |

[Byggloggen](compile-128.txt) viser hvert mål og oppslagsresultat. Applikasjonskilder og databaseinnhold ble ikke endret under kompileringen.

### Gjenværende verifisering

Computer Use-ferdigheten fikk avslag på inspeksjon av prowin-vinduet. Derfor er skjermbildet, Ribbon-innhold etter innlogging, tilganger per bruker og firma og åpning av menyvalg ikke verifisert. Neste klienttest må gjennomføres i en innlogget Norcalc-sesjon med kjent firma og brukerrolle. De tre manglende programmene må spores til en kjent leveranse eller avklares med eier av menyinnholdet.

## PDF

Rapporten kan bygges på nytt med Python 3 og ReportLab ved å kjøre `python lag_pdf.py` fra denne katalogen. Denne leveransen brukte eksisterende Python 3.12.14 og ReportLab 4.4.9 fra Codex-runtime. Poppler ble brukt til å rendre og kontrollere PDF-en.
