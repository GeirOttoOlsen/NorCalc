/* 15-SEP-2013 jcc: read an afm file and build a width string for use in pdf_inc.p */
DEFINE VARIABLE cLine   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cWidths AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i       AS INTEGER     NO-UNDO.
DEFINE TEMP-TABLE ttWidths NO-UNDO LABEL "font widths"
 FIELD iCode  AS INTEGER
 FIELD iWidth AS INTEGER
 .

INPUT FROM VALUE("C:\User\JCCARDOT\Perso\Travail\pdfinc\PDFinclude4.0\pdfinclude\fonts\Helvetica-Bold.afm") BINARY NO-MAP NO-CONVERT.
REPEAT:
    IMPORT UNFORMATTED cLine.
    IF ENTRY(1, cLine, " ") <> "C" THEN NEXT.
    CREATE ttWidths.
    ASSIGN
        ttWidths.iCode  = INTEGER(ENTRY(2, cLine, " "))
        ttWidths.iWidth = INTEGER(ENTRY(5, cLine, " ")).
END.
INPUT CLOSE.

DO i = 1 TO 255:
    FIND ttWidths WHERE ttWidths.iCode = i NO-ERROR.
    IF NOT AVAILABLE ttWidths THEN
        cWidths = cWidths + " 788".
    ELSE
        cWidths = cWidths + " " + STRING(ttWidths.iWidth).
END.
MESSAGE SUBSTRING(cWidths, 2)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
