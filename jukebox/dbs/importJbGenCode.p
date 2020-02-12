DELETE FROM jboxgencodetype.
DELETE FROM jboxgencode.
CURRENT-VALUE(seqJBoxGenCodeId) = 1000.
CURRENT-VALUE(seqJBoxGenCodeTypeId) = 1000.

INPUT FROM c:\PROGRESS\jukebox\dbs\JBoxGenCodeType.dmp.
REPEAT:
  CREATE JBoxGenCodeType.
  IMPORT DELIMITER "|" JBoxGenCodeType.
END.
INPUT CLOSE.
INPUT FROM c:\PROGRESS\jukebox\dbs\JBoxGenCode.dmp.
REPEAT:
  CREATE JBoxGenCode.
  IMPORT DELIMITER "|" JBoxGenCode.
END.
INPUT CLOSE. 
