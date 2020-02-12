/* Variable definitions: */

DEF VAR hnd-win      AS WIDGET-HANDLE NO-UNDO.
DEF VAR bOK          AS LOGICAL NO-UNDO.
DEF VAR cExpFile     AS CHAR FORMAT 'X(40)' NO-UNDO INIT 'c:\temp\norcalc-NPKUNDE.csv'.

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
              TITLE              = 'Contents of norcalc.NPKUNDE (Kunder for Norkalk)'.

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
       LABEL 'kundenavn'
       VIEW-AS FILL-IN
       SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-search2 AS CHARACTER FORMAT 'X(256)':U
       LABEL 'kundenr'
       VIEW-AS FILL-IN
       SIZE 10 BY .88 NO-UNDO.

/* Query and Browse definition: */

DEFINE QUERY q1 FOR norcalc.NPKUNDE.

DEFINE BROWSE b1 QUERY q1
  DISPLAY
      norcalc.NPKUNDE.kundenr COLUMN-LABEL "Kundenr!kundenr"
      norcalc.NPKUNDE.kundenr_sp COLUMN-LABEL "Knr. spektra!kundenr_sp"
      norcalc.NPKUNDE.kundenr_de COLUMN-LABEL "Knr. d.ease!kundenr_de"
      norcalc.NPKUNDE.kundenavn COLUMN-LABEL "Kundenavn!kundenavn"
      norcalc.NPKUNDE.avdeling COLUMN-LABEL "Avd.!avdeling"
      norcalc.NPKUNDE.adresse1 COLUMN-LABEL "Adresse 1!adresse1"
      norcalc.NPKUNDE.adresse2 COLUMN-LABEL "Adresse 2!adresse2"
      norcalc.NPKUNDE.postnr COLUMN-LABEL "Postnr.!postnr"
      norcalc.NPKUNDE.poststed COLUMN-LABEL "Poststed!poststed"
      norcalc.NPKUNDE.land COLUMN-LABEL "Land!land"
      norcalc.NPKUNDE.telefon COLUMN-LABEL "Telefon!telefon"
      norcalc.NPKUNDE.fax COLUMN-LABEL "Fax!fax"
      norcalc.NPKUNDE.mobil COLUMN-LABEL "Mobil!mobil"
      norcalc.NPKUNDE.kontaktperson_np COLUMN-LABEL "Kontaktperson - NP!kontaktperson_np"
      norcalc.NPKUNDE.kontaktperson_nt COLUMN-LABEL "Kontaktperson - NT!kontaktperson_nt"
      norcalc.NPKUNDE.rabatt%_1 COLUMN-LABEL "Rabatt 1!rabatt%_1"
      norcalc.NPKUNDE.rabatt%_2 COLUMN-LABEL "Rabatt 2!rabatt%_2"
      norcalc.NPKUNDE.kundekategori COLUMN-LABEL "Kategori!kundekategori"
      norcalc.NPKUNDE.kundedistrikt COLUMN-LABEL "Distrikt!kundedistrikt"
      norcalc.NPKUNDE.fylke COLUMN-LABEL "Fylke!fylke"
      norcalc.NPKUNDE.katalog_np_dato COLUMN-LABEL "Katalog NP!katalog_np_dato"
      norcalc.NPKUNDE.katalog_np_antall COLUMN-LABEL "antall!katalog_np_antall"
      norcalc.NPKUNDE.katalog_np_type COLUMN-LABEL "type!katalog_np_type"
      norcalc.NPKUNDE.katalog_np_oppdatert COLUMN-LABEL "oppdatert!katalog_np_oppdatert"
      norcalc.NPKUNDE.katalog_nt_dato COLUMN-LABEL "Katalog NP!katalog_nt_dato"
      norcalc.NPKUNDE.katalog_nt_antall COLUMN-LABEL "antall!katalog_nt_antall"
      norcalc.NPKUNDE.katalog_nt_type COLUMN-LABEL "type!katalog_nt_type"
      norcalc.NPKUNDE.katalog_nt_oppdatert COLUMN-LABEL "oppdatert!katalog_nt_oppdatert"
      norcalc.NPKUNDE.organisasjon COLUMN-LABEL "Organisasjon!organisasjon" FORMAT 'x(70)'
      norcalc.NPKUNDE.aktiv COLUMN-LABEL "Aktiv!aktiv"
      norcalc.NPKUNDE.kilde COLUMN-LABEL "Kilde!kilde"
      norcalc.NPKUNDE.sist_oppdatert COLUMN-LABEL "Sist oppd.!sist_oppdatert"
      norcalc.NPKUNDE.tilbudsmottager COLUMN-LABEL "Tilbud!tilbudsmottager"
      norcalc.NPKUNDE.er_konsulent COLUMN-LABEL "Konsulent!er_konsulent"
      norcalc.NPKUNDE.konsulentnr COLUMN-LABEL "!konsulentnr"
      norcalc.NPKUNDE.dm_kode COLUMN-LABEL "DM kode!dm_kode"
      norcalc.NPKUNDE.avtale COLUMN-LABEL "Avtale!avtale"
      norcalc.NPKUNDE.kontor_type COLUMN-LABEL "Kontortype!kontor_type"
  ENABLE ALL
  WITH NO-ROW-MARKERS SEPARATORS SCROLLABLE
       SIZE 100 BY 13.

/* Frame definition: */

DEFINE FRAME f1
       b1 AT ROW 1 COL 1 HELP 'Browse'
       fi-search1  AT ROW 14.3 COL 5 LABEL 'Kundenavn' HELP 'Search for '
       Btn_Search  AT ROW 14.3 COL 72 HELP 'Search'
       fi-search2  AT ROW 14.3 COL 30  LABEL 'Kundenr' HELP 'Search for '
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
    OPEN QUERY q1 FOR EACH norcalc.NPKUNDE WHERE
         kundenavn BEGINS fi-search1 
         AND IF fi-search2:SCREEN-VALUE NE '' THEN kundenr BEGINS fi-search2 ELSE TRUE.
  END.
  ELSE IF fi-search2 NE ? AND fi-search2:SCREEN-VALUE NE '' THEN DO: 
    OPEN QUERY q1 FOR EACH norcalc.NPKUNDE WHERE
         kundenr BEGINS fi-search2.
  END.
  ELSE  OPEN QUERY q1 FOR EACH norcalc.NPKUNDE.
  bOK = SESSION:SET-WAIT-STATE('').
END.

END PROCEDURE.

PROCEDURE Open-query2:
DEF VAR hQuery       AS HANDLE NO-UNDO.
DEF VAR cQueryString AS CHAR NO-UNDO.
bOk = SESSION:SET-WAIT-STATE('General').
DO WITH FRAME f1:
  hQuery       = b1:QUERY.
  cQueryString = 'FOR EACH norcalc.NPKUNDE NO-LOCK BY ' + cSortColumn + IF bDesc THEN ' DESC.' ELSE '.'.
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
  FIND FIRST _file WHERE _file._file-name = 'NPKUNDE' NO-LOCK NO-ERROR.
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
    FOR EACH norcalc.NPKUNDE WHERE
        kundenavn BEGINS fi-search1 
        AND IF fi-search2:SCREEN-VALUE NE '' THEN kundenr BEGINS fi-search2 ELSE TRUE        NO-LOCK:
      EXPORT DELIMITER ";" NPKUNDE.
    END.
  END.
  ELSE IF fi-search2:SCREEN-VALUE NE '' THEN DO: 
     FOR EACH norcalc.NPKUNDE WHERE
         kundenr BEGINS fi-search2        NO-LOCK:
      EXPORT DELIMITER ";" NPKUNDE.
    END.
  END.
  ELSE  FOR EACH norcalc.NPKUNDE        NO-LOCK:
      EXPORT DELIMITER ";" NPKUNDE.
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
RUN ResizeLib.p PERSISTE SET hResizeLib.
DYNAMIC-FUNCTION('setOrgWinSize' IN hResizeLib, THIS-PROCEDURE:CURRENT-WINDOW,300,150,500,250).
RUN Open-query.
