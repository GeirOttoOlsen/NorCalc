/* jbadmin_getmenutranslation.p
   Retrieve translations for the main menu for the translation program, JBoxMenuTranslation.w 
   
   Created 18.08.10 by brynjar@chemistry.no
--------------------------------------------------------------------------*/   
DEF INPUT  PARAM icParam         AS CHAR   NO-UNDO.
DEF INPUT  PARAM ihBuffer        AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId     AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ocReturn        AS CHAR   NO-UNDO.
DEF OUTPUT PARAM obOk            AS LOG    NO-UNDO.

{incl/validatecaller.i}

DEF VAR hQuery AS HANDLE NO-UNDO.
DEF VAR hbJBoxMenuTranslation AS HANDLE NO-UNDO.
DEF VAR bFound                AS LOG    NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxMenuTranslation",OUTPUT hbJBoxMenuTranslation) THEN RETURN.

CREATE QUERY hQuery.
hQuery:SET-BUFFERS(ihBuffer).
hQuery:QUERY-PREPARE("FOR EACH " + ihBuffer:NAME).
hQuery:QUERY-OPEN().
hQuery:GET-FIRST().
REPEAT WHILE NOT hQuery:QUERY-OFF-END:
  bFound = hbJBoxMenuTranslation:FIND-FIRST("WHERE JBoxMenuTranslation.iJBoxMenuId = " + STRING(INT(ihBuffer:BUFFER-FIELD("iJBoxMenuId"):BUFFER-VALUE))
                                          + " AND JBoxMenuTranslation.cLanguage = '" + icParam + "'",NO-LOCK) NO-ERROR.
  IF bFound THEN
    ASSIGN ihBuffer:BUFFER-FIELD("cMenuLabel"):BUFFER-VALUE   = hbJBoxMenuTranslation::cMenuLabel
           ihBuffer:BUFFER-FIELD("cAccelerator"):BUFFER-VALUE = hbJBoxMenuTranslation::cAccelerator
           ihBuffer:BUFFER-FIELD("cMenuTooltip"):BUFFER-VALUE = hbJBoxMenuTranslation::cMenuTooltip
           .
  ELSE
    ASSIGN ihBuffer:BUFFER-FIELD("cMenuLabel"):BUFFER-VALUE   = ""
           ihBuffer:BUFFER-FIELD("cAccelerator"):BUFFER-VALUE = ""
           ihBuffer:BUFFER-FIELD("cMenuTooltip"):BUFFER-VALUE = ""
           .
  hQuery:GET-NEXT().
END.

FINALLY:
  DELETE OBJECT hQuery NO-ERROR.
  DELETE OBJECT hbJBoxMenuTranslation NO-ERROR.
  obOk = ocReturn = "".
END FINALLY.
   

