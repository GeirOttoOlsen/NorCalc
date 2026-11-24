 
 /*------------------------------------------------------------------------
    File        : JBoxLogHandling.cls
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo_000
    Created     : Fri Dec 01 11:11:10 CET 2017
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxLogHandling: 
  def stream strOut.
  def static var iLogSeq as int no-undo.
  
  def static temp-table ttLog no-undo
    field iSeq        as int format ">>>>9"
    field dtLogDate   as datetime-tz 
    field cLogType    as char format "x(20)"
    field cLogMessage as char format "x(100)"
    index iSeq is primary unique iSeq
    index dtLogDate dtLogDate
    index cLogType cLogType
    .
  def static property ttLogHandle as handle get. set.
  def static property SkrivDirekte as log no-undo get. set.
  def static property SkrivDirekteLoggfil as char no-undo get. set.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxLogHandling ():

  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD static PUBLIC VOID addLog(input ipLogMessage as char  ):
    if SkrivDirekte and SkrivDirekteLoggfil ne '' then do:
      writeDirectToFile(ipLogMessage).
      return.
    end.  
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD static PUBLIC VOID addLog(input ipLogType as char, input ipLogMessage as char  ):
    create ttLog.
    assign 
      iLogSeq = iLogSeq + 1
      ttLog.iSeq        = iLogSeq
      ttLog.dtLogDate   = datetime-tz(now)
      ttLog.cLogType    = ipLogType
      ttLog.cLogMessage = ipLogMessage
    .
  END METHOD.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD private static VOID writeDirectToFile(input ipWriteMessage as char ):
    output stream strOut to value(SkrivDirekteLoggfil) append.
    put stream strOut unformatted ipWriteMessage skip.
    output stream strOut close.
  END METHOD.

 /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD static PUBLIC longchar writeLogType(input ipLogType as char):
    def var vlcMessage as longchar no-undo.
    fix-codepage(vlcMessage) = 'iso8859-1'.
    if ipLogType = '' then do:
      for each ttLog:
        vlcMessage = vlcMessage + string(ttLog.dtLogDate) + ' ' + ttLog.cLogType + ': ' + ttLog.cLogMessage + chr(13) + chr(10).
        delete ttLog.
      end.      
    end.
    else
      for each ttLog where lookup(ttLog.cLogType,ipLogType) gt 0 by iSeq:
        vlcMessage = vlcMessage + string(ttLog.dtLogDate) + ' ' + ttLog.cLogType + ': ' + ttLog.cLogMessage + chr(13) + chr(10).
        delete ttLog.
      end.
    return vlcMessage.    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD static PUBLIC VOID writeLogType(input ipLogType as char, input ipLogFile as char ):
    if ipLogFile = '' then return.
    find first ttLog where ttLog.cLogType = ipLogType no-lock no-error.
    if not avail ttLog then return.
    output stream strOut to value(ipLogFile).
    if ipLogType = '' then do:
      for each ttLog:
        put stream strOut unformatted string(ttLog.dtLogDate) + ' ' + ttLog.cLogType + ': ' + ttLog.cLogMessage skip.
        delete ttLog.
      end.      
    end.
    else
      for each ttLog where lookup(ttLog.cLogType,ipLogType) gt 0 by iSeq:
        put stream strOut unformatted string(ttLog.dtLogDate) + ' ' + ttLog.cLogType + ': ' + ttLog.cLogMessage skip.
        delete ttLog.
      end.
    output stream strOut close.
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD static PUBLIC VOID writeLogType(input ipLogType as char, input ipLogFile as char, ipAppend as log):
    if ipLogFile = '' then return.
    find first ttLog where ttLog.cLogType = ipLogType no-lock no-error.
    if not avail ttLog then return.
    if ipAppend then 
      output stream strOut to value(ipLogFile) append.
    else
      output stream strOut to value(ipLogFile).
    if ipLogType = '' then do:
      for each ttLog:
        put stream strOut unformatted string(ttLog.dtLogDate) + ' ' + ttLog.cLogType + ': ' + ttLog.cLogMessage skip.
        delete ttLog.
      end.      
    end.
    else
      for each ttLog where lookup(ttLog.cLogType,ipLogType) gt 0 by iSeq:
        put stream strOut unformatted string(ttLog.dtLogDate) + ' ' + ttLog.cLogType + ': ' + ttLog.cLogMessage skip.
        delete ttLog.
      end.
    output stream strOut close.
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD static PUBLIC VOID writeLogType(input ipLogType as char, input ipLogFile as char, ipAppend as log,input ipNoInfo as log):
    if ipLogFile = '' then return.
    find first ttLog where ttLog.cLogType = ipLogType no-lock no-error.
    if not avail ttLog then return.
    if ipAppend then 
      output stream strOut to value(ipLogFile) append.
    else
      output stream strOut to value(ipLogFile).
    if ipLogType = '' then do:
      for each ttLog:
        if ipNoInfo then put stream strOut unformatted ttLog.cLogMessage skip.
        else             put stream strOut unformatted string(ttLog.dtLogDate) + ' ' + ttLog.cLogType + ': ' + ttLog.cLogMessage skip.
        delete ttLog.
      end.      
    end.
    else
      for each ttLog where lookup(ttLog.cLogType,ipLogType) gt 0 by iSeq:
        if ipNoInfo then put stream strOut unformatted ttLog.cLogMessage skip.
        else             put stream strOut unformatted string(ttLog.dtLogDate) + ' ' + ttLog.cLogType + ': ' + ttLog.cLogMessage skip.
        delete ttLog.
      end.
    output stream strOut close.
    
  END METHOD.

/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD static PUBLIC void emptyLogTable(input ipLogType as char):
    if ipLogType = '' then temp-table ttLog:handle:EMPTY-TEMP-TABLE ().
    else 
      for each ttLog where ttLog.cLogType = ipLogType:
        delete ttLog.
      end.
  END METHOD.

/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method static PUBLIC character getBufferLabelList (input ipBuffer as handle, input ipDelimiter as char):
    def var ix as int no-undo.
    def var ReturnText as char no-undo.
    
    do ix = 1 to ipBuffer:num-fields:
      ReturnText = ReturnText + ipDelimiter + ipBuffer:buffer-field(ix):label.  
    end.
    ReturnText = trim(ReturnText,ipDelimiter).
    return ReturnText.
  end method.

/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method static PUBLIC character getBufferLabelList (input ipBuffer as handle, input ipDelimiter as char,input ipExcludeFields as char):
    def var ix as int no-undo.
    def var ReturnText as char no-undo.
    
    do ix = 1 to ipBuffer:num-fields:
      if can-do(ipExcludeFields,ipBuffer:buffer-field(ix):name) then next.
      ReturnText = ReturnText + ipDelimiter + ipBuffer:buffer-field(ix):label.  
    end.
    ReturnText = trim(ReturnText,ipDelimiter).
    return ReturnText.
  end method.

/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method static public character getBufferContentList (input ipBuffer as handle, input ipDelimiter as char):
    return getBufferContentList(ipBuffer,ipDelimiter,?).
  end method.

/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method static public character getBufferContentList (input ipBuffer as handle, input ipDelimiter as char, input ipExcludeFields as char):
    def var ix as int no-undo.
    def var ReturnText as char no-undo.
    
    do ix = 1 to ipBuffer:num-fields:
      if can-do(ipExcludeFields,ipBuffer:buffer-field(ix):name) then next.
      case ipBuffer:buffer-field(ix):data-type:
        when 'date' or when 'datetime' or when 'datetime-tz' then 
          ReturnText = ReturnText + (if ipBuffer:buffer-field(ix):buffer-value <> ? then string(ipBuffer:buffer-field(ix):string-value) else "") + ipDelimiter.
        otherwise 
          ReturnText = ReturnText + (if ipBuffer:buffer-field(ix):buffer-value <> ? then string(ipBuffer:buffer-field(ix):buffer-value) else "") + ipDelimiter.  
      end case.
    end.
    ReturnText = substring(ReturnText,1,length(ReturnText) - 1).
    return ReturnText.
  end method.

  METHOD static PUBLIC longchar writeLogType(input ipLogType as char,input ipNoInfo as log):

    def var vlcMessage as longchar no-undo.

    fix-codepage(vlcMessage) = 'iso8859-1'.

    if ipLogType = '' then do:

      for each ttLog:

        if ipNoInfo then

          vlcMessage = vlcMessage + ttLog.cLogMessage + chr(13) + chr(10).

        else

          vlcMessage = vlcMessage + string(ttLog.dtLogDate) + ' ' + ttLog.cLogType + ': ' + ttLog.cLogMessage + chr(13) + chr(10).

        delete ttLog.

      end.     

    end.

    else

      for each ttLog where lookup(ttLog.cLogType,ipLogType) gt 0 by iSeq:

        if ipNoInfo then

          vlcMessage = vlcMessage + ttLog.cLogMessage + chr(13) + chr(10).

        else

          vlcMessage = vlcMessage + string(ttLog.dtLogDate) + ' ' + ttLog.cLogType + ': ' + ttLog.cLogMessage + chr(13) + chr(10).

        delete ttLog.

      end.

    return vlcMessage.   

  END METHOD.

  method static public void writeToLogManager(input ipLongchar as longchar,input ipLogType as char):
    var int  iPos,iChunkSize=30000,iLen=length(ipLongchar).
    var char chunk.
    
    if OpenEdge.Core.String:IsNullOrEmpty(ipLongchar) then 
      undo, throw new Progress.Lang.AppError('Kan ikke være tom eller ukjent',0).
      
    DO iPos = 1 TO iLen BY 30000:
        Chunk = substring(ipLongchar,iPos,MINIMUM (iChunkSize,iLen - iPos + 1)).
        LOG-MANAGER:WRITE-MESSAGE(chunk,ipLogType).
    END.    
  end method.
END CLASS.
