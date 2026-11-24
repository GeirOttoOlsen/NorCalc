
/*------------------------------------------------------------------------
    File        : jbox_rest_fieldlist.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Tue Oct 18 16:59:21 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

DEF INPUT PARAM ioCallParam   AS JBoxJsonParser NO-UNDO.
DEF INPUT-OUTPUT PARAM DATASET-HANDLE odsResponse.

DEF VAR cDelimiter AS CHAR NO-UNDO.

DEF TEMP-TABLE fieldlist NO-UNDO
    FIELD delimiter_ AS CHAR INIT "|" SERIALIZE-NAME "delimiter"
    FIELD list       AS CLOB
    .

CREATE fieldlist.
cDelimiter = ioCallParam:getResultFirstFieldValue("callparam","delimiter").
IF cDelimiter = "" THEN cDelimiter = "|".
ELSE fieldlist.delimiter_ = cDelimiter. 

DEF VAR httResult AS HANDLE NO-UNDO.

DO ON ERROR UNDO, THROW:
  fieldlist.list = JBoxServerSide:Instance:FieldListValid(ioCallParam:getResultFirstFieldValue("callparam","buffersAndFields")
                                                         ,ioCallParam:getResultFirstFieldValue("callparam","queryString")
                                                         ,cDelimiter
                                                         ).                                                         
END.                                                           

CREATE DATASET odsResponse.
odsResponse:NAME = "response".
odsResponse:ADD-BUFFER (BUFFER fieldlist:HANDLE).

