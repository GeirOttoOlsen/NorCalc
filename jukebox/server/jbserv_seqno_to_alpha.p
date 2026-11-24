DEF INPUT  PARAM iiSeqNo     AS INT NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

IF iiSeqNo < 0 OR iiSeqNo > 80 THEN RETURN.
ELSE IF iiSeqNo < 27 THEN
  ocValue = CHR(64 + iiSeqNo).
ELSE IF iiSeqNo < 53 THEN
  ocValue = "A" + CHR(64 - 26 + iiSeqNo).
ELSE IF iiSeqNo < 81 THEN
  ocValue = "B" + CHR(64 - 52 + iiSeqNo).




PROCEDURE cAlphaSeq:
  DEF INPUT  PARAM irJBoxFileImportSpec AS ROWID NO-UNDO.
  DEF INPUT  PARAM icParam AS CHAR NO-UNDO.
  DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
  DEF OUTPUT PARAM ocReturn AS CHAR NO-UNDO.

  ocReturn = "". /* Always string value. Use SKIPROW to exclude row from result set */
END PROCEDURE.