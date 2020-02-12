 
 /*------------------------------------------------------------------------
    File        : JBoxSetFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo_000
    Created     : Mon Jun 19 11:40:35 CEST 2017
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxSetFilter: 
  def public PROPERTY FrameHandle   as handle no-undo get. set.
  def public property FieldList     as char no-undo get. set.
  def public property Filter        as char no-undo get. set.  
  def public property WhereOperator as char no-undo get. set.  
  	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
		
	CONSTRUCTOR PUBLIC JBoxSetFilter (ipFrameHandle as handle):
		SUPER ().
	  assign 
	    FrameHandle = ipFrameHandle
	    WhereOperator    = ' AND '
	    .	
		CATCH e AS Progress.Lang.Error:

		END CATCH.

	END CONSTRUCTOR.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/

	METHOD PUBLIC VOID BuildFilter(icFieldName as char, icOperator as char):
    DEF VAR cReturn AS CHAR NO-UNDO.
    def var hField as handle no-undo.
    def var FieldName as char no-undo.

    FieldName = replace(icFieldName,'filter_','').
    
    cReturn = ''.
      hField = getFieldHandle(icFieldName).
    IF hField:INPUT-VALUE = '' OR hField:INPUT-VALUE = ? THEN
      return.
    if not hField:modified then return.
    
     CASE icOperator:
       WHEN 'BEGINS' OR WHEN 'MATCHES' THEN
       DO:
         ASSIGN 
           cReturn = (IF INDEX(hField:INPUT-VALUE,'*') GT 0 THEN
                        (FieldName + ' MATCHES ' + QUOTER(hField:INPUT-VALUE + '*'))
                      ELSE 
                        (FieldName + ' BEGINS ' + QUOTER(hField:INPUT-VALUE))).
       END.
       WHEN 'CONTAINS' THEN
       DO:
         ASSIGN 
           cReturn = (FieldName + ' CONTAINS ' + QUOTER(hField:INPUT-VALUE)).
       END.
  
       WHEN '=' OR WHEN 'EQ' OR WHEN '<' OR WHEN 'LT' OR WHEN '<=' 
                OR WHEN 'LE' OR WHEN '>' OR WHEN 'GT' OR WHEN '>=' 
                OR WHEN 'GE' OR WHEN '<>' OR WHEN 'NE' THEN
       DO:
         /*INTEGER = 0 blir ikke tatt med*/
         IF CAN-DO('INTEGER,DECIMAL',hField:DATA-TYPE) AND hField:INPUT-VALUE = 0 THEN
           RETURN.
         ASSIGN 
           cReturn = IF CAN-DO('CHAR,CHARACTER',hField:DATA-TYPE) AND INDEX(hField:FORMAT,'9') LE 0 THEN
                       (FieldName + ' ' + icOperator + ' ' + QUOTER(hField:INPUT-VALUE))
                     ELSE IF CAN-DO('DATE',hField:DATA-TYPE) THEN
                       (FieldName + ' ' + icOperator + ' DATE(' + QUOTER(hField:INPUT-VALUE) + ')')
                     ELSE IF CAN-DO('DATETIME',hField:DATA-TYPE) THEN
                       (FieldName + ' ' + icOperator + ' DATETIME(' + QUOTER(hField:INPUT-VALUE) + ')')
                     ELSE
                       (FieldName + ' ' + icOperator + ' ' + hField:INPUT-VALUE).
  
       END.          
     END CASE.
/*     Filter = if Filter gt '' then Filter + ' ' + WhereOperator + ' ' + cReturn else cReturn.*/ /*Kan ikke benytte AND/OR operator mellom uttrykkene (begrensning i JBoxxxx:setFilter(uttryk)*/
     Filter = if Filter gt '' then Filter + '|' + cReturn else cReturn.
    return.
	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/

	METHOD PUBLIC handle getFieldHandle(input icFieldName as char):
		def var hObj as handle no-undo.
		hObj = FrameHandle:First-child:first-child.
		DO while valid-handle(hObj):
      if hObj:name = icFieldName then return hObj.
      hObj = hObj:next-sibling.      
    END.
		RETURN ?.

	END METHOD.

  METHOD PUBLIC char setFilterBlank():
    def var hObj as handle no-undo.
    hObj = FrameHandle:First-child:first-child.
    DO while valid-handle(hObj):
      if hObj:name begins 'filter' then 
      do:        
        case hObj:data-type:
          when 'INTEGER' or when 'INT64' then hObj:screen-value = '0'.
          when 'DECIMAL' then hObj:screen-value = '0.00'.
          when 'CHARACTER' then hObj:screen-value = ''.
          when 'DATE' then hObj:screen-value = ?.                    
        end case.        
      end.
      hObj = hObj:next-sibling.      
    END.
    RETURN ?.

  END METHOD.

END CLASS.