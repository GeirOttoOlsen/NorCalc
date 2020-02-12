/* Initialize JukeBox dev.environment */

DEF VAR cPropath     AS CHAR NO-UNDO.
DEF VAR cJukeBoxRoot AS CHAR NO-UNDO.

/* Load libraries and set the propath: */  
RUN winsrc\JBoxLoadLib.p ("ResizeLib.p,JBoxASlib.p,JBoxUIlib.p"
                       + (IF PROVERSION BEGINS "1" THEN ",JBoxFUlib.p" ELSE "")).

cJukeBoxRoot = SEARCH("jboxuilib.p").
    
IF cJukeBoxRoot NE ? THEN DO:
  
  cjukeboxroot = SUBSTR(cjukeboxroot,1,INDEX(cjukeboxroot,"\lib\")).

  cPropath = SUBSTR(PROPATH,1,INDEX(PROPATH,"jukebox\tools") + 13) + 
             cJukeBoxRoot + "server\samples," +
             cJukeBoxRoot + "winsrc\samples," +
             SUBSTR(PROPATH,INDEX(PROPATH,"jukebox\tools") + 14).
  PROPATH = cPropath.
END.
