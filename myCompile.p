/*------------------------------------------------------------------------
    File        : msgqcompile.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Wed Nov 09 09:07:06 CET 2016
    Notes       :
/*  oCompile:addDirectory('.\server\',"{&myPath2}\server").*/
    
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/*using System.IO.*.*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

/*DEFINE VARIABLE oFileInfo     AS CLASS   System.IO.FileInfo.*/
def var oCompile as class JBoxCompile no-undo.
def var oCMD as JBoxCMD no-undo.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
  oCompile = new JBoxCompile('e:\ws_git\norcalc','/compile.log',3).
  oCompile:RCODEDIR = 'e:\rcode\norcalc'.
  //oCompile:copyToDirectory = '\\10.12.0.16\c$\testnorcalc\'.
  //oCompile:copyToDirectory = '\\10.12.0.16\c$\norcalc\'.
/*  oCompile:addDirectory('.\profiler\',"{&myPath2}\Profiler").*/
/*  oCompile:addDirectory('.\jukebox\oo').                 */
/*  oCompile:addDirectory('.\jukebox\oo\uc',"\jukebox\oo").*/
/*  oCompile:addDirectory('.\jukebox\lib').                */
/*  oCompile:addDirectory('.\jukebox\obj').                */
/*                                                         */
/*  oCompile:addDirectory('.\jukebox\server').    */
/*  oCompile:addDirectory('.\jukebox\server\trg').*/

/*  oCompile:addDirectory('.\winsrc').*/

/*  oCompile:addDirectory('.\source','\prod').*/
/*  oCompile:addDirectory('.\server').    */
/*  oCompile:addDirectory('.\server\trg').*/

  oCompile:startCompile().
  
/*  oCompile:CompileCommand('.\jukebox\winsrc\jboxappstart.p').*/
/*  oCompile:CompileCommand('.\winsrc\norcalcstart.p').*/
/*  oCompile:CompileCommand('.\winsrc\initNorcalc.p'). */
/*  oCompile:CompileCommand('.\jukebox\oo\jboxMainForm.cls').*/
/*  oCompile:CompileCommand('.\jukebox\oo\jboxRibbonMenu.p').*/
/*  oCompile:CompileCommand('.\jukebox\oo\jboxMainMenu.cls').*/
  

/*  oCompile:CompileCommand('.\source\kundekrt.w').           */
/*  oCompile:CompileCommand('.\source\kundered.w').           */
/*  oCompile:CompileCommand('.\winsrc\wProsjekt.w').          */
/*  oCompile:CompileCommand('.\winsrc\wNPKunde.w').           */
/*  oCompile:CompileCommand('.\winsrc\wSHTilbudBrw.w').       */
/*  oCompile:CompileCommand('.\winsrc\wNPKundeOppfølging.w'). */
/*  oCompile:CompileCommand('.\winsrc\wNPKundeDetalj.w').     */
/*  oCompile:CompileCommand('.\server\prosjekt_brwcalcfld.p').*/
/*  oCompile:CompileCommand('.\winsrc\wSHAnleggBrw.w').       */
/*  oCompile:CompileCommand('.\winsrc\wSHAnleggBrw3.w').      */
/*  oCompile:CompileCommand('.\winsrc\wSHTilbudOppfolging.w').*/
/*  oCompile:CompileCommand('.\winsrc\wSHTilbudBrw2.w').      */
/*                                                            */
/*  oCompile:CompileCommand('.\winsrc\wNPKontakt.w').*/
/*  oCompile:CompileCommand('.\server\trg\cre_npkontakt.p').  */

/*  oCompile:CompileCommand('.\source\b-kontak.w').           */
/*  oCompile:CompileCommand('.\source\v-kontak.w').           */
/*  oCompile:CompileCommand('.\source\shusyst.w').*/
/*  oCompile:CompileCommand('.\source\shtlbred.w').*/
/*  oCompile:CompileCommand('.\source\shendopp.w').*/
/*  oCompile:CompileCommand('.\source\prosjred.w').*/
/*  oCompile:CompileCommand('.\source\shanlred.w').*/
/*  oCompile:CompileCommand('.\source\shtilbud.w').*/
/*  oCompile:CompileCommand('.\source\shnyoppf.w').*/
  
/*  oCompile:CompileCommand('.\server\trg\cre_npshforstilling.p').*/
  
  oCompile:CompileCommand('.\source\shtlbred.w').
  oCompile:CompileCommand('.\winsrc\wNPLeveringsbetingelse.w').

  copy-lob object oCompile:Logg to file oCompile:LogFile.  
  oCMD = new JBoxCMD('Notepad.exe',oCompile:LogFile).
   


