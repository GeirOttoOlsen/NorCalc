/* Variable definitions: */

DEF VAR hnd-win      AS WIDGET-HANDLE NO-UNDO.
DEF VAR bOK          AS LOGICAL NO-UNDO.
DEF VAR cExpFile     AS CHAR FORMAT 'X(40)' NO-UNDO INIT 'c:\temp\norcalc-Prosjekt.csv'.

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
              TITLE              = 'Contents of norcalc.Prosjekt (Prosjekt)'.

bOK = hnd-win:LOAD-ICON('adeicon/dict%.ico').
ASSIGN CURRENT-WINDOW = hnd-win.

/* Widget definitions: */

DEFINE BUTTON Btn_Done
       LABEL '&Close'
       SIZE 9 BY 1.17
       BGCOLOR 8.

DEFINE BUTTON Btn_Search DEFAULT
       LABEL '&Search'
       SIZE 9 BY 1.17
       BGCOLOR 8.

DEFINE BUTTON Btn_Export
       LABEL '&Export'
       SIZE 9 BY 1.17
       BGCOLOR 8.

DEFINE VARIABLE fi-search1 AS CHARACTER FORMAT 'X(256)':U
       LABEL 'cProsjektNr'
       VIEW-AS FILL-IN
       SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-search2 AS CHARACTER FORMAT 'X(256)':U
       LABEL 'cVarenr'
       VIEW-AS FILL-IN
       SIZE 10 BY .88 NO-UNDO.

/* Query and Browse definition: */

DEFINE QUERY q1 FOR norcalc.Prosjekt.

DEFINE BROWSE b1 QUERY q1
  DISPLAY
      norcalc.Prosjekt.iProsjektId COLUMN-LABEL "Prosjekt id!iProsjektId"
      norcalc.Prosjekt.cProsjektNr COLUMN-LABEL "Prosjektnr!cProsjektNr"
      norcalc.Prosjekt.cProsjektNavn COLUMN-LABEL "Prosjektnavn!cProsjektNavn"
      norcalc.Prosjekt.cFakturatekst COLUMN-LABEL "Fakturatekst!cFakturatekst"
      norcalc.Prosjekt.iJBoxCompanyId COLUMN-LABEL "CompanyId!iJBoxCompanyId"
      norcalc.Prosjekt.cVarenr COLUMN-LABEL "Varenr!cVarenr"
      norcalc.Prosjekt.iVareId COLUMN-LABEL "VareId!iVareId"
      norcalc.Prosjekt.iKontoNr COLUMN-LABEL "Kontonr!iKontoNr"
      norcalc.Prosjekt.cMerknad COLUMN-LABEL "Merknad!cMerknad"
      norcalc.Prosjekt.bActive COLUMN-LABEL "Aktiv!bActive"
      norcalc.Prosjekt.cURL COLUMN-LABEL "Webside!cURL" FORMAT 'x(70)'
      norcalc.Prosjekt.bEgenLevAdrOgFaktura COLUMN-LABEL "Egen lev.adr!bEgenLevAdrOgFaktura"
      norcalc.Prosjekt.cLevAdresse COLUMN-LABEL "Lev.adresse!cLevAdresse"
      norcalc.Prosjekt.cLevPnr COLUMN-LABEL "Lev.postnr!cLevPnr"
      norcalc.Prosjekt.cLevPoststed COLUMN-LABEL "Lev.poststed!cLevPoststed"
      norcalc.Prosjekt.cLevLand COLUMN-LABEL "Lev.land!cLevLand"
      norcalc.Prosjekt.cLevAttn COLUMN-LABEL "Attn!cLevAttn"
      norcalc.Prosjekt.bFasteTimepriser COLUMN-LABEL "Faste timepriser!bFasteTimepriser"
      norcalc.Prosjekt.bPaaslagForVarer COLUMN-LABEL "Påslag for varer!bPaaslagForVarer"
      norcalc.Prosjekt.bVarerabattTilProsjekt COLUMN-LABEL "Varerabatt!bVarerabattTilProsjekt"
      norcalc.Prosjekt.dCreated COLUMN-LABEL "Opprettet!dCreated"
      norcalc.Prosjekt.cCreatedBy COLUMN-LABEL "Av!cCreatedBy"
      norcalc.Prosjekt.dModified COLUMN-LABEL "Endret!dModified"
      norcalc.Prosjekt.cModifiedBy COLUMN-LABEL "Av!cModifiedBy"
  ENABLE cModifiedBy
  WITH NO-ROW-MARKERS SEPARATORS SCROLLABLE
       SIZE 100 BY 13.

/* Frame definition: */

DEFINE FRAME f1
       b1 AT ROW 1 COL 1 HELP 'Browse'
       fi-search1  AT ROW 14.3 COL 5 LABEL 'Prosjektnr' HELP 'Search for '
       Btn_Search  AT ROW 14.3 COL 72 HELP 'Search'
       fi-search2  AT ROW 14.3 COL 30  LABEL 'Varenr' HELP 'Search for '
       Btn_Export AT ROW 14.3 COL 82 HELP 'Export rows as semicolon separated values'
       Btn_Done AT ROW 14.3 COL 92 HELP 'Close window'
       WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
            SIDE-LABELS NO-UNDERLINE THREE-D
            AT COL 1 ROW 1
            DEFAULT-BUTTON btn_search
            SIZE 120.43 BY 35.71 FONT 3.

ASSIGN  b1:COLUMN-RESIZABLE IN FRAME f1       = TRUE.

/* Control Triggers: */

ON 'START-SEARCH' OF b1 DO:
  IF b1:CURRENT-COLUMN:NAME = cSortColumn THEN bDesc = NOT bDesc.
  cSortColumn = b1:CURRENT-COLUMN:NAME.
  RUN Open-query2.
END.
ON 'CHOOSE' OF btn_search DO:
  ASSIGN fi-search1.
  ASSIGN fi-search2.
  RUN Open-query.
END.
ON 'CHOOSE' OF btn_Export DO:
  ASSIGN fi-search1.
  ASSIGN fi-search2.
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
  ASSIGN fi-search1 fi-search2.
  IF fi-search1 NE ? AND fi-search1:SCREEN-VALUE NE '' THEN DO:
    OPEN QUERY q1 FOR EACH norcalc.Prosjekt WHERE
         cProsjektNr BEGINS fi-search1 
         AND IF fi-search2:SCREEN-VALUE NE '' THEN cVarenr BEGINS fi-search2 ELSE TRUE NO-LOCK.
  END.
  ELSE IF fi-search2 NE ? AND fi-search2:SCREEN-VALUE NE '' THEN DO: 
    OPEN QUERY q1 FOR EACH norcalc.Prosjekt WHERE
         cVarenr BEGINS fi-search2 NO-LOCK.
  END.
  ELSE  OPEN QUERY q1 FOR EACH norcalc.Prosjekt NO-LOCK.
  bOK = SESSION:SET-WAIT-STATE('').
END.

END PROCEDURE.

PROCEDURE Open-query2:
DEF VAR hQuery       AS HANDLE NO-UNDO.
DEF VAR cQueryString AS CHAR NO-UNDO.
bOk = SESSION:SET-WAIT-STATE('General').
DO WITH FRAME f1:
  hQuery       = b1:QUERY.
  cQueryString = 'FOR EACH norcalc.Prosjekt NO-LOCK BY ' + cSortColumn + IF bDesc THEN ' DESC.' ELSE '.'.
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
  FIND FIRST _file WHERE _file._file-name = 'Prosjekt' NO-LOCK NO-ERROR.
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
  IF fi-search1:SCREEN-VALUE NE '' THEN DO:
    FOR EACH norcalc.Prosjekt WHERE
        cProsjektNr BEGINS fi-search1 
        AND IF fi-search2:SCREEN-VALUE NE '' THEN cVarenr BEGINS fi-search2 ELSE TRUE        NO-LOCK:
      EXPORT DELIMITER ";" Prosjekt.
    END.
  END.
  ELSE IF fi-search2:SCREEN-VALUE NE '' THEN DO: 
     FOR EACH norcalc.Prosjekt WHERE
         cVarenr BEGINS fi-search2        NO-LOCK:
      EXPORT DELIMITER ";" Prosjekt.
    END.
  END.
  ELSE  FOR EACH norcalc.Prosjekt        NO-LOCK:
      EXPORT DELIMITER ";" Prosjekt.
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
ENABLE fi-search1 WITH FRAME f1.
ENABLE fi-search2 WITH FRAME f1.
ENABLE Btn_Search WITH FRAME f1.
ENABLE Btn_Export Btn_Done WITH FRAME f1.
cModifiedBy:READ-ONLY IN BROWSE b1 = TRUE.
RUN ResizeLib.p PERSISTE SET hResizeLib.
DYNAMIC-FUNCTION('setOrgWinSize' IN hResizeLib, THIS-PROCEDURE:CURRENT-WINDOW,300,150,500,250).
RUN Open-query.
