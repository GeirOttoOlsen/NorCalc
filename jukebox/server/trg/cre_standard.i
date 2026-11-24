TRIGGER PROCEDURE FOR CREATE OF {1}.
  DEF BUFFER b_cre{1} FOR {1}.
  {1}.i{1}Id = NEXT-VALUE(seq{1}Id) NO-ERROR.
  IF ERROR-STATUS:ERROR AND ERROR-STATUS:GET-NUMBER (1) = 132 THEN DO:
    FOR EACH b_cre{1} BY b_cre{1}.i{1}id DESC:
      CURRENT-VALUE(seq{1}Id) = b_cre{1}.i{1}id.
      LEAVE.
    END.
    {1}.i{1}Id = NEXT-VALUE(seq{1}Id).
  END.
