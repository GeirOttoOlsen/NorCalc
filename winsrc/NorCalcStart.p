/*USING System.IO.*.                                                     */
/*DEF VAR cOsUser AS CHAR NO-UNDO.                                       */
/*DEFINE VARIABLE cCurrentDirectory AS CHAR NO-UNDO.                     */
/*                                                                       */
/*GET-KEY-VALUE SECTION "STARTUP"  KEY "HomeDir" VALUE cCURRENTDIRECTORY.*/
/*                                                                       */
/*IF  TRIM(cCurrentDirectory) NE "" AND                                  */
/*    cCurrentDirectory NE ? THEN                                        */
/*    Directory:SetCurrentDirectory(cCurrentDirectory).                  */

/*------------------------------------------------------------------------
    File        : startMypage.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Jun 21 14:32:27 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

ROUTINE-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEF VAR hServer AS HANDLE NO-UNDO.
DEF VAR bOk     AS LOG    NO-UNDO INIT YES.
CREATE SERVER hServer.

IF ENTRY(1,SESSION:PARAM,";") NE "" THEN
  hServer:CONNECT(ENTRY(1,SESSION:PARAM,";")).
ELSE DO:
/*  MESSAGE "Oppkoblingsparameter er ikke angitt og programmet kobler derfor til testserver" SKIP*/
/*          "Vil du fortsette?"                                                                  */
/*           VIEW-AS ALERT-BOX BUTTONS YES-NO UPDATE bOk.                                        */
/*  IF bOK THEN                                                                       */
/*    hServer:CONNECT("-H QA-SXD6E-013 -S 3050 -AppService bafoas -DirectConnect").   */
/*  ELSE DO:                                                                          */
/*    MESSAGE "Neivel, men da vil du kanskje koble til utviklingsserver?" SKIP        */
/*             VIEW-AS ALERT-BOX BUTTONS OK-CANCEL UPDATE bOk.                        */
/*    IF bOK THEN                                                                     */
/*      hServer:CONNECT("-H QA-SXD6E-013 -S 4050 -AppService BafoUtv -DirectConnect").*/
/*    ELSE                                                                            */
/*      QUIT.                                                                         */
/*  END.*/
    hServer = session.
END.  
  MESSAGE 'her'
  VIEW-AS ALERT-BOX.
RUN InitNorcalc.p PERSISTENT ("goo",hServer).
WAIT-FOR System.Windows.Forms.Application:Run().