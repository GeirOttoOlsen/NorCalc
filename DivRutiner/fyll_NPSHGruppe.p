DEF VAR hSender AS HANDLE NO-UNDO.
DEF VAR hMottak AS HANDLE NO-UNDO.
hSender = BUFFER xxxnpshfmgr:HANDLE.
hMottak = BUFFER npshGruppe:HANDLE.
FIND FIRST npshgruppetype WHERE npshgruppetypenavn = 'FM'.

FOR EACH xxxnpshfmgr NO-LOCK:
  DO TRANSACTION:
      hMottak:BUFFER-CREATE().
      ASSIGN hMottak::iNPSHGruppeTypeId = npshgruppetype.inpshgruppetypeid.
      hMottak:BUFFER-COPY(hSender).
  END.
  
END.
FIND FIRST npshgruppetype WHERE npshgruppetypenavn = 'MS'.
hSender = BUFFER xxxnpshMSgr:HANDLE.

FOR EACH xxxnpshMSgr NO-LOCK:
  DO TRANSACTION:
      hMottak:BUFFER-CREATE().
      ASSIGN hMottak::iNPSHGruppeTypeId = npshgruppetype.inpshgruppetypeid.
      hMottak:BUFFER-COPY(hSender).
  END.
  
END.


