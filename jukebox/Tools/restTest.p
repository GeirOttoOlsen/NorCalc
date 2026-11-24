
/*------------------------------------------------------------------------
    File        : restTest.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Thu Mar 30 09:06:03 CEST 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  BLOCK-LEVEL ON ERROR UNDO, THROW.

  DEF VAR hDsResponse AS HANDLE NO-UNDO.

  DEF VAR sessionId       AS CHAR NO-UNDO.
  DEF VAR methodProc      AS CHAR NO-UNDO.
  DEF VAR oJBoxJsonParser AS JBoxJsonParser NO-UNDO.
  DEF VAR hAsLib          AS HANDLE NO-UNDO.
  DEF VAR bOk             AS LOG NO-UNDO.
  
  DEF VAR lcCallPAram AS LONGCHAR NO-UNDO.
  
  FIX-CODEPAGE(lcCallParam) = "UTF-8".

  RUN JBoxDLargeEditor.w (INPUT-OUTPUT lcCallParam,NO,NO,NO,"",OUTPUT bOK).
  IF NOT bOk THEN RETURN.   

  oJBoxJsonParser = NEW JBoxJsonParser().
  oJBoxJsonParser:createSchema(lcCallPAram,"callparam").
  oJBoxJsonParser:returnBlankWhenNoValue = YES.
  
  sessionId = oJBoxJsonParser:getResultFirstFieldValue("callparam","sessionid").
  

  IF NOT VALID-HANDLE(JBoxServerSide:Instance:hJbServerLib) THEN DO:
    RUN "jbserv_api_for_server.p" PERSIST SET hAsLib (sessionId).
    SESSION:ADD-SUPER-PROCEDURE(hAsLib).
    JBoxServerSide:Instance:hJbServerLib = hAsLib.
  END.  
  
  JBoxServerSide:Instance:InitializeObject(?,sessionId).
  
  RUN JBoxLoadLib.p("JBoxUILib.p").
  

  methodProc = "jbrest_" + oJBoxJsonParser:getResultFirstFieldValue("callparam","method") + ".p".
  MESSAGE "debug from here.."
  VIEW-AS ALERT-BOX.
  RUN VALUE(methodProc) (oJBoxJsonParser,INPUT-OUTPUT DATASET-HANDLE hDsResponse).

  IF JBoxServerSide:Instance:HasError THEN DO:
    JBoxServerSide:Instance:httError:WRITE-JSON("file",SESSION:TEMP-DIR + ENTRY(1,methodProc,".") + "_error.json",yes,"UTF-8").
    OS-COMMAND NO-WAIT VALUE ("notepad " + SESSION:TEMP-DIR + ENTRY(1,methodProc,".") + "_error.json").
  END.
  ELSE DO: 
    hDsResponse:WRITE-JSON("file",SESSION:TEMP-DIR + ENTRY(1,methodProc,".") + "_result.json",yes,"UTF-8").
    OS-COMMAND NO-WAIT VALUE ("notepad " + SESSION:TEMP-DIR + ENTRY(1,methodProc,".") + "_result.json").
  END.
