/* Shared JukeBox wiring for a browse with detail fields and one toolbar. */
CLASS NorcalcBrowseWindow:

  METHOD PUBLIC STATIC VOID ConnectToolbar(
    INPUT ihOwner AS HANDLE,
    INPUT ihToolbar AS HANDLE,
    INPUT ioBrowse AS JBoxBrowse,
    INPUT ioFieldMap AS JBoxFieldMap):

    DEFINE VARIABLE oToolbar AS JBoxToolbar NO-UNDO.

    ASSIGN
      oToolbar = NEW JBoxToolbar(ihToolbar, ihOwner)
      ioBrowse:TOOLBAR-OBJECT = oToolbar
      ioFieldMap:TOOLBAR-OBJECT = oToolbar.
  END METHOD.

END CLASS.
