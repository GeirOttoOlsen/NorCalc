
/*------------------------------------------------------------------------
    File        : InitJukeBoxTools.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Fri Mar 24 18:13:08 CET 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEF INPUT PARAM icConnectParam AS CHAR NO-UNDO.
DEF INPUT PARAM ihServer AS HANDLE NO-UNDO.

DEF VAR oMenuXML         AS JBoxXmlDoc NO-UNDO.
DEF VAR oJBoxMainForm    AS JBoxMainForm NO-UNDO. 
DEF VAR hDialogFrame     AS HANDLE NO-UNDO.
DEF VAR hTimer           AS HANDLE NO-UNDO.
DEF VAR bOkUser          AS LOG NO-UNDO.
DEF VAR iBrukerNivaa     AS INT NO-UNDO.
DEF VAR hProgBar         AS HANDLE NO-UNDO.
DEF VAR cSessfile        AS CHAR NO-UNDO.
DEF VAR cSessId          AS CHAR NO-UNDO.
DEF VAR cLine            AS CHAR NO-UNDO.

JBoxSession:Instance:AppTitle = "LazyBI".
JBoxSession:Instance:UseAdvGui = YES.
JBoxSession:Instance:setRowShadeColor(240,240,240).

RUN HideSplash IN SOURCE-PROCEDURE NO-ERROR.

IF ihServer NE SESSION THEN DO:
  JBoxSession:Instance:AppServerHandle = ihServer.
  RUN JBoxLogin.w (OUTPUT bOkUser).
  IF NOT bOkUser THEN QUIT.
END.
ELSE DO:
  cSessfile = SEARCH("incl/custdevmode.i").
  IF cSessfile NE ? THEN DO:
    INPUT FROM VALUE(cSessfile).
    REPEAT:
      IMPORT UNFORMATTED cLine.
      IF cLine MATCHES '*setSessionId*' THEN
        cSessId = REPLACE(REPLACE(REPLACE(ENTRY(NUM-ENTRIES(cLine),cLine),'"',""),".",""),")","").
    END.
    INPUT CLOSE.
    IF cSessId = "" OR cSessId = "ocSessionId" THEN cSessId = "validsession".
    DYNAMIC-FUNCTION("setSessionId",cSessId).
  END.
END.
JBoxSession:Instance:LanguageCode = "EN".    
JBoxSession:Instance:BaseLanguageCode = "EN".
JBoxSession:Instance:setJBoxAttribute("DbViewerCanUpdate","yes").

/*RUN JBoxProgressBar.w PERSISTENT SET hProgBar.                    */
/*DYNAMIC-FUNCTION("SetStartupProgress" in hProgBar, 10,"Starts..").*/

JBoxMainMenu:Instance:DeleteMenu().

IF SEARCH("config\JBoxMenu.xml") = ? THEN DO:

  oMenuXML = NEW JBoxXmlDoc().
  oMenuXML:AddBlockNode("menu").
  oMenuXML:AddNode("cStateImage","png\j0432620.png"). /* logo */
  
  /*  oMenuXML:AddBlockNode("sub-menu").                           */
  /*  oMenuXML:AddNode("cMenuLabel","Setup").                      */
  /*                                                               */
  /*    oMenuXML:AddBlockNode("sub-menu","menu-item").             */
  /*    oMenuXML:AddNode("cMenuLabel","Data sources").             */
  /*    oMenuXML:AddNode("cLaunch","CreateDataSourceDefinition.w").*/
  /*    oMenuXML:AddNode("cImage","png\j0431631.png").             */
  
  oMenuXML:AddBlockNode("tv-nav-bar").
    oMenuXML:AddBlockNode("sub-menu").
    oMenuXML:AddNode("cMenuLabel","Home").
  
      oMenuXML:AddBlockNode("sub-menu","menu-item").
      oMenuXML:AddNode("cMenuLabel","Database Explorer").
      oMenuXML:AddNode("cLaunch","JBoxDbViewer.w").
      oMenuXML:AddNode("cImage","ico\MSACCESSform.ico").
  
      oMenuXML:AddBlockNode("sub-menu","menu-item").
      oMenuXML:AddNode("cMenuLabel","Database Views").
      oMenuXML:AddNode("cLaunch","JBoxViewDsDef.w").
      oMenuXML:AddNode("cImage","ico\MSACCESSforms.ico").
  
      oMenuXML:AddBlockNode("sub-menu","menu-item").
      oMenuXML:AddNode("cMenuLabel","Json Explorer").
      oMenuXML:AddNode("cLaunch","JBoxJsonViewer.w").
      oMenuXML:AddNode("cImage","ico\MSACCESSmodel.ico").
  //    oMenuXML:AddNode("cParameter","testparam2").
  
      oMenuXML:AddBlockNode("sub-menu","menu-item").
      oMenuXML:AddNode("cMenuLabel","REST Explorer").
      oMenuXML:AddNode("cLaunch","JBoxRestViewer.w").
      oMenuXML:AddNode("cImage","ico\cloud_computing_download.ico").
  //    oMenuXML:AddNode("cImage","png\j0432634.png").
  
  /*  oMenuXML:AddBlockNode("tv-nav-bar","sub-menu").            */
  /*  oMenuXML:AddNode("cMenuLabel","PRS meny 2").               */
  /*                                                             */
  /*    oMenuXML:AddBlockNode("sub-menu","menu-item").           */
  /*    oMenuXML:AddNode("cMenuLabel","VG").                     */
  /*    oMenuXML:AddNode("cLaunch","http://www.vg.no").          */
  /*    oMenuXML:AddNode("cLaunchType","URL").                   */
  /*    oMenuXML:AddNode("cImage","ico\tankgreen.ico").          */
  /*                                                             */
  /*    oMenuXML:AddBlockNode("sub-menu","menu-item").           */
  /*    oMenuXML:AddNode("cMenuLabel","Lokal fil").              */
  /*    oMenuXML:AddNode("cLaunch","file:///C:/temp/firma.html").*/
  /*    oMenuXML:AddNode("cLaunchType","URL").                   */
  /*    oMenuXML:AddNode("cImage","ico\tankred.ico").            */
      
  oMenuXML:AddBlockNode("menu","menu-item").
  oMenuXML:AddNode("cMenuLabel","Data sources").
  oMenuXML:AddNode("cLaunch","CreateDataSourceDefinition.w").
  oMenuXML:AddNode("cImage","png\j0431631.png").
  
  oMenuXML:AddBlockNode("menu","menu-item").
  oMenuXML:AddNode("cMenuLabel","Object viewer").
  oMenuXML:AddNode("cLaunch","JBoxObjectViewer.w").
  oMenuXML:AddNode("cImage","ico\boxes.ico").
      
  JBoxMainMenu:Instance:LoadMenuFromXMLNodeTable(oMenuXML:hbttNodes).
END.
ELSE JBoxMainMenu:Instance:LoadMenuFromXMLfile(SEARCH("config\jboxmenu.xml")).

//run toexcelviafile.p (JBoxMainMenu:Instance:MenuNodeBufferHandle,0).

JBoxMainMenu:Instance:InitializeObject().
/*JBoxMainMenu:Instance:InitializeObject(iiMenuId).*/

JBoxMainMenu:Instance:StatusText = OS-GETENV("username").
JBoxMainMenu:Instance:setWindowCaption(IF NUM-ENTRIES(SESSION:PARAMETER,";") > 1 THEN ENTRY(2,SESSION:PARAMETER,";") ELSE "Chemistry AS").
/*JBoxMainMenu:Instance:ViewStartPanel("http://bafomypage.northeurope.cloudapp.azure.com:81/ansa/").*/
/*JBoxMainMenu:Instance:ViewStartPanel("https://medlemsforsikringer.soderbergpartners.no/ansa").*/

/*IF oFirmaInfo:getParameterString('URLHjemmeside') NE ? THEN                            */
/*  JBoxMainMenu:Instance:ViewStartPanel(oFirmaInfo:getParameterString('URLHjemmeside')).*/
/*ELSE                                                                                   */
//  JBoxMainMenu:Instance:ViewStartPanel(IF NUM-ENTRIES(SESSION:PARAMETER,";") > 2 THEN ENTRY(3,SESSION:PARAMETER,";") ELSE 'http://aia.appfarm.no/chemistry/jukebox/JukeBox_tmphtm/index.html').
    
CATCH eAny AS Progress.Lang.Error :
  MESSAGE eAny:GetMessage(1)
  VIEW-AS ALERT-BOX.  
  QUIT.
END CATCH.