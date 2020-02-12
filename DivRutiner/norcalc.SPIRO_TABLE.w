/* Variable definitions: */

DEF VAR hnd-win      AS WIDGET-HANDLE NO-UNDO.
DEF VAR bOK          AS LOGICAL NO-UNDO.
DEF VAR cExpFile     AS CHAR FORMAT 'X(40)' NO-UNDO INIT 'c:\temp\norcalc-SPIRO_TABLE.csv'.

DEF VAR hResizeLib   AS HANDLE NO-UNDO.
DEF VAR cSortColumn  AS CHAR NO-UNDO.
DEF VAR bDesc        AS LOG NO-UNDO.
/* Window definition: */

CREATE WINDOW hnd-win
       ASSIGN HEIGHT             = 15
              WIDTH              = 100
              MAX-HEIGHT         = 90
              MAX-WIDTH          = 246
              VIRTUAL-HEIGHT     = 30
              VIRTUAL-WIDTH      = 146
              RESIZE             = yes
              SCROLL-BARS        = no
              STATUS-AREA        = no
              KEEP-FRAME-Z-ORDER = yes
              THREE-D            = yes
              SENSITIVE          = yes
              MESSAGE-AREA       = no
              TITLE              = 'Contents of norcalc.SPIRO_TABLE (?)'.

bOK = hnd-win:LOAD-ICON('adeicon/dict%.ico').
ASSIGN CURRENT-WINDOW = hnd-win.

/* Widget definitions: */

DEFINE BUTTON Btn_Done DEFAULT
       LABEL '&Close'
       SIZE 9 BY 1.17
       BGCOLOR 8.

DEFINE BUTTON Btn_Export
       LABEL '&Export'
       SIZE 9 BY 1.17
       BGCOLOR 8.

/* Query and Browse definition: */

DEFINE QUERY q1 FOR norcalc.SPIRO_TABLE.

DEFINE BROWSE b1 QUERY q1
  DISPLAY
      norcalc.SPIRO_TABLE.id# COLUMN-LABEL "!id#"
      norcalc.SPIRO_TABLE.varenr COLUMN-LABEL "Varenr!varenr"
      norcalc.SPIRO_TABLE.nrf_nr COLUMN-LABEL "NRF!nrf_nr"
      norcalc.SPIRO_TABLE.produktnavn COLUMN-LABEL "Produktnavn!produktnavn"
      norcalc.SPIRO_TABLE.dimmensjon COLUMN-LABEL "Dimm.!dimmensjon"
      norcalc.SPIRO_TABLE.innl_hastighet COLUMN-LABEL "!innl_hastighet"
      norcalc.SPIRO_TABLE.kpa COLUMN-LABEL "KPA!kpa"
      norcalc.SPIRO_TABLE.pris COLUMN-LABEL "Pris!pris"
      norcalc.SPIRO_TABLE.ror_dim COLUMN-LABEL "Rørdim.!ror_dim"
      norcalc.SPIRO_TABLE.vegg_tykkelse COLUMN-LABEL "Veggtykkelse!vegg_tykkelse"
      norcalc.SPIRO_TABLE.anslutning COLUMN-LABEL "Anslutning!anslutning"
      norcalc.SPIRO_TABLE.materialkvaliteter COLUMN-LABEL "Materialkval.!materialkvaliteter"
  ENABLE materialkvaliteter
  WITH NO-ROW-MARKERS SEPARATORS SCROLLABLE
       SIZE 100 BY 13.

/* Frame definition: */

DEFINE FRAME f1
       b1 AT ROW 1 COL 1 HELP 'Browse'
       Btn_Export AT ROW 14.3 COL 82 HELP 'Export rows as semicolon separated values'
       Btn_Done AT ROW 14.3 COL 92 HELP 'Close window'
       WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
            SIDE-LABELS NO-UNDERLINE THREE-D
            AT COL 1 ROW 1
            SIZE 120.43 BY 35.71 FONT 3.

ASSIGN  b1:COLUMN-RESIZABLE IN FRAME f1       = TRUE.

/* Control Triggers: */

ON 'START-SEARCH' OF b1 DO:
  IF b1:CURRENT-COLUMN:NAME = cSortColumn THEN bDesc = NOT bDesc.
  cSortColumn = b1:CURRENT-COLUMN:NAME.
  RUN Open-query2.
END.
ON 'CHOOSE' OF btn_Export DO:
  RUN ToExcelViaFile.p (b1:HANDLE,20000).
END.
ON END-ERROR OF hnd-win OR ENDKEY OF hnd-win ANYWHERE DO:
  RETURN NO-APPLY.
END.
ON WINDOW-CLOSE OF hnd-win DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
ON 'CHOOSE' OF Btn_Done IN FRAME f1 APPLY 'CLOSE' TO THIS-PROCEDURE.


/* Procedures: */

PROCEDURE Open-query:
DO WITH FRAME f1:
  bOK = SESSION:SET-WAIT-STATE('General').
  OPEN QUERY q1 FOR EACH norcalc.SPIRO_TABLE NO-LOCK.
  bOK = SESSION:SET-WAIT-STATE('').
END.

END PROCEDURE.

PROCEDURE Open-query2:
DEF VAR hQuery       AS HANDLE NO-UNDO.
DEF VAR cQueryString AS CHAR NO-UNDO.
bOk = SESSION:SET-WAIT-STATE('General').
DO WITH FRAME f1:
  hQuery       = b1:QUERY.
  cQueryString = 'FOR EACH norcalc.SPIRO_TABLE NO-LOCK BY ' + cSortColumn + IF bDesc THEN ' DESC.' ELSE '.'.
  hQuery:QUERY-PREPARE(cQueryString).
  hQuery:QUERY-OPEN.
END.

bOk = SESSION:SET-WAIT-STATE('').
END PROCEDURE.

PROCEDURE Export-data:
DO WITH FRAME f1:
  MESSAGE 'File name: ' UPDATE cExpFile.
  IF cExpFile NE '' THEN OUTPUT TO VALUE(cExpFile).
  ELSE RETURN.
  bOK = SESSION:SET-WAIT-STATE('General').
  FIND FIRST _file WHERE _file._file-name = 'SPIRO_TABLE' NO-LOCK NO-ERROR.
  IF AVAIL _file THEN DO:
    FOR EACH _field OF _file NO-LOCK BY _field._order:
      PUT UNFORMATTED IF _field._label NE '' AND _field._label NE ? THEN _field._label ELSE _field._field-name.
      PUT ";".
    END.
    PUT SKIP.
    FOR EACH _field OF _file NO-LOCK BY _field._order:
      PUT UNFORMATTED '(' + _field._field-name + ')'.
      PUT ";".
    END.
  END.
  bOK = SESSION:SET-WAIT-STATE('').
  PUT SKIP(1).
  FOR EACH norcalc.SPIRO_TABLE        NO-LOCK:
    EXPORT DELIMITER ";" SPIRO_TABLE.
  END.
  OUTPUT CLOSE.

  bOK = SESSION:SET-WAIT-STATE('').
END.

END PROCEDURE.

/* Main Block: */

ASSIGN CURRENT-WINDOW = hnd-win
       THIS-PROCEDURE:CURRENT-WINDOW = hnd-win.
ON 'CLOSE' OF THIS-PROCEDURE DO:
  DELETE WIDGET hnd-win.
  DELETE PROCEDURE THIS-PROCEDURE.
  DELETE PROCEDURE hResizeLib.
END.

ON 'WINDOW-RESIZED' OF CURRENT-WINDOW DO:
  bOk = DYNAMIC-FUNCTION('setWidgetResize' IN hResizeLib, CURRENT-WINDOW,CURRENT-WINDOW,'Resize','').
END.

ENABLE b1 WITH FRAME f1.
ENABLE Btn_Export Btn_Done WITH FRAME f1.
materialkvaliteter:READ-ONLY IN BROWSE b1 = TRUE.
RUN ResizeLib.p PERSISTE SET hResizeLib.
DYNAMIC-FUNCTION('setOrgWinSize' IN hResizeLib, THIS-PROCEDURE:CURRENT-WINDOW,300,150,500,250).
RUN Open-query.
