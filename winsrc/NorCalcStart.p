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
/*def var username as char no-undo.*/
def var username as char no-undo.

assign 
  username = System.Environment:UserName
/*  username = System.Security.Principal.WindowsIdentity:GetCurrent():Name           */
/*  username = if index(username,'//') gt 0 then entry(2,username,'//') else username*/
  .

CREATE SERVER hServer.

IF ENTRY(1,SESSION:PARAM,";") NE "" THEN
  hServer:CONNECT(ENTRY(1,SESSION:PARAM,";")).
else
  hServer = session.

username = if username = 'administrator' then 'goo' else username.

RUN InitNorcalc.p PERSISTENT (username,hServer).

WAIT-FOR System.Windows.Forms.Application:Run().

