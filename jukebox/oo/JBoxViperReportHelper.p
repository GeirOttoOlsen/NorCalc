/* Helper for jboxdynlookup.cls */

{vpr.i INIT}
{vpr.i START}


PROCEDURE stopViper:
  DO WHILE vpr_GetPreviewStatus(1000) = "visible". END.
  {vpr.i STOP}
END PROCEDURE.

PROCEDURE getGroupObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM icGroupName  AS CHAR NO-UNDO.
DEF INPUT  PARAM icTypeList   AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocObjectList AS CHAR NO-UNDO.

RUN SUPER (icGroupName,icTypeList,OUTPUT ocObjectList).

END PROCEDURE.

PROCEDURE getViperWebPrinter :
/*------------------------------------------------------------------------------
  Purpose:     Fetch viper printer from viper.ini
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM ocViperPrinter AS CHAR NO-UNDO.

RUN SUPER (OUTPUT ocViperPrinter).

END PROCEDURE.

PROCEDURE getGroupList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM ocGroupList AS CHAR NO-UNDO.

RUN SUPER (OUTPUT ocGroupList).

END PROCEDURE.
