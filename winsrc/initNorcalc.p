
/*------------------------------------------------------------------------
    File        : InitNorcal.p
    Purpose     : Start JukeBox libraries and init menu

    Syntax      :

    Description :   

    Author(s)   : Brynjar
    Created     : Thu May 26 11:06:48 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

ROUTINE-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEF INPUT PARAM icUserId AS CHAR NO-UNDO.
DEF INPUT PARAM ihServer AS HANDLE NO-UNDO.

/*DEF VAR oMenuXML         AS JBoxXmlDoc NO-UNDO.  */
/*DEF VAR oJBoxMainForm    AS JBoxMainForm NO-UNDO.*/
DEF VAR hDialogFrame     AS HANDLE NO-UNDO.
DEF VAR hTimer           AS HANDLE NO-UNDO.
DEF VAR bOkUser          AS LOG NO-UNDO.


ON 'close':U OF THIS-PROCEDURE RETURN.

JBoxSession:Instance:AppServerHandle = ihServer.
JBoxSession:Instance:AppTitle = "NorCalc".

/*def var oFirmaInfo as class SysParameter_cl no-undo.*/
/*oFirmaInfo = new SysParameter_cl('FirmaInfo',0).    */


/*RUN JBoxLogin.w (OUTPUT bOkUser).*/
RUN JBoxWebLogin.w (icUserId,'NO',OUTPUT bOkUser).


JBoxSession:Instance:setJBoxAttribute('btnImg_browseconfig','img/ico/table.ico').
JBoxSession:Instance:setJBoxAttribute('btnImg_refresh','img/ico/document_refresh.ico').
JBoxSession:Instance:setJBoxAttribute('btnImg_filter','img/ico/document_find.ico').
JBoxSession:Instance:setJBoxAttribute('btnImg_excel','img/ico/excel.ico').

/*JBoxSession:Instance:setJBoxAttribute('btnImg_edit','img/ico/document_edit.ico').*/
/*JBoxSession:Instance:setJBoxAttribute('btnImg_new','img\ico\document_add.ico').  */
//JBoxSession:Instance:setJBoxAttribute('btnImg_new_disabled','gif/document_add_disabled.gif').

//JBoxSession:Instance:LanguageCode = "NO".
//JBoxSession:Instance:BaseLanguageCode = "NO".
JBoxSession:Instance:UseAdvGui = YES.
JBoxSession:Instance:setRowShadeColor(240,240,240).

IF NOT bOkUser THEN QUIT.

JBoxMainMenu:Instance:InitializeObject(1).

//  JBoxMainMenu:Instance:oMainForm:Height = JBoxMainMenu:Instance:oMainForm:Height + 80.
  
/*JBoxMainMenu:Instance:StatusText = IF icUserId NE "" THEN icUserId ELSE JBoxSession:Instance:UserId + " / " + JBoxSession:Instance:UserName.*/
/*JBoxMainMenu:Instance:setWindowCaption("NorCalc" + IF SESSION:PARAM MATCHES "*test*" THEN " - TEST" ELSE "").                               */

  //JBoxMainMenu:Instance:ViewStartPanel().
  
  /*
  IF oFirmaInfo:getParameterString('URLHjemmeside') NE ? THEN 
    JBoxMainMenu:Instance:ViewStartPanel(oFirmaInfo:getParameterString('URLHjemmeside')).
  ELSE
    JBoxMainMenu:Instance:ViewStartPanel('https://www.soderbergpartners.no').
  */

/*
PROCEDURE StartNyGUI:
  IF VALID-OBJECT(JBoxMainMenu:Instance:oMainForm) THEN 
    JBoxMainMenu:Instance:oMainForm:BringToFront().
  ELSE DO:
  
    JBoxMainMenu:Instance:RestartMenu().
    
    JBoxMainMenu:Instance:InitializeObject(1).
  
    JBoxMainMenu:Instance:QuitOnClose = NO.
  
  //  JBoxMainMenu:Instance:oMainForm:Height = JBoxMainMenu:Instance:oMainForm:Height + 80.
    
    JBoxMainMenu:Instance:StatusText = IF icUserId NE "" THEN icUserId ELSE JBoxSession:Instance:UserId + " / " + JBoxSession:Instance:UserName.
    JBoxMainMenu:Instance:setWindowCaption("SP" + IF SESSION:PARAM MATCHES "*013*utv*" THEN " - UTV" ELSE IF SESSION:PARAM MATCHES "*013*" THEN " - TEST" ELSE "").
  END.  
END.

PROCEDURE getMyDbUser:
  DEF INPUT  PARAM icOsUser AS CHAR  NO-UNDO.
  DEF OUTPUT PARAM ocDbUser AS CHAR  NO-UNDO.
  
  DEF VAR cOsUserList AS CHAR NO-UNDO
      INIT "qa309,qa04,qa03,qa41,qa30,qa10,qa12,qa131,qa13,qa14,qa15,qa32,qa31,qa02,qa37,qa84,qa05,qa-3PThinc,qa297,qa42,qa116,qa33,qa275,qa43,qa115,qa134,qa06,qa296,qa19,qa38,qa21,qa25,qa01,qa07,qa34,qa283,qa307,qa274,qa178,qa28,qa45,qa127,qa153,qa40,qa120,qa46,qa36,qa99,brynj,qa-3pchemistry,qa333,qa329,qa327,qa334,qa328"
      .

  DEF VAR cDbUserList AS CHAR NO-UNDO
      INIT "aeg,afl,ao,boe,cc,cs,cv,dh,ek,eka,el,eld,emm,et,fj,fs,gm,goo,hk,im,jh,jkh,jof,kf,kj,kl,lhy,llr,ltm,mt,mv,osc,osp,pb,rah,raj,shl,sik,sr,st1,stj,tc,th,TK,tmj,tso,ul,vkl,che,che,awj,ce,dmq,thf,thv"
      .      
      
  IF LOOKUP(icOsUser,cOsUserList) > 0 THEN
    ocDbUser = ENTRY(LOOKUP(icOsUser,cOsUserList),cDbUserList) NO-ERROR.
        
  IF ocDbUser = "" OR ocDbUser = ? THEN ocDbUser = icOsUser.     
END PROCEDURE.      
*/
