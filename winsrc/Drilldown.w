&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File:               JBoxQueryWrapper

  Description:        Wrapper for JBoxDataBrw 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:            brynjar@chemistry.no

  Created:           05.jun.2008

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&IF "{1}" = "Developer_Studio_is_Running" &THEN
  &SCOPED-DEFINE UIB_is_Running 1 
&ENDIF   

&IF DEFINED(UIB_is_Running) NE 0 &THEN
  DEF VAR hDataBrwWin AS HANDLE NO-UNDO.

  RUN JBoxDataBrw.w PERSIST SET hDataBrwWin.

  hDataBrwWin:CURRENT-WINDOW:TITLE = "<Query title>".

  SUBSCRIBE TO "InvalidateHandle" IN hDataBrwWin.
  
&ELSE
  DEF INPUT PARAM hDataBrwWin AS HANDLE NO-UNDO.
&ENDIF

DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR ix          AS INT    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO.

DEF VAR oDynDataBrowse AS JBoxDynDataBrowse NO-UNDO.

def var hColumn   as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     "Query wrapper:" VIEW-AS TEXT
          SIZE 16 BY 1.43 AT ROW 2.19 COL 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 62.8 BY 11.38 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<Insert window title>"
         HEIGHT             = 4
         WIDTH              = 63.4
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 114.2
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 114.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{incl/devmode.i}
{incl/custdevmode.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 11.38
       FRAME DEFAULT-FRAME:WIDTH            = 62.8.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <Insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <Insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  &IF DEFINED(UIB_is_Running) NE 0 &THEN
    DYNAMIC-FUNCTION("setParent" IN hDataBrwWin,THIS-PROCEDURE).
    
    RUN InitializeObject.
    IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
      RUN WaitForForm NO-ERROR.
    IF NOT THIS-PROCEDURE:PERSISTENT THEN
      WAIT-FOR CLOSE OF THIS-PROCEDURE.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  VIEW FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject C-Win 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Refer to the <jukebox>\winsrc\samples for working examples for Sports2000
------------------------------------------------------------------------------*/
/*hBrowse = DYNAMIC-FUNCTION("getBrowseHandle" IN hDataBrwWin). /* Placeholder */                     */
/*                                                                                                    */
/*DYNAMIC-FUNCTION("setAttribute",hBrowse,"userSettingContext",THIS-PROCEDURE:FILE-NAME).             */
DYNAMIC-FUNCTION("setEnableSaveQuery" IN hDataBrwWin,YES).
/*DYNAMIC-FUNCTION("setAttribute",hBrowse,"calcfieldproc","brwcalc_drillkon.p,eiendomrapp_brwcalc.p").*/
/*DYNAMIC-FUNCTION("setTotalFields" IN hDataBrwWin,"fSaldo,avgift-pr-ar").                            */

oDynDataBrowse:EnableSaveQuery = YES.
//oDynDataBrowse:TotalFields = "fSaldo,avgift-pr-ar".
oDynDataBrowse:BROWSE-OBJECT:userSettingContext = THIS-PROCEDURE:FILE-NAME.
//oDynDataBrowse:BROWSE-OBJECT:calcFieldProc = "brwcalc_drillkon.p,eiendomrapp_brwcalc.p".
oDynDataBrowse:InitializeQuery("npshtilbud"
              + ";!anleggsnr"
              + ";!kundenr"
              + ";tilbudsdato|Tilbudt gitt"
              + ';+tilbudsdato_month|CHARACTER|x(6)|jb_month(tilbudsdato)|Mnd(tilbudsdato)'
              + ';+tilbudsdato_q|CHARACTER|x(6)|jb_quarter(tilbudsdato)|Kvt(tilbudsdato)'
              + ';+tilbudsdato_year|CHARACTER|x(4)|jb_year(tilbudsdato)|�r(tilbudsdato)'
              + ";!id"
              + ";rabatt%"
              + ";pris"
              + ";avgittpris"
              + ";pris_shuntgrupper"
              + ";pris_tillegg"
              + ";lev_bet"
              + ";bet_bet"
              + ";opplysninger@37"
              + ";vaar_ref@36"
              + ";deres_ref@35"
              + ";tilbudsnr"
              + ";!tilbudsid"
 //             + ";gyldighetsid"
              + ",npshanlg;anleggsnr@3;anlegg@4;!kundenr;konsulentid;konsulentnr;dato|Anleggsdato@5;anbudsfrist@6;byggestart@6;!faktura#;selger@7;salgsdistrikt@8;!prosjektid"
              + ",norprosjekt;prosjektid@1;prosjekt_navn|Prosjekt@2;!reg_dato"
              + ",npshtopp;!id;!oppf_nr;oppf_dato;oppf_status;neste_oppf;neste_oppf_uke;neste_oppf_aar"
              + ",npKunde;kundenr@9;kundenavn@10;kundedistrikt@11;kundekategori@12"
              + ",buf1_npKunde;!kundenr;kundenavn|Konsulent@13"
/*              + ",npKonsulent;!konsulentid;konsulentnavn|Konsulent"*/
              ,"WHERE false"
              + ", first npshanlg of npshtilbud no-lock where npshanlg.aktivt"
              + ", first norprosjekt of npshanlg"
              + ", first npshtopp of npshtilbud"
              + ", first npkunde OUTER-JOIN of npshtilbud"
              + ", first buf1_npkunde OUTER-JOIN of npshanlg"
/*              + ", first npkonsulent OUTER-JOIN of npshanlg"*/
              ,"salgsdistrikt"
              ,true).

              hColumn = oDynDataBrowse:BROWSE-OBJECT:getColumnHandle('prosjekt_navn').
              hColumn:WIDTH-CHARS = 60.
              hColumn = oDynDataBrowse:BROWSE-OBJECT:getColumnHandle('anlegg').
              hColumn:WIDTH-CHARS = 60.
              hColumn = oDynDataBrowse:BROWSE-OBJECT:getColumnHandle('kundedistrikt').
              hColumn:WIDTH-CHARS = 60.
/*              hColumn = oDynDataBrowse:BROWSE-OBJECT:getColumnHandle('konsulentnavn').*/
/*              hColumn:WIDTH-CHARS = 60.                                               */
/*oDynDataBrowse:InitializeQuery(                                                                                                */
/*    "Objekt"                                                                                                                   */
/*      + ";prg-nr"                                                                                                              */
/*      + ";Lopenr"                                                                                                              */
/*      + ";Andelsnr"                                                                                                            */
/*      + ";+Fester|CHARACTER|x(30)|objekt_fester|Fester"                                                                        */
/*      + ";+FesterPnr|CHARACTER|x(6)|objekt_fester_pnr|Postnr"                                                                  */
/*      + ";+FesterEadr|CHARACTER|x(30)|objekt_fester_eadr|E-adr(EHF)"                                                           */
/*      + ";Kom-nr"                                                                                                              */
/*      + ";Gnr"                                                                                                                 */
/*      + ";Bnr"                                                                                                                 */
/*      + ";Fnr"                                                                                                                 */
/*      + ";Formal|Tekst(faktura)"                                                                                               */
/*      + ";FormalKode"                                                                                                          */
/*      + ";Inng-dato"                                                                                                           */
/*      + ";Regul-aar"                                                                                                           */
/*      + ";Utlop-aar"                                                                                                           */
/*      + ";Avgift-art"                                                                                                          */
/*      + ";Sperre"                                                                                                              */
/*      + ";SperreGrunn|Sp.g"                                                                                                    */
/*      + ";+SperretDato|DATE|99/99/99|objekt_sperredato|Dato sperret"                                                           */
/*      + ";+SperretAv|CHARACTER|x(12)|objekt_sperretav|Sperret av"                                                              */
/*      + ";Avgift-pr-ar"                                                                                                        */
/*      + ";FakturaMetode"                                                                                                       */
/*      + ";KPIregulering|KPIregulering|Ja/Nei"                                                                                  */
/*      + ";KPIregulering_lov|KPIregulering lovp�lagt|Ja/Nei"                                                                    */
/*      + ";Festeareal"                                                                                                          */
/*      + ";Antall-forfall"                                                                                                      */
/*      + ";Forfall-dato|Neste forfall"                                                                                          */
/*      + ";+Saldo|DECIMAL|-><>>><>>9.99|objekt_saldo|Saldo"                                                                     */
/*/*       + ";+Tapsavsetn|DECIMAL|-><>>><>>9.99|objekt_tapsavs|Tapsavs"  */                                                     */
/*    + ",Eiendom"                                                                                                               */
/*      + ";Navn@2"                                                                                                              */
/*    + ";+EiendomsKategori|CHARACTER|x(50)|EiendomsKategori|Kategori"                                                           */
/*    + ";+ForvSkog|CHARACTER|x(60)|ForvSkog|Forv. skog og utmark"                                                               */
/*    + ";+ForvKont|CHARACTER|x(60)|ForvKont|Forv. kontrakter"                                                                   */
/*    + ";+ForvPlan|CHARACTER|x(60)|ForvPlan|Forv. planer"                                                                       */
/*      + ";!Forv-nr|Forv.skog"                                                                                                  */
/*      + ";!E-forv-nr|Forv.ellers"                                                                                              */
/*      + ";!Sign-feste|Festeansv"                                                                                               */
/*      + ";!Sign-bygg|Byggansv"                                                                                                 */
/*      + ";!Sign-jordbruk"                                                                                                      */
/*    + ",Kommune"                                                                                                               */
/*      + ";Kom-Navn@9"                                                                                                          */
/*    + ",Avgift"                                                                                                                */
/*      + ";Tekst@19"                                                                                                            */
/*      + ";Konto"                                                                                                               */
/*      + ";Produkt"                                                                                                             */
/*      + ";Sted"                                                                                                                */
/*    + ",Sted"                                                                                                                  */
/*      + ";Tekst|Tekst(sted)"                                                                                                   */
/*    + ",genKode"                                                                                                               */
/*      + ";ckodebesk|Sp.g tekst@22"                                                                                             */
/*    + ",bruker"                                                                                                                */
/*      + ";brnavn|Saksbeh.feste"                                                                                                */
/*    + ",buf1_bruker"                                                                                                           */
/*      + ";brnavn|Saksbeh.bygg"                                                                                                 */
/*    + ",buf2_bruker"                                                                                                           */
/*      + ";brnavn|Saksbeh.planer jordbruk"                                                                                      */
/*    ,"WHERE false"                                                                                                             */
/*      + ",FIRST Eiendom NO-LOCK WHERE Eiendom.Prg-nr = Objekt.Prg-nr"                                                          */
/*      + ",FIRST Kommune NO-LOCK WHERE Kommune.Kom-nr = Objekt.Kom-nr OUTER-JOIN"                                               */
/*      + ",FIRST Avgift NO-LOCK WHERE Avgift.Art = Objekt.Avgift-art"                                                           */
/*      + ",FIRST Sted NO-LOCK WHERE Sted.sted = Avgift.sted OUTER-JOIN"                                                         */
/*      + ",FIRST genkode NO-LOCK WHERE genKode.cKodeType = 'sperregrunn' and genKode.cKodeverdi = Objekt.SperreGrunn OUTER-JOIN"*/
/*      + ",FIRST bruker NO-LOCK WHERE bruker.brkode = eiendom.sign-feste OUTER-JOIN"                                            */
/*      + ",FIRST buf1_bruker NO-LOCK WHERE buf1_bruker.brkode = eiendom.sign-bygg OUTER-JOIN"                                   */
/*      + ",FIRST buf2_bruker NO-LOCK WHERE buf2_bruker.brkode = eiendom.sign-jordbruk OUTER-JOIN"                               */
/*     ,"Prg-nr"  /* Initial sort */                                                                                             */
/*     ,TRUE). /* <- do record count */                                                                                          */


/*IF JBoxServerAPI:Instance:getActionPermission("JusterAvgift") THEN                 */
/*  oDynDataBrowse:POPUP-MENU-OBJECT:addTool("JusterAvgift","%-justering av avgift").*/
      

/*IF DYNAMIC-FUNCTION("getActionPermission",THIS-PROCEDURE:FILE-NAME,"","JusterAvgift") THEN*/
/*  DYNAMIC-FUNCTION("NewMenuBand",hBrowse                                                  */
/*                  ,"JusterAvgift;%-justering av avgift"                                   */
/*                  ,"").                                                                   */

/* Set attributes to define lookups (and drop-downs) in the dynamic filter: */
//{incl/dynfilterlookups.i oDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE}

/* Assist in describing the prescan q1uery route for Item since it is not directly joined from Order: */
oDynDataBrowse:BROWSE-OBJECT:setPreScanQuery("norprosjekt","EACH npshanlg WHERE npshanlg.prosjektid = norprosjekt.prosjektid NO-LOCK").
/*DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE,"prescanqueryAvgift","EACH npshanlg WHERE npshanlg.prosjektid = norprosjekt.prosjektid NO-LOCK").*/

/*DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE,"prescanqueryAvgift","EACH Objekt WHERE Objekt.Avgift-art = Avgift.Art NO-LOCK").*/
/*DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE,"prescanqueryBruker","EACH Eiendom NO-LOCK WHERE Eiendom.sign-feste = bruker.brkode,EACH Objekt OF Eiendom NO-LOCK").                     */
/*DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE,"prescanqueryBuf1_Bruker","EACH Eiendom NO-LOCK WHERE Eiendom.sign-forpakt = buf1_bruker.brkode,EACH Objekt OF Eiendom NO-LOCK").         */
/*DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE,"prescanquerySted","EACH Avgift NO-LOCK WHERE Avgift.sted = sted.sted,EACH Objekt WHERE Objekt.Avgift-art = Avgift.Art NO-LOCK").         */
/*DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE,"availdistinctcolumns","Kom-nr,Prg-nr,formalkode,regul-aar,utlop-aar,avgift-art,sperre,sign-feste,sign-forpakt,Tekst,konto,produkt,sted").*/
/*DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE,"availaccumfields","Avgift-pr-ar,Saldo").                                                                                                 */
/*DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE,"allowCan-DoFilterOperator","Avgift-art").                                                                                                */

/* Opt: More info on which datatypes and / or fields subject to accumulation or as distinct columns: */

/* DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT,"accumdatatypes","INTEGER"). */
/* DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT,"distinctdatatypes","CHARACTER,INTEGER,DATE"). */

/*
DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT,"availaccumfields","Belop,ValBelop").

DYNAMIC-FUNCTION("setAttribute",oDynDataBrowse:BROWSE-OBJECT,"availdistinctcolumns",
                 "Anlegg,AnleggTekst,AvgKode,AvgSystem,BetPeriode,BilagsArt,BilagsArtTekst,Bilagsdato,Bilagsnr,Bilagstype,cEiendomNavn,cKontoNavn,cProduktNavn,cProsjektNavn,cStedTekst,iEiendomNr,iHovedbokId,iJBoxCompanyId,iKontoNr,iProdukt,iProsjektNr,iSted,Kundegr,KundegrTekst,Linjenr,Periode,SrKonto,ValBelop,ValKode").
*/ 


//oDynDataBrowse:BROWSE-OBJECT:setFilter("").
oDynDataBrowse:BROWSE-OBJECT:openQuery().

/*
DYNAMIC-FUNCTION("startQuery" IN hDataBrwWin
                 ,"prg-nr,Sperre"   /* Filter fields (comma sep) */
                 ,"=,<>"   /* Filter operators (comma sep) */
                 ,"1|o"   /* Filter values (pipe sep) */
                 ,"prg-nr"   /* Initial sort column(s) (comma sep) */
                 ,""   /* Distinct columns (comma sep) */
                 ,""   /* Columns to accumulate (comma sep) */
                 ).
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InvalidateHandle C-Win 
PROCEDURE InvalidateHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihProc AS HANDLE NO-UNDO.

IF ihProc = hDataBrwWin THEN
  APPLY "close" TO THIS-PROCEDURE.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE JusterAvgiftRecord C-Win 
PROCEDURE JusterAvgiftRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR iReturn  AS INT NO-UNDO.
DEF VAR cPerCent AS CHAR NO-UNDO.

/*JBoxSession:Instance:PromptForValue("Angi prosentvis endring","DECIMAL","->9.99|").                                                                   */
/*IF JBoxSession:Instance:PromptValueOk THEN DO:                                                                                                        */
/*  IF oDynDataBrowse:BROWSE-OBJECT:processRows("objekt_juster_avgift.p",JBoxSession:Instance:PromptValue) THEN                                         */
/*    JBoxSession:Instance:ViewMessage("Avgift er justert for " + STRING(oDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE:NUM-SELECTED-ROWS) + " kontrakter").*/
/*END.                                                                                                                                                  */

/*
RUN JBoxAskForValue.w ("Angi prosentvis endring","DECIMAL|->9.99|",INPUT-OUTPUT cPerCent,OUTPUT iReturn).
IF iReturn = 2 THEN DO:  
  
  IF DYNAMIC-FUNCTION("ProcessSelectedRows",hBrowse,"objekt_juster_avgift.p",cPerCent) THEN
    JBoxSession:Instance:ViewMessage("Avgift er justert for " + STRING(hBrowse:NUM-SELECTED-ROWS) + " kontrakter"). 
END.    
*/  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE myDatabrowseObject C-Win 
PROCEDURE myDatabrowseObject :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ioDynDataBrowse AS JBoxDynDataBrowse NO-UNDO.
oDynDataBrowse = ioDynDataBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

