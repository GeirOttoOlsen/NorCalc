/*********************************************************************
File:           reptlist.p  
Description:    Generate a list of reports from a .prl.
                This is for testing the Report Builder utility _getname.p
                The file rbsample.prl must be in the working directory. 
**********************************************************************/
DEF VAR report-list AS CHARACTER.
DEF VAR report-count AS CHARACTER.
DEF VAR report AS CHARACTER VIEW-AS SELECTION-LIST INNER-LINES 10 INNER-CHARS 32.

FORM  "There were " report-count " Reports: please select one.:" skip
report with frame x no-labels.

run aderb/_getname.p ("rbsample.prl", OUTPUT report-list, OUTPUT report-count).

report = ?.
report:list-items = report-list.
display report-count with frame x.
update report with frame x. 
