DELETE FROM jboxtranslation.
CURRENT-VALUE(seqjboxtranslationid) = 1000.
INPUT FROM c:\PROGRESS\jukebox\dbs\translation.dmp.
REPEAT :
  CREATE jboxtranslation.
  IMPORT DELIMITER ";" jboxtranslation.
END.
