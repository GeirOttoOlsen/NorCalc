/*------------------------------------------------------------------------
    File       : adm2/colprep.i
    Purpose    : This include file is used in query.i to convert AB generated
                 preprocessors to comma-separated lists of columns 
                 separated by chr(1) for each table.  
 Preprocessors : &num - number part of AB generated preprocessors
                        (FIRST, SECOND .. TENTH )  
                 &enabledvar   - Char variable that accumulates enabled-fields
                 &datavar      - Chart variable that accumalates data-fields 
                 &enabledcount - Int var that counts database enabled-fields
                 &datavar      - Int var that counts database data-fields 
                                               
   Created     : November 16, 1999
----------------------------------------------------------------------*/
&SCOP enFld '{&ENABLED-FIELDS-IN-{&{&num}-TABLE-IN-QUERY-{&QUERY-NAME}}}':U
&SCOP daFld '{&DATA-FIELDS-IN-{&{&num}-TABLE-IN-QUERY-{&QUERY-NAME}}}':U
 
    &IF '{&NUM}':U <> 'FIRST':U &THEN
&SCOP enAcc  {&enabledvar} + CHR(1) +
&SCOP daAcc  {&datavar} + CHR(1) +
   &ENDIF /* &num <> first */
                    
    &IF "{&{&num}-TABLE-IN-QUERY-{&QUERY-NAME}}":U NE "":U &THEN
ASSIGN 
 {&enabledcount} = {&enabledcount}  +  NUM-ENTRIES({&enFld}," ":U)  
 {&datacount}    = {&datacount}     +  NUM-ENTRIES({&daFld}," ":U)
 {&enabledvar}   = {&enAcc} REPLACE({&enFld}," ":U,",":U)
 {&datavar}      = {&daAcc} REPLACE({&daFld}," ":U,",":U).
    &ENDIF /* if {&num}-table-in-query-{&query-name <> '' } */
