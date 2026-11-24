
/*------------------------------------------------------------------------
    File        : sessionstartup.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : ext_geol
    Created     : Fri Mar 28 08:25:50 CET 2025
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

def input param startup-data as char no-undo.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
session:year-offset = year(today) - 99.
log-manager:write-message('Denne må komme inn......','debug').
log-manager:write-message(subst('YEAR-OFFSET: &1',session:year-offset),'info').
