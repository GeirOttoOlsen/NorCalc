
DEF TEMP-TABLE ttMenu 
    FIELD hXMLdoc        AS INTEGER
    FIELD hNode          AS INTEGER
    FIELD hParentNode    AS INTEGER
    FIELD iLevel         AS INTEGER
    FIELD cElement       AS CHAR 
    FIELD cViewType      AS CHARACTER
    FIELD cNodeValue     AS CHAR 
    FIELD iNodeIdx       AS INT
    FIELD iParentNodeIdx AS INT
    .
DEF BUFFER bttMenu FOR ttMenu.
DEF BUFFER bJBoxMenu FOR JBoxMenu.

INPUT FROM C:\prowrk\Bafo\data\ttNodes.csv.

SET ^.
REPEAT:
  CREATE ttMenu.
  IMPORT DELIMITER ";" ttMenu.
END.

INPUT CLOSE.

/*
FIND FIRST bJBoxMenu NO-LOCK
     WHERE bJBoxMenu.cMenuType = "TV-NAV-BAR".

FOR EACH ttMenu
    WHERE ttMenu.iLevel = 2
      AND cElement = "sub-menu"
    :

  FIND FIRST bttMenu WHERE bttMenu.iNodeIdx = ttMenu.iNodeIdx + 1 NO-ERROR.
  DISP ttMenu.iNodeIdx
       ttMenu.cElement
       bJBoxMenu.iJBoxMenuId
       bttMenu.cNodeValue WHEN AVAIL bttMenu
       .
  CREATE JBoxMenu.
  ASSIGN JBoxMenu.cMenuType = ttMenu.cElement
         JBoxMenu.cMenuLabel = bttMenu.cNodeValue
         JBoxMenu.dCreated   = TODAY
         .
  CREATE JBoxMenuToMenu.
  ASSIGN JBoxMenuToMenu.iToMenuId = bJBoxMenu.iJBoxMenuId
         JBoxMenuToMenu.iFromMenuId = JBoxMenu.iJBoxMenuId
         JBoxMenuToMenu.iSeq = ttMenu.iNodeIdx
         JBoxMenuToMenu.dCreated = TODAY
         .
END.
*/

FOR EACH ttMenu
    WHERE ttMenu.iLevel = 3
      AND ttMenu.cElement = "menu-item"
    BY ttMenu.iNodeIdx
    :

  FIND FIRST bttMenu WHERE bttMenu.iNodeIdx = ttMenu.iParentNodeIdx + 1 NO-ERROR.
  IF AVAIL bttMenu THEN DO:
    FIND FIRST bJBoxMenu NO-LOCK
         WHERE bJBoxMenu.cMenuLabel = bttMenu.cNodeValue
           AND bJBoxMenu.cMenuType = "sub-menu"
         NO-ERROR.
    IF NOT AVAIL bttMenu THEN NEXT.
  END.
  ELSE NEXT.

  DISP ttMenu.iNodeIdx
       ttMenu.cElement
       bJBoxMenu.iJBoxMenuId WHEN AVAIL bJBoxMenu
       bttMenu.cNodeValue WHEN AVAIL bttMenu
       .

  CREATE JBoxMenu.
  ASSIGN JBoxMenu.cMenuType = ttMenu.cElement
         JBoxMenu.cMenuLabel = bttMenu.cNodeValue
         JBoxMenu.dCreated   = TODAY
         .

  FOR EACH bttMenu
      WHERE bttMenu.iParentNodeIdx = ttMenu.iNodeIdx:
    BUFFER JBoxMenu:HANDLE:BUFFER-FIELD(bttMenu.cElement):BUFFER-VALUE = bttMenu.cNodeValue.
/*     DISP bttMenu.cElement FORMAT "x(20)"   */
/*          bttMenu.cNodeValue FORMAT "x(20)" */
/*          .                                 */
  END.

  CREATE JBoxMenuToMenu.
  ASSIGN JBoxMenuToMenu.iToMenuId = bJBoxMenu.iJBoxMenuId
         JBoxMenuToMenu.iFromMenuId = JBoxMenu.iJBoxMenuId
         JBoxMenuToMenu.iSeq = ttMenu.iNodeIdx
         JBoxMenuToMenu.dCreated = TODAY
         .
END.


/* source menu:


DEF VAR oMenuXML         AS JBoxXmlDoc NO-UNDO.

oMenuXML = NEW JBoxXmlDoc().
oMenuXML:AddBlockNode("menu").
oMenuXML:AddNode("cStateImage","png\j0432620.png"). /* logo */

oMenuXML:AddBlockNode("tv-nav-bar").
  oMenuXML:AddBlockNode("sub-menu").
  oMenuXML:AddNode("cMenuLabel","Bafo økonomi").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Fakturering").
    oMenuXML:AddNode("cLaunch","Fakturering.w").
    oMenuXML:AddNode("cImage","png\j0431631.png").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Forsikringsrapport pivot dekninger").
    oMenuXML:AddNode("cLaunch","ForsikringPivot.w").
    oMenuXML:AddNode("cImage","gif\magnify.gif").

  
  oMenuXML:AddBlockNode("tv-nav-bar","sub-menu").
  oMenuXML:AddNode("cMenuLabel","Mypage grunndata").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Score poeng").
    oMenuXML:AddNode("cLaunch","ScoreParam.w").
    oMenuXML:AddNode("cImage","ico\wizard.ico").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Parameter type").
    oMenuXML:AddNode("cLaunch","ScoreParameterType.w").
    oMenuXML:AddNode("cImage","ico\wsecedit.ico").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Generelle koder").
    oMenuXML:AddNode("cLaunch","CodeValue.w").
    oMenuXML:AddNode("cImage","ico\boxes.ico").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Hendelsestyper").
    oMenuXML:AddNode("cLaunch","EventType.w").
    oMenuXML:AddNode("cImage","ico\app32.ico").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Forespørselstyper").
    oMenuXML:AddNode("cLaunch","RequestType.w").
    oMenuXML:AddNode("cImage","ico\blocks.ico").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Topp 10 parameter gruppe").
    oMenuXML:AddNode("cLaunch","ScoreCategory.w").
    oMenuXML:AddNode("cImage","ico\folders.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Koderegister").
    oMenuXML:AddNode("cLaunch","CodeValue.w").
    oMenuXML:AddNode("cImage","ico\dictionary.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Pristabell").
    oMenuXML:AddNode("cLaunch","Pristabell.w").
    oMenuXML:AddNode("cImage","png\j0441326.png").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Sysreg").
    oMenuXML:AddNode("cLaunch","Sysreg.w").
    oMenuXML:AddNode("cImage","ico\verhistory32.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","System Parametre(ny)").
    oMenuXML:AddNode("cLaunch","wSystemParameterType.w").
    oMenuXML:AddNode("cImage","ico\verhistory32.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Menyvedlikehold").
    oMenuXML:AddNode("cLaunch","JBoxMsTreeMenuMaint.w").
    oMenuXML:AddNode("cImage","ico\pcase.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Brukervedlikehold").
    oMenuXML:AddNode("cLaunch","JBoxUser.w").
    oMenuXML:AddNode("cImage","png\j0432612.png").
    
  oMenuXML:AddBlockNode("tv-nav-bar","sub-menu").
  oMenuXML:AddNode("cMenuLabel","Mypage rapporter").
  
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Statistikk, prissjekk").
    oMenuXML:AddNode("cLaunch","PriceCheckStat.w").
    oMenuXML:AddNode("cImage","ico\btrez1.ico").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Forespørsler").
    oMenuXML:AddNode("cLaunch","Request.w").
    oMenuXML:AddNode("cImage","ico\ico_Compil320001.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Hendelseslogg").
    oMenuXML:AddNode("cLaunch","EventLog.w").
    oMenuXML:AddNode("cImage","ico\alarm.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Front-end hendelser").
    oMenuXML:AddNode("cLaunch","FrontEndEventLog.w").
    oMenuXML:AddNode("cImage","ico\FFupdater.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Sesjonstabell").
    oMenuXML:AddNode("cLaunch","LoginSession.w").
    oMenuXML:AddNode("cImage","ico\usermain32.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Handlekurv").
    oMenuXML:AddNode("cLaunch","BasketHeader.w").
    oMenuXML:AddNode("cImage","png\j0431639.png").
    

  oMenuXML:AddBlockNode("tv-nav-bar","sub-menu").
  oMenuXML:AddNode("cMenuLabel","Bafo Div").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Fakturaoversikt").
    oMenuXML:AddNode("cLaunch","Fakturaoversikt.w").
    oMenuXML:AddNode("cLaunchType","data-browse").
    oMenuXML:AddNode("cImage","ico\tankgreen.ico").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Sett VG prosjektnr").
    oMenuXML:AddNode("cLaunch","SjekkVgProsjnr.w").
    oMenuXML:AddNode("cImage","ico\arrowdouble.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Medlemsliste").
    oMenuXML:AddNode("cLaunch","MemberList.w").
    oMenuXML:AddNode("cImage","png\j0432612.png").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Webkø 2.0").
    oMenuXML:AddNode("cLaunch","WebQueue.w").
    oMenuXML:AddNode("cImage","png\j0440384.png").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Produktoversikt").
    oMenuXML:AddNode("cLaunch","Produktoversikt.w").
    oMenuXML:AddNode("cLaunchType","data-browse").
    oMenuXML:AddNode("cImage","icons\plugin.png").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Forsikringsoversikt").
    oMenuXML:AddNode("cLaunch","Forsoversikt.w").
    oMenuXML:AddNode("cLaunchType","data-browse").
    oMenuXML:AddNode("cImage","png\j0433953.png").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","SysReg").
    oMenuXML:AddNode("cLaunch","SysReg.w").
    oMenuXML:AddNode("cImage","ico\ntservice.ico").

    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Postnr").
    oMenuXML:AddNode("cLaunch","Postnr.w").
    oMenuXML:AddNode("cImage","gif\flag_no.gif").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Priser").
    oMenuXML:AddNode("cLaunch","Pristabell.w").
    oMenuXML:AddNode("cImage","gif\restart32.gif").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Ordre").
    oMenuXML:AddNode("cLaunch","Ordre.w").
    oMenuXML:AddNode("cImage","png\j0433808.png").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Kombiprodukter").
    oMenuXML:AddNode("cLaunch","Kombiprodukt.w").
    oMenuXML:AddNode("cImage","gif\afmultwind.gif").
    
    oMenuXML:AddBlockNode("sub-menu","menu-item").
    oMenuXML:AddNode("cMenuLabel","Produkter og dekninger").
    oMenuXML:AddNode("cLaunch","ProdDekning.w").
    oMenuXML:AddNode("cImage","ico\shell322.ico").

/*    oMenuXML:AddBlockNode("sub-menu","menu-item").      */
/*    oMenuXML:AddNode("cMenuLabel","Menyvedlikehold").   */
/*    oMenuXML:AddNode("cLaunch","JBoxMsTreeMenuMaint.w").*/
/*    oMenuXML:AddNode("cImage","ico\pcase.ico").         */

oMenuXML:AddBlockNode("tv-nav-bar","sub-menu").
oMenuXML:AddNode("cMenuLabel","Klient admin").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Klient").
oMenuXML:AddNode("cLaunch","Klient.w").
oMenuXML:AddNode("cImage","ico\sbmejb.ico").


oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Subklient").
oMenuXML:AddNode("cLaunch","Subklient.w").
oMenuXML:AddNode("cImage","ikon\date_time.ico").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Subklient leverandør").
oMenuXML:AddNode("cLaunch","SubklientLeverandor.w").
oMenuXML:AddNode("cImage","ikon\date_time.ico").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Selger").
oMenuXML:AddNode("cLaunch","Selger.w").
oMenuXML:AddNode("cImage","ikon\date_time.ico").

oMenuXML:AddBlockNode("tv-nav-bar","sub-menu").
oMenuXML:AddNode("cMenuLabel","BATCH admin").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Scheduler").
oMenuXML:AddNode("cLaunch","wJobbKoScheduler.w").
oMenuXML:AddNode("cImage","ikon\date_time.ico").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Jobbkø").
oMenuXML:AddNode("cLaunch","wJobbKo.w").
oMenuXML:AddNode("cImage","ico\shell322.ico").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Jobbkø loggtype").
oMenuXML:AddNode("cLaunch","wJobbKoLoggType.w").
oMenuXML:AddNode("cImage","ico\shell322.ico").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Filkatalog").
oMenuXML:AddNode("cLaunch","wFilKatalog.w").
oMenuXML:AddNode("cImage","ikon\folder_document.png").

/*oMenuXML:AddBlockNode("sub-menu","menu-item").   */
/*oMenuXML:AddNode("cMenuLabel","Fakturahode").    */
/*oMenuXML:AddNode("cLaunch","winsrc\wFaktHode.w").*/
/*oMenuXML:AddNode("cImage","ico\shell322.ico").   */

oMenuXML:AddBlockNode("sub-menu","sub-menu").
oMenuXML:AddNode("cMenuLabel","Kode oppsett").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Scheduler Intervall").
oMenuXML:AddNode("cLaunch","wJobbKoSchedulerIntervall.w").
oMenuXML:AddNode("cImage","ikon\date_time.ico").

/*oMenuXML:AddBlockNode("sub-menu","menu-item").  */
/*oMenuXML:AddNode("cMenuLabel","ePost medlem").  */
/*oMenuXML:AddNode("cLaunch","wAdrTlfmm.w").      */
/*oMenuXML:AddNode("cImage","ikon\date_time.ico").*/

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Jobbkø type").
oMenuXML:AddNode("cLaunch","wJobbkoType.w").
oMenuXML:AddNode("cImage","ico\shell322.ico").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Jobbkø status").
oMenuXML:AddNode("cLaunch","wJobbkoStatus.w").
oMenuXML:AddNode("cImage","ico\shell322.ico").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","EndringLogg type").
oMenuXML:AddNode("cLaunch","wEndringLoggType.w").
oMenuXML:AddNode("cImage","ico\shell322.ico").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Filkatalog parameter").
oMenuXML:AddNode("cLaunch","wFilkatalogparameter.w").
oMenuXML:AddNode("cImage","ikon\folder_window.png").

oMenuXML:AddBlockNode("tv-nav-bar","sub-menu").
oMenuXML:AddNode("cMenuLabel","GDPR").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","GDPR oppsett").
oMenuXML:AddNode("cLaunch","wGDPRTabell.w").
oMenuXML:AddNode("cImage","ikon\tables.png").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","GDPR PolicyType").
oMenuXML:AddNode("cLaunch","wGDPRPolicyType.w").
oMenuXML:AddNode("cImage","ikon\folder2_blue.png").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","GDPR Policy").
oMenuXML:AddNode("cLaunch","wGDPRPolicy.w").
oMenuXML:AddNode("cImage","ikon\folder2_blue.png").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","GDPR unntak").
oMenuXML:AddNode("cLaunch","wGDPRPolicyUnntak.w").
oMenuXML:AddNode("cImage","ikon\folder2_green.png").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","GDPR Produktpolicy").
oMenuXML:AddNode("cLaunch","wGDPRProduktPolicy.w").
oMenuXML:AddNode("cImage","ikon\folder_cubes.png").

oMenuXML:AddBlockNode("sub-menu","menu-item").
oMenuXML:AddNode("cMenuLabel","GDPR Samtykketype").
oMenuXML:AddNode("cLaunch","wGDPRSamtykkeType.w").
oMenuXML:AddNode("cImage","ikon\folder.png").

oMenuXML:AddBlockNode("menu","menu-item").
oMenuXML:AddNode("cMenuLabel","Menyoppsett").
oMenuXML:AddNode("cLaunch","jboxMSTreeMenuMaint.w").
oMenuXML:AddNode("cImage","ico\wizard.ico").


/*oMenuXML:DumpXmlNodes().                   */
/*oMenuXML:saveToFile("c:\temp\meny.xml",no).*/

run toexcelviafile.p (oMenuXML:hbttNodes,0).
*/
