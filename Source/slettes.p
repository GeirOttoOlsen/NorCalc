
/*------------------------------------------------------------------------
    File        : slettes.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Mon Mar 13 15:55:18 CET 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

using Progress.Json.*.
using Progress.Json.ObjectModel.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
def var oConstruct as class JsonConstruct.
def var oParser as class ObjectModelParser.
def var oJsonArray as JsonArray.
def var oJsonObject as JsonObject.
def var iCount as int no-undo.
def var iLength as int no-undo.
def var lcSection as longchar no-undo.
def var cText as char no-undo.
def var oPerson as JsonArray.
def var cEpost as char no-undo.
def var cNavn as char no-undo.
DEFINE TEMP-TABLE ttJsonRecord 
FIELD nameProperty AS CHARACTER
FIELD emailProperty AS CHARACTER
FIELD IDProperty AS integer
.
FIX-CODEPAGE (lcSection) = 'utf-8'.
copy-lob file "e:\ken.json" to lcSection.

oParser = NEW ObjectModelParser(). 
oConstruct = oParser:Parse(lcSection).
/*oJsonObject = CAST(oParser:ParseFile("e:\ken.json"), JsonObject).*/
oJsonObject = cast(oConstruct,JsonObject).
oJsonArray = oJsonObject:GetJsonArray(('Adresser')).

iLength = oJsonArray:Length.
do iCount = 1 TO iLength on error  undo, next:
 oJsonObject = oJsonArray:GetJsonObject(iCount) no-error.
 if error-status:error then 
 do:
   MESSAGE oJsonArray:GetType(iCount)
   VIEW-AS ALERT-BOX.
   undo, next.
 end.
  assign 
    cNavn = ''
    cEpost = ''
  .
  cNavn = string(oJsonObject:GetJsonText('name')) no-error.
  cEpost = string(oJsonObject:GetJsonText('email')) no-error.
  MESSAGE cNavn skip cEpost
  VIEW-AS ALERT-BOX.
 /*  CREATE ttJsonRecord.                                         */
/*  ttJsonRecord.nameProperty =oJsonObject:GetCharacter("name"). */
/*  ttJsonRecord.emailProperty=oJsonObject:GetCharacter("email").*/
/*  ttJsonRecord.IDProperty=oJsonObject:GetInteger("ID").        */

END.
/*                                                               */
/*DELETE OBJECT oJsonArray NO-ERROR.                             */
/*DELETE OBJECT oParser NO-ERROR.                                */
/*                                                               */
/*FOR EACH ttJsonRecord:                                         */
/*  DISPLAY ttJsonRecord WITH 1 COLUMN SIDE-LABELS.              */
/*END.                                                           */