/* Helper proc that subscribes to procedures so that objects within the viewer may be accessible to the container
   Created: 26.aug.2015 by brynjar@chemistry.no
*****************************************************************************************************/   

DEF INPUT PARAM ioContainer AS JBoxContainer NO-UNDO.

DEF VAR hWrapperProc AS HANDLE NO-UNDO.
DEF VAR oWrapperForm AS JBoxWrapperForm NO-UNDO.

/*SUBSCRIBE TO "setContainerForMsTabObject" ANYWHERE. /* published from JBoxMsTabs class */*/
SUBSCRIBE TO "getContainerForProc" ANYWHERE. /* published from JBoxMsTabs class */

PUBLISH "IsWindowWrapped" (ioContainer:myCURRENT-WINDOW,OUTPUT hWrapperProc).
IF VALID-HANDLE(hWrapperProc) THEN DO:
  RUN getFormObject IN hWrapperProc (OUTPUT oWrapperForm).
  IF VALID-OBJECT(oWrapperForm) THEN
    ioContainer:WrapperForm = oWrapperForm.
END.

/*
PROCEDURE setContainerForMsTabObject:
/*------------------------------------------------------------------------------
 Purpose: receive message from browse in tab-program to be assigned to the tab folder class 
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihContainerSourceProc AS HANDLE NO-UNDO.
DEF INPUT PARAM ioMsTabObject         AS JBoxMsTabs NO-UNDO.

IF ihContainerSourceProc = ioContainer:CONTAINER-HANDLE THEN
  ioMsTabObject:CONTAINER-OBJECT = ioContainer.
END PROCEDURE.
*/
PROCEDURE getContainerForProc:
/*------------------------------------------------------------------------------
 Purpose: receive message from browse in tab-program to be assigned to the tab folder class 
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihContainerSourceProc AS HANDLE NO-UNDO.
DEF INPUT PARAM ihCallBackTarget      AS HANDLE NO-UNDO.
DEF INPUT PARAM icCallBackFunction    AS CHAR   NO-UNDO.

IF ihContainerSourceProc = ioContainer:CONTAINER-HANDLE THEN
  DYNAMIC-FUNCTION(icCallBackFunction IN ihCallBackTarget,ioContainer) NO-ERROR.
END PROCEDURE.

SUBSCRIBE TO "setContainerBrowseObject" ANYWHERE. /* published from browse class */
SUBSCRIBE TO "setContainerQueryObject" ANYWHERE. /* published from query class */
SUBSCRIBE TO "setContainerToolbarObject" ANYWHERE. /* published from toolbar class */
SUBSCRIBE TO "setContainerFieldMapObject" ANYWHERE. /* published from fieldMap class */

PROCEDURE setContainerBrowseObject:
/*------------------------------------------------------------------------------
 Purpose: receive message from browse in tab-program to be assigned to the tab folder class 
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihSourceProc AS HANDLE NO-UNDO.
DEF INPUT PARAM ioBrowseObject  AS JBoxBrowse NO-UNDO.

IF ioContainer:CONTAINER-HANDLE = ihSourceProc AND NOT VALID-OBJECT(ioContainer:BROWSE-OBJECT) THEN
  ioContainer:BROWSE-OBJECT = ioBrowseObject.

END PROCEDURE.

  
PROCEDURE setContainerQueryObject:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihSourceProc AS HANDLE NO-UNDO.
DEF INPUT PARAM ioQueryObject   AS JBoxQuery NO-UNDO.

IF ioContainer:CONTAINER-HANDLE = ihSourceProc AND NOT VALID-OBJECT(ioContainer:QUERY-OBJECT) THEN
  ioContainer:QUERY-OBJECT = ioQueryObject.

END PROCEDURE.

PROCEDURE setContainerToolbarObject:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihSourceProc AS HANDLE NO-UNDO.
DEF INPUT PARAM ioToolbarObject AS JBoxToolbar NO-UNDO.

IF ioContainer:CONTAINER-HANDLE = ihSourceProc AND NOT VALID-OBJECT(ioContainer:TOOLBAR-OBJECT) THEN
  ioContainer:TOOLBAR-OBJECT = ioToolbarObject.


END PROCEDURE.

PROCEDURE setContainerFieldMapObject:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihSourceProc AS HANDLE NO-UNDO.
DEF INPUT PARAM ioFieldMapObject AS JBoxFieldMap NO-UNDO.

IF ioContainer:CONTAINER-HANDLE = ihSourceProc AND NOT VALID-OBJECT(ioContainer:FIELDMAP-OBJECT) THEN
  ioContainer:FIELDMAP-OBJECT = ioFieldMapObject.


END PROCEDURE.
