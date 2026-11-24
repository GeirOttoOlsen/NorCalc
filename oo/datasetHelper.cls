 /*------------------------------------------------------------------------
    File        : datasetHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo
    Created     : Sat Feb 03 09:59:45 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.DataAdmin.Message.TableRequest FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.datasetHelper: 
  def temp-table dsTable no-undo
    field dsTableSeq as int
    field dsTablename as char
    field dsDBname as char
    index dsTablename is primary unique dsTablename
    .
  def temp-table ReplaceCharacter no-undo
    field charValue as char
    field replaceWithChar as char
    .
  def temp-table TableRelation no-undo
    field TableRelationSeq as int
    field TableRelationParentId as int
    field TableRelationChildId as int
    field TableRelationFields as char
    .
  def public property dsh as handle no-undo get. protected set.
  def protected property TableSeq as int no-undo get. protected set.
  def protected property TableRelationSeq as int no-undo get. protected set.
  def public property StatusMessage as char no-undo get. protected set.
  def public property NumRelations as int no-undo 
    get():
      def var ii as int no-undo.
      for each TableRelation: ii = ii + 1. end.
      return ii.
    end get. protected set.

  def public property optionTargetType as char no-undo get. set.
  def public property optionFormatted as log no-undo get. set. 
  def public property optionEncoding as char no-undo get. set.
  def public property optionSchemaLocation as char no-undo get. set.
  def public property optionWriteSchema as log no-undo get. set.
  def public property optionMinSchema as log no-undo get. set.
  def public property optionWriteBefore as log no-undo get. set.
  def public property optionOmitInitials as log no-undo get. set.
  
  def public property repositionMode as log no-undo get. set.
  def public property isNested as log no-undo get. set.
  def public property notActive as log no-undo get. set.
  def public property isRecursive as log no-undo get. set.
  def public property foreignKeyHidden as log no-undo get. set.
  
  
   
  {tt_schema.i}
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC datasetHelper (  ):
    assign 
      hdsSchema        = DATASET dsSchema:HANDLE
      optionTargetType = 'file'
      optionFormatted  = true
      optionEncoding   = if session:CHARSET begins 'ISO8859' then replace(session:charset,'ISO88','ISO-88') else session:charset
      optionSchemaLocation = ?
      optionWriteBefore    = ?
      optionMinSchema      = ?
      optionWriteBefore    = ?
      optionOmitInitials   = ?
      repositionMode   = false
      isNested         = true
      notActive        = true
      isRecursive      = false
      foreignKeyHidden = true
      . 
    create ReplaceCharacter.
    assign 
      replaceCharacter.charValue       = '#'
      replaceCharacter.replaceWithChar = '_id'      
      .
    create ReplaceCharacter.
    assign 
      replaceCharacter.charValue       = '%'
      replaceCharacter.replaceWithChar = '_id'      
      .
    JBoxSchemaCache:Instance:getDbSchema(hdsSchema).
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC logical addTable(input ipDBname as char, input ipTableName as char):
    for first tt_file where tt_file.cFile-Name = ipTableName: leave. end.
    if not avail tt_file then 
      undo, throw new Progress.Lang.AppError(substitute('Fant ikke tabell med navn: &',ipTableName),0).
      
    find first dsTable where dsTable.dsDBname = ipDBname and dsTable.dsTablename = ipTableName no-error.
    if not avail dsTable then do: 
      TableSeq = TableSeq + 1.
      create dsTable.
      assign
        dsTable.dsTableSeq  = TableSeq
        dsTable.dsTablename = ipTableName
        dsTable.dsDBname    = ipDBname
        . 
    end.  
  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC logical addRelation(input ipParentTableName as char, input ipChildTableName as char, input ipFieldrelation as char):
    def var CheckHandle as handle extent 2 no-undo.
/*    CheckHandle[1] = dsh:get-buffer-handle(ipParentTableName) no-error.                                         */
/*    if not valid-handle(CheckHandle[1]) then                                                                    */
/*      undo, throw new Progress.Lang.AppError(substitute('&1 ble ikke funnet i datasettet',ipParentTablename),0).*/
/*                                                                                                                */
/*    CheckHandle[2] = dsh:get-buffer-handle(ipChildTableName) no-error.                                          */
/*    if not valid-handle(CheckHandle[2]) then                                                                    */
/*      undo, throw new Progress.Lang.AppError(substitute('&1 ble ikke funnet i datasettet',ipChildTablename),0). */
    if getTableId(ipParentTableName) = 0 then 
      undo, throw new Progress.Lang.AppError(substitute('&1 er ikke opprettet som tabell',ipParentTableName),0).      
    if getTableId(ipChildTableName) = 0 then 
      undo, throw new Progress.Lang.AppError(substitute('&1 er ikke opprettet som tabell',ipChildTableName),0).      
    if num-entries(ipFieldRelation,',') lt 2 then 
      undo, throw new Progress.Lang.AppError(substitute('Relation må minimum bestå av to felt kommaseparert:&1',ipFieldrelation),0).      

    create TableRelation.
    assign 
      TableRelationSeq = TableRelationSeq + 1
      TableRelation.TableRelationSeq      =  TableRelationSeq
      TableRelation.TableRelationParentId = getTableId(ipParentTableName)
      TableRelation.TableRelationChildId  = getTableId(ipChildTableName)
      TableRelation.TableRelationFields   = ipFieldrelation
      .
  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC integer getTableId(input ipTableName as char):
    for each dsTable no-lock where dsTable.dsTablename = ipTableName: leave. end.
    return if avail dsTable then dsTable.dsTableSeq else 0.
  end method.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:

extent(tth)     = 2.
extent(ttbh)    = 2.
extent(bhName)  = 2.

assign 
  bhName[1] = buffer norprosjekt:name
  bhName[2] = buffer npshanlg:name
  .
create temp-table tth[1].
tth[1]:create-like(buffer norprosjekt:handle).
tth[1]:temp-table-prepare(bhName[1]).
ttbh[1] = tth[1]:default-buffer-handle.

create temp-table tth[2].
tth[2]:create-like(buffer npshanlg:handle).
tth[2]:temp-table-prepare(bhName[2]).
ttbh[2] = tth[2]:default-buffer-handle.

dsh:set-buffers(ttbh[1],ttbh[2]).

extent(relations) = 1.

relations[1] = dsh:ADD-RELATION (ttbh[1],ttbh[2],'prosjektid,prosjektid',false,true,false,true,true).
     
     
  ------------------------------------------------------------------------------*/
  
  METHOD PUBLIC handle buildDataset():
    def var ii as int no-undo.
    def var relations as handle extent no-undo.
    def var tth       as handle extent no-undo.
    def var ttbh      as handle extent no-undo.
    def var bfh       as handle no-undo.

    create dataset dsh.
    assign
      extent(tth)       = TableSeq
      extent(ttbh)      = TableSeq
      extent(relations) = NumRelations
      .
    for each dsTable:
      create temp-table tth[dsTable.dsTableSeq].
      addTableFields(dsTable.dsTablename,tth[dsTable.dsTableSeq]).
      tth[dsTable.dsTableSeq]:temp-table-prepare(dsTable.dsTablename).
      ttbh[dsTable.dsTableSeq] = tth[dsTable.dsTableSeq]:default-buffer-handle.

      dsh:add-buffer(ttbh[dsTable.dsTableSeq]).
      do ii = 1 to ttbh[dsTable.dsTableSeq]:num-fields:
        bfh = ttbh[dsTable.dsTableSeq]:buffer-field(ii) no-error.
        if valid-handle(bfh) then 
          assign 
            bfh:SERIALIZE-NAME = bfh:name
            bfh:xml-node-name = bfh:name
          .
        for each ReplaceCharacter:
          if valid-handle(bfh) then bfh:SERIALIZE-NAME = replace(bfh:serialize-name,replaceCharacter.charValue,replaceCharacter.replaceWithChar).
          if valid-handle(bfh) then bfh:XML-NODE-NAME  = replace(bfh:xml-node-name,replaceCharacter.charValue,replaceCharacter.replaceWithChar).
        end.
        
      end.
    end.
    for each TableRelation:
      MESSAGE 'relation parent:'  ttbh[TableRelation.TableRelationParentId]:name ttbh[TableRelation.TableRelationParentId] skip       
       'child:' ttbh[TableRelation.TableRelationChildId]:name ttbh[TableRelation.TableRelationChildId]
       skip 'fields:' tablerelation.TableRelationFields skip 'repositionMode:' repositionMode skip  'isNested:' isNested
       skip tablerelation.TableRelationSeq
      VIEW-AS ALERT-BOX. 
      relations[TableRelation.TableRelationSeq] = dsh:add-relation(ttbh[TableRelation.TableRelationParentId],ttbh[TableRelation.TableRelationChildId],tablerelation.TableRelationFields,repositionMode,isNested,notActive,isRecursive,foreignKeyHidden).
    end.
    return dsh.
    
    CATCH eAny AS Progress.Lang.Error :
        
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.      
    END CATCH.
  END METHOD.
    
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
     
ADD-NEW-FIELD ( field-name-exp , datatype-exp[ , extent-exp[ , format-exp 
  [ , initial-exp[ , label-exp[ , column-label-exp ]]]]] )     
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC void addTableFields (input ipTableName as char, input iphTable as handle):
    for first tt_file where tt_File.cFile-Name = ipTableName: leave. end.
    if not avail tt_file then 
      undo, throw new Progress.Lang.AppError(substitute('Fant ikke tabell med navn: &1',ipTableName),0).
    
    for each tt_field where tt_Field.iFileNum = tt_File.iFileNum by tt_file.iFileNum by tt_field.iOrder:
      iphTable:add-new-field(tt_field.cField-Name,tt_field.cData-Type,tt_field.iExtent,tt_field.cFormat,?,tt_field.cLabel).    
    end.    
    addIndexes(ipTableName,iphTable).
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID addIndexes(input ipTableName as char, input iphTable as handle):
    def var tmpName1 as char no-undo.  
    def var tmpName2 as char no-undo.
    def var isPrimary as log no-undo.

    for first tt_file where tt_File.cFile-Name = ipTableName: leave. end.
    if not avail tt_file then
      undo, throw new Progress.Lang.AppError(substitute('Fant ikke tabell med navn: &1',ipTableName),0).
/*                                                                                                        */
/*    iphTable:ADD-NEW-INDEX ('idx' + ipTableName,true,true,false).                                       */
/*    iphTable:ADD-INDEX-FIELD ('idx' + ipTableName,ipTableName + '_ID').                                 */
/* end.                                                                                                   */

    for each tt_index where tt_index.iFileNum = tt_file.iFileNum
                        and tt_index.bActive
                        and (tt_index.bUnique or index(tt_index.cCode,'P') gt 0):
      assign
        tmpName1  = tt_index.cIndex-name
        isPrimary = index(tt_index.cCode,'P') gt 0
        .
      for each ReplaceCharacter:
        assign
          tmpName1 = replace(tmpName1,ReplaceCharacter.charValue,replaceCharacter.replaceWithChar)
          .
      end.
      iphTable:ADD-NEW-INDEX (tmpName1,tt_index.bUnique,isPrimary,false).
      for each tt_index-field where tt_index-field.iFileNum = tt_file.iFileNum
                                and tt_index-field.iIdxNum = tt_index.iIdxNum
                                :
        tmpName2 = tt_index-field.cFieldName.
        iphTable:ADD-INDEX-FIELD (tmpName1,tmpName2).
      end.
    end.
    CATCH eAny AS Progress.Lang.Error :
        
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC void writeXMLSchema (input ipXMLschemaFilename as char):
    dsh:WRITE-XMLSCHEMA (optionTargetType,ipXMLschemaFilename,optionFormatted,optionEncoding,optionMinSchema,optionOmitInitials).
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC void writeXML (input ipXMLFilename as char):
    dsh:WRITE-XML (optionTargetType,ipXMLFilename,optionFormatted,optionEncoding,optionSchemaLocation,optionWriteSchema,optionMinSchema,optionWriteBefore,optionOmitInitials).
  END METHOD.
END CLASS.
