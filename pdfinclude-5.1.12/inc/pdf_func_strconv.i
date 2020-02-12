/******************************************************************************

  Program:      pdf_func_strconv.i
  
  Written By:   Jean-Christophe Cardot
  Written On:   March 2015
  
  Description:  string2dec and dec2string functions
  
  03/17/15  JC Cardot   Created

******************************************************************************/
&IF DEFINED(pdf_func_strconv-included) = 0 &THEN
&GLOBAL-DEFINE pdf_func_strconv-included YES

FUNCTION dec2string RETURNS CHARACTER (INPUT decvalue AS DECIMAL): /* PRIVATE */
  IF SESSION:NUMERIC-FORMAT = "EUROPEAN" THEN
    RETURN REPLACE(STRING(decvalue),",",".").
  ELSE
    RETURN STRING(decvalue).
END.  /* dec2string */

FUNCTION string2dec RETURNS DECIMAL (INPUT stringvalue AS CHARACTER): /* PRIVATE */
  IF SESSION:NUMERIC-FORMAT = "EUROPEAN" THEN
    RETURN DEC(REPLACE(stringvalue,".",",")).
  ELSE
    RETURN DEC(stringvalue).
END.  /* string2dec */

&ENDIF
