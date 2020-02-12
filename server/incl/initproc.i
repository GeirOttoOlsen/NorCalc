/* Any custom initialization. Included in wintrigg.i */

IF SEARCH(LC("help\" + TRIM(THIS-PROCEDURE:FILE-NAME,".w")) + ".html") NE ? THEN
  DYNAMIC-FUNCTION("setWebHelpFile",THIS-PROCEDURE:CURRENT-WINDOW,
                   DYNAMIC-FUNCTION("getAttribute",SESSION,"defaulthelpdir") + LC(TRIM(THIS-PROCEDURE:FILE-NAME,".w")) + ".html").
