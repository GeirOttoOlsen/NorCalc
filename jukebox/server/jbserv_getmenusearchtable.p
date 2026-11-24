/* Update table-to-table link
   Parameters:  <parentid>|<childid-list>

   Created: 14/10/25 by ext_brha
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

VAR HANDLE hTempTable,hQuery.

{incl/validatecaller.i}

RUN jbsetup_getmenustruct.p (icSessionId,"WHERE cMenuType = 'menu'",OUTPUT TABLE-HANDLE hTempTable,OUTPUT ocReturn).

CREATE QUERY hQuery.
hQuery:SET-BUFFERS(hTempTable:DEFAULT-BUFFER-HANDLE).
hQuery:QUERY-PREPARE ("FOR EACH " + hTempTable:DEFAULT-BUFFER-HANDLE:NAME + " WHERE cMenuType = 'menu-item'").
hQuery:QUERY-OPEN ().

REPEAT WHILE hQuery:GET-NEXT().
  ihBuffer:BUFFER-CREATE ().
  ihBuffer:BUFFER-COPY(hTempTable:DEFAULT-BUFFER-HANDLE).
  FIND FIRST JBoxMenu NO-LOCK
       WHERE JBoxMenu.iJBoxMenuId = hTempTable:DEFAULT-BUFFER-HANDLE::iParentMenuId 
       NO-ERROR.
  IF AVAIL JBoxMenu THEN
    ihBuffer::cMenuLabel3 = JBoxMenu.cMenuLabel.
END.

CATCH eErr AS Progress.Lang.Error :
  ocReturn = eErr:GetMessage(1).  
END CATCH.

FINALLY:
  DELETE OBJECT hTempTable NO-ERROR.
  DELETE OBJECT hQuery NO-ERROR.
  obOk = ocReturn = "".
END FINALLY.
