 
 /*------------------------------------------------------------------------
    File        : dbdesign
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo_000
    Created     : Fri Nov 22 09:24:19 CET 2019
    Notes       : 
      
      
      
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS server.oo.dbDesignHelper: 
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  define public property Tables as char no-undo get.  set.
  define public property ExcludeTables as char no-undo get. set.
  define public property SQLResult as char no-undo get. protected set.
  
  def var PrimaryIndexRecid as recid no-undo.
    
  CONSTRUCTOR PUBLIC dbDesignHelper (  ):
    
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC longchar addFields(input ipFileRecid as recid  ):
    def var tableFields as char no-undo.
    def var tableFieldDatatypes as char no-undo.
    def var Returnvalue as longchar no-undo.
    def var ii as int no-undo.

    for each _field no-lock where _field._file-recid = ipFileRecid by _field._order:
      tableFields = tableFields + _field._field-name + ','.
      tableFieldDataTypes = tableFieldDataTypes + _field._data-type + ','. 
    end.
    tableFields = right-trim(tableFields,',').
    tableFieldDataTypes = right-trim(tableFieldDataTypes,',').

    tableFieldDatatypes = replace(tableFieldDatatypes,'character','char').
    tableFieldDatatypes = replace(tableFieldDatatypes,'integer','integer').
    tableFieldDatatypes = replace(tableFieldDatatypes,'logical','boolean').
    tableFieldDatatypes = replace(tableFieldDatatypes,'int64','bigint').
    

    do ii = 1 to num-entries(tableFields):
      Returnvalue = ReturnValue + '~'' + entry(ii,tableFields) + '~' ' + entry(ii,tableFieldDataTypes) + (if isPrimaryIndexField(entry(ii,tableFields),PrimaryIndexRecid) then ' NOT NULL ' else '') + ',' + chr(10).
    end.
/*    ReturnValue = right-trim(ReturnValue,',' + chr(10)).*/
    return Returnvalue.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC logical isPrimaryIndexField(input ipField as char, input ipPrimaryIndexRecid as recid):
    FOR EACH _index WHERE recid(_index) = ipPrimaryIndexRecid:
      FOR EACH _index-field OF _index, FIRST _field OF _index-field NO-LOCK BY _index-seq:
        if _field._field-name = ipField then return true. 
      END.
    END.
    return false.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC longchar addPrimaryIndex(input ipPrimaryIndexRecid as recid):
    def var PrimaryIndexFields as char no-undo.   
    def var Returnvalue as longchar no-undo.
    PrimaryIndexFields = ''.   
    FOR EACH _index WHERE recid(_index) = ipPrimaryIndexRecid:
/*      ReturnValue = '~'' + _index._index-name + '~'' + ' PRIMARY KEY ('.*/
      ReturnValue = ' PRIMARY KEY ('.
      PrimaryIndexFields = ''.  
      FOR EACH _index-field OF _index, FIRST _field OF _index-field NO-LOCK BY _index-seq:
         PrimaryIndexFields = PrimaryIndexFields + '~'' + _field._field-name + '~'' + ','.
      END.
      PrimaryIndexFields = RIGHT-TRIM (PrimaryIndexFields,',').

      ReturnValue = Returnvalue + PrimaryIndexFields + ')' + chr(13) + chr(10).
    END.
    return Returnvalue.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC longchar addTables(  ):
    def var Returnvalue as longchar no-undo.

    for each _file no-lock where _file-num lt 320000 and not _file-name begins '_':
      if tables ne '' then do:
        if not can-do(tables,_file-name) then next.
      end.
      if ExcludeTables ne '' then do:
        if can-do(ExcludeTables,_file-name) then next.
      end.
      PrimaryIndexRecid = _file._prime-index.
      Returnvalue = ReturnValue + (if ReturnValue <> '' then chr(13) + chr(10) else '') + 'CREATE TABLE ' + '~'' + _File-name + '~'' + ' (' + chr(13) + chr(10).
      Returnvalue = Returnvalue + addFields(recid(_file)).
      Returnvalue = Returnvalue + addPrimaryIndex(_file._prime-index).
      Returnvalue = Returnvalue + ');'.
    end.
    return Returnvalue.

  END METHOD.

  DESTRUCTOR PUBLIC dbDesignHelper ( ):

  END DESTRUCTOR.

END CLASS.