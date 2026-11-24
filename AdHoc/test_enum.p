
/*------------------------------------------------------------------------
    File        : test_enum.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Thu Apr 11 11:13:33 CEST 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
using Openedge.Core.Collections.*.
USING OpenEdge.Core.KeyValuePair FROM PROPATH.
 
def var oList as Openedge.Core.Collections.StringCollection no-undo.
def var oI as OpenEdge.Core.Collections.IIterator no-undo.

def var oMap as OpenEdge.Core.Collections.StringStringMap no-undo.
def var oMap2 as OpenEdge.Core.Collections.StringKeyedMap no-undo.
def var oKey as OpenEdge.Core.Collections.KeySet no-undo.
def var oIMap as OpenEdge.Core.Collections.IMap no-undo.

def var ii as int no-undo.
def var pKey as char no-undo.
 
def var verdi as char no-undo.
oList = new StringCollection().
oMap = new StringStringMap().

oList:Add('Banan').
oList:Add('Eple').
oList:Add('Pære').
oI = oList:Iterator().
 
DO WHILE oI:HasNext():
  ii = ii + 1.
  verdi = oI:Next():ToString().
  MESSAGE verdi skip string(ii)
  VIEW-AS ALERT-BOX.
  oMap:Put(string(ii),Verdi).  
  MESSAGE '-->' verdi
  VIEW-AS ALERT-BOX.
end.

ii = 0.
MESSAGE 'size:' oMap:Size
VIEW-AS ALERT-BOX.
do ii = 1 to oMap:Size:
  pKey = string(ii).
  verdi = string(oMap:Get(pKey)).
  MESSAGE pKey verdi
  VIEW-AS ALERT-BOX.
end.


