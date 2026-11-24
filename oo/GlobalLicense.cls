 
/*------------------------------------------------------------------------
   File        : GlobalLicense
   Purpose     : 
   Syntax      : 
   Description : Eier THInc Consulting AS
   Author(s)   : goo_000
   Created     : Mon Dec 09 21:06:47 CET 2019
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS GlobalLicense: 
  DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS GlobalLicense NO-UNDO
         GET():
           IF Instance = ? THEN Instance = NEW GlobalLicense().
           RETURN Instance.
         END GET.
         PRIVATE SET.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE oGlobal AS Chilkat.Global NO-UNDO.
  CONSTRUCTOR PUBLIC GlobalLicense (  ):
    oGlobal  = NEW Chilkat.Global().
    oGlobal:UnlockBundle("THINCN.CB1012024_7epfc6mU595J").      
  END CONSTRUCTOR.
  
  METHOD PUBLIC void ReadLicense ().
  
  END METHOD.
  
END CLASS.