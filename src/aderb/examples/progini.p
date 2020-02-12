/*********************************************************************
File:           progini.p
Description:    Access initialization/status file. 
                This is for testing the Report Builder utility _getini.p

Parameters:     Input parameters for _getini.p

                input parameter section 
                input parameter entry-name  
                input parameter def-value  
                output parameter result  
                input parameter path-name  
                output parameter success 
**********************************************************************/
DEF VAR result AS CHARACTER FORMAT "x(70)".
DEF VAR success AS LOGICAL.

RUN aderb\_getini.p ("Customer Report", "RO-ERROR-CODE", "", OUTPUT result,
"c:\examples\rbrun.out", OUTPUT success).

IF success THEN
DO:
 DISPLAY result.
 PAUSE.
END.
ELSE
 MESSAGE "It failed" VIEW-AS ALERT-BOX ERROR.
