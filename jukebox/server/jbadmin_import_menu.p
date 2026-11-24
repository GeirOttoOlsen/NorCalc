/* Import menu from flat table (created from xml definition)
   Parameters:  

   Created: 15/01/19 by brynj
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR ix          AS INT    NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR cMenuName   AS CHAR   NO-UNDO.

{incl/validatecaller.i}

DEF TEMP-TABLE ttNewNodes 
    FIELD iNodeIndex  AS INT
    FIELD iJBoxMenuId AS INT
    .

CREATE QUERY hQuery.
hQuery:SET-BUFFERS (ihBuffer).
hQuery:QUERY-PREPARE("FOR EACH " + ihBuffer:NAME + " BY iNodeIndex").
hQuery:QUERY-OPEN().
hQuery:GET-FIRST().
ix = 1.

REPEAT WHILE NOT hQuery:QUERY-OFF-END:
  CREATE JBoxMenu.
  BUFFER JBoxMenu:BUFFER-COPY(ihBuffer,"iJBoxMenuId").
  JBoxMenu.dCreated = TODAY.
  IF JBoxMenu.cMenuType = "menu" THEN DO: 
    IF JBoxMenu.cMenuLabel = "" THEN JBoxMenu.cMenuLabel = "Imported " + STRING(NOW,"99/99/9999 hh:mm").
    cMenuName = JBoxMenu.cMenuLabel.
  END.
  ELSE IF JBoxMenu.cMenuType = "menu-item" AND JBoxMenu.cLaunchType = "" THEN
    JBoxMenu.cLaunchType = "START-WINDOW".
  
  CREATE ttNewNodes.
  ASSIGN ttNewNodes.iJBoxMenuId = JBoxMenu.iJBoxMenuId
         ttNewNodes.iNodeIndex  = ihBuffer::iNodeIndex
         .
  
  IF ihBuffer::iParentNodeIndex NE 0 THEN DO:
    FIND FIRST ttNewNodes 
         WHERE ttNewNodes.iNodeIndex = ihBuffer::iParentNodeIndex
         NO-ERROR.
    IF AVAIL ttNewNodes THEN DO:
      CREATE JBoxMenuToMenu.
      ASSIGN JBoxMenuToMenu.iToMenuId   = ttNewNodes.iJBoxMenuId
             JBoxMenuToMenu.iFromMenuId = JBoxMenu.iJBoxMenuId
             JBoxMenuToMenu.iSeq        = ihBuffer::iNodeIndex
             JBoxMenuToMenu.dCreated    = TODAY
             .
    END.         
  END.
   
  hQuery:GET-NEXT ().
END.  

FINALLY:
  obOk = ocReturn = "".
  IF obOk THEN ocReturn = cMenuName.
END FINALLY.
