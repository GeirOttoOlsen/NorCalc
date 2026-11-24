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

1. [JBoxAppStart.p](../jukebox/winsrc/JBoxAppStart.p#L59) kobler opp sesjonen, kjører JBox-innlogging og velger menyimplementasjon ut fra menytype, brukerinnstillinger og tilgjengelige komponenter. Koden har grener for Ribbon, Plain og JLW-navigasjon.
2. [JBoxRibbonMenu.p](../jukebox/oo/JBoxRibbonMenu.p#L1490) bruker [jbsetup_getuser_mainmenu.p](../jukebox/server/jbsetup_getuser_mainmenu.p#L104) til å velge hovedmeny og [jbsetup_getmenustruct.p](../jukebox/server/jbsetup_getmenustruct.p#L224) til å hente menytreet. Ribbon bruker Infragistics-komponenter og krever at riktig assembly-konfigurasjon lastes.
3. `JBoxMenu` inneholder node-ID, etikett, type og programstart. `JBoxMenuToMenu` knytter barn (`iFromMenuId`) til forelder (`iToMenuId`) og sorterer søsken etter `iSeq`. Bruker- og firmakoblinger ligger i `JBoxUserMenu` og `JBoxCompanyMenu`. JukeBox-koden sjekker også brukergrupper og særregler.

### Migreringsfunn

| Funn | Betydning for 12.8 |
| --- | --- |
| To aktive programreferanser bruker eksplisitt `.r` | `wSHGruppetype.r` og `wSHGruppe.r` har tilsvarende `.w`-kilder. Bygget må legge ny r-kode der klientens PROPATH finner den. |
| Tre programreferanser mangler verifisert kildefil med samme navn | `wshanleggdrilldown.w`, `wspanleggdrilldown.w` og `wfmkvsverdier.w`. Oppslag via den faktiske klientens PROPATH og eventuelle PL-biblioteker gjenstår. |
| Plain-menyen bruker eldre felter | [JBoxDynMenu.w](../jukebox/obj/JBoxDynMenu.w#L459) spør etter `JBoxMenu.iParentMenuId` og `iNodeIndex`. Begge mangler i aktivt skjema. Plain-grenen trenger derfor egen verifisering før den kan brukes som reserve for Ribbon. |
| Eksisterende klientkonfigurasjon peker mot andre versjoner | [progress.ini](../progress.ini#L9) har stier til `OE127x64`, som mangler lokalt. [progress117.ini](../progress117.ini#L13) har en egen 11.7-konfigurasjon. |
| Eldre oppstart er fortsatt et menyvalg | Gammel oppstart peker på [Source/NORMENY.W](../Source/NORMENY.W) og må inngå i klienttesten. |

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

- [ABL-uttrekk](openedge-12.8/norcalc-analysis-session.p), [skjemauttrekk](openedge-12.8/norcalc-analysis-session.txt) og [menyuttrekk](openedge-12.8/norcalc-analysis-menu.txt). Skjemauttrekket dekker felt, datatyper, obligatoriske felt, extents, indeksdefinisjoner, indeksfelt og sekvensnavn. Menyuttrekket dekker registrerte noder og koblinger.
- Lokal sammenligningsdump `E:\dbs\norcalc12\dump\norcalc.df`. Fysiske områder kommer fra `norcalc.st`.
- Neste fase er å fastslå faktisk klientoppstart og PROPATH, kompilere menyens kilder mot 12.8 i en separat byggmappe og kjøre Ribbon med representativ bruker- og firmatilgang. Oppstart og utførelse av menyvalg i GUI er ennå ikke testet.
