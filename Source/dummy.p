/*Dummy procedure - kan benytte innhold, men benytter private-data istedet :-)*/
DEF TEMP-TABLE ttObjAttr NO-UNDO
  FIELD cName AS CHAR
  FIELD cValue AS CHAR
  INDEX cName IS PRIMARY UNIQUE cName
  .
  
FUNCTION setObjAttr RETURNS LOGICAL (INPUT icName AS CHAR,
                                                                        INPUT icValue AS CHAR):
   FIND FIRST ttObjAttr EXCLUSIVE-LOCK  WHERE cName = icName NO-ERROR.
    IF NOT AVAIL ttObjAttr THEN 
      CREATE ttObjAttr.
    ttObjAttr.cName = icName.
END FUNCTION.

FUNCTION getObjAttr RETURNS CHARACTER (INPUT icName AS CHAR):
    FIND ttObjAttr WHERE ttObjAttr.cName = icName NO-LOCK NO-ERROR.
    RETURN IF NOT AVAIL ttObjAttr THEN 'N/A' ELSE ttObjattr.cName. 
  END FUNCTION.
