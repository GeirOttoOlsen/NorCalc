 
 /*------------------------------------------------------------------------
    File        : jboxcmd
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo
    Created     : Tue Jun 09 22:32:56 CEST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxCMD:
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE oProcess AS System.Diagnostics.Process NO-UNDO.
  def var oProcessStartInfo as System.Diagnostics.ProcessStartInfo no-undo. 

  DEFINE PUBLIC PROPERTY ProcessID   AS INTEGER  NO-UNDO GET. PRIVATE SET.
  DEFINE PUBLIC PROPERTY ProcessName AS CHARACTER NO-UNDO GET. PRIVATE SET.
  DEFINE PUBLIC PROPERTY AktivPIDs   AS CHARACTER  NO-UNDO GET. PRIVATE SET. 
  DEFINE PUBLIC PROPERTY PID         AS INTEGER NO-UNDO GET.  PRIVATE SET.  
  		
	CONSTRUCTOR PUBLIC JBoxCMD (input icExecuteable AS CHARACTER):
    System.Diagnostics.Process:Start(icExecuteable).  
  
  CATCH e AS Progress.Lang.Error:
    MESSAGE e:GetMessage(1)
    VIEW-AS ALERT-BOX.
  END CATCH.
		
	END CONSTRUCTOR.


    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
  CONSTRUCTOR PUBLIC JBoxCMD ():
    
  END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC JBoxCMD (icExecuteable AS CHARACTER, icArguments AS CHARACTER  ):
        SUPER ().
    
    
    oProcess = NEW System.Diagnostics.Process().
    oProcess:StartInfo:UseShellExecute = FALSE.
    oProcess:StartInfo:FileName        = icExecuteable.
    oProcess:StartInfo:Arguments       = icArguments.
    oProcess:StartInfo:CreateNoWindow  = TRUE.
    oProcess:Start().
    ProcessName = oProcess:ProcessName.
    ProcessID   = oProcess:Id. 
/*  oProcess:WaitForExit().*/
  
  CATCH e AS Progress.Lang.Error:
    MESSAGE e:GetMessage(1)
    VIEW-AS ALERT-BOX.
  END CATCH.
        
    END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
      
  CONSTRUCTOR PUBLIC JBoxCMD (ipExecuteable AS CHARACTER, ipArguments AS longchar,input ipFileExtention as char):
    def var filnavn as char no-undo.
    def var oFile as System.IO.FileInfo no-undo.
    
    if index('.',ipFileExtention) = 0 then ipFileExtention = '.' + ipFileExtention.
    filnavn = System.IO.Path:GetTempPath() + 'note' + string(time) + ipFileExtention.
    copy-lob from object ipArguments to file filnavn no-convert.
    if not System.IO.File:Exists(filnavn) then undo, throw new Progress.Lang.AppError('Fant ikke filen: ' + quoter(filnavn)).
    if ipExecuteable ne '' then do:
      oProcess = NEW System.Diagnostics.Process().
      oProcess:StartInfo:UseShellExecute = FALSE.
      oProcess:StartInfo:FileName        = ipExecuteable.
      oProcess:StartInfo:Arguments       = filnavn.
      oProcess:StartInfo:CreateNoWindow  = TRUE.
      oProcess:Start().
      ProcessName = oProcess:ProcessName.
      ProcessID   = oProcess:Id. 
    end.
    else do:
      System.Diagnostics.Process:Start(filnavn).
    end.
    
      
    CATCH e AS Progress.Lang.Error:      
      MESSAGE ' filnavn:' filnavn ' feilet med: ' e:GetMessage(1) 
      VIEW-AS ALERT-BOX error.
    END CATCH.
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
       If ipFileExtention includes filename and extent, use it, else if only extent then add session:temp....
  ------------------------------------------------------------------------------*/
      
  CONSTRUCTOR PUBLIC JBoxCMD (ipExecuteable AS CHARACTER, ipArguments AS MEMPTR,input ipFileExtention as char):
    def var filnavn as char no-undo.
    /**Sjekker om ipFileEtention er lagt inn med f.eks. ".pdf" eller "pdf", altså legger til . om det ikke finnes */
    if index('.',ipFileExtention) = 0 then ipFileExtention = '.' + ipFileExtention.
    filnavn = System.IO.Path:GetTempPath() + 'blob' + string(time) + ipFileExtention. 
    
    copy-lob from object ipArguments to file filnavn no-error.

/*    oProcess = NEW Process().                          */
/*    oProcess:StartInfo:UseShellExecute = FALSE.        */
/*    oProcess:StartInfo:FileName        = ipExecuteable.*/
/*    oProcess:StartInfo:Arguments       = filnavn.      */
/*    oProcess:StartInfo:CreateNoWindow  = TRUE.         */
/*    oProcess:Start().                                  */
    System.Diagnostics.Process:Start(filnavn).
/*    ProcessName = oProcess:ProcessName.*/
/*    ProcessID   = oProcess:Id.         */
/*    System.Threading.Thread:Sleep(2000).*/
/*    System.IO.File:Delete(filnavn).     */

    CATCH e AS Progress.Lang.Error:
      MESSAGE e:GetMessage(1) skip ' filnavn:' filnavn 
      VIEW-AS ALERT-BOX.
    END CATCH.
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxCMD (icExecuteable AS CHARACTER, icArguments AS CHARACTER, ProcessWaitSeconds as int ):
    SUPER ().
  
  
  oProcess = NEW System.Diagnostics.Process().
  oProcess:StartInfo:UseShellExecute = FALSE.
  oProcess:StartInfo:FileName        = icExecuteable.
  oProcess:StartInfo:Arguments       = icArguments.
  oProcess:StartInfo:CreateNoWindow  = TRUE.
  oProcess:Start().
  ProcessName = oProcess:ProcessName.
  ProcessID   = oProcess:Id. 
  if ProcessWaitSeconds gt 0 then oProcess:WaitForExit(ProcessWaitSeconds * 1000).
  
  CATCH e AS Progress.Lang.Error:
    MESSAGE e:GetMessage(1)
    VIEW-AS ALERT-BOX.
  END CATCH.
    
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID OpenAndDelete(input ipContent as longchar, input ipFileExtention as char):
    def var filnavn as char no-undo.

    if index('.',ipFileExtention) = 0 then ipFileExtention = '.' + ipFileExtention.
    filnavn = System.IO.Path:GetTempPath() + 'note' + string(time) + ipFileExtention.
    copy-lob from object ipContent to file filnavn no-convert.
     
    System.Diagnostics.Process:Start(filnavn).
    System.Threading.Thread:Sleep(2000).
    System.IO.File:Delete(filnavn).
      
  

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID WaitForPIDExit(INPUT ipPID AS INTEGER EXTENT  ):
    DEFINE VARIABLE iCnt AS INTEGER NO-UNDO.
    DEFINE VARIABLE ix   AS INTEGER NO-UNDO.
    
    DO iCnt = 1 TO EXTENT(ipPID):
      PID = int(ipPID[iCnt]).
      AktivPIDs = AktivPIDs + (IF AktivPIDs = '' THEN '' ELSE ',') + string(PID).
    END.

    LOG-MANAGER:WRITE-MESSAGE('Aktive prosesser:' + AktivPIDs,'INFO').
  
    DO WHILE AktivPIDs NE '':
      DO ix = 1 TO NUM-ENTRIES(AktivPIDs) ON ERROR UNDO, NEXT:    
        PID = int(ENTRY(ix,AktivPIDs)).
        IF NOT VALID-OBJECT (System.Diagnostics.Process:GetProcessById(PID)) THEN 
          UNDO, THROW NEW System.ArgumentException().
         
        CATCH e AS System.ArgumentException :
          AktivPIDs = REPLACE(AktivPIDs,STRING(PID),'').
          REPEAT WHILE INDEX(AktivPIDs,',,') GT 0:
            AktivPIDs = REPLACE(AktivPIDs,',,',',').
          END.
        END CATCH.
      END.
      AktivPIDs = TRIM(AktivPIDs,'0').
      AktivPIDs = TRIM(AktivPIDs,',').
      AktivPIDs = TRIM(AktivPIDs,' ').
      if AktivPIDs ne '' then do: 
        System.Threading.Thread:Sleep(60000).
      end.
    END.

  END METHOD.

  METHOD public void schTask (input ipTaskName as char):
    def var cmd as char no-undo.
    def var arg as char no-undo.
    def var OutputText as longchar no-undo.
    def var oOutputReader as System.IO.StreamReader no-undo.

    def var oStartInfo as System.Diagnostics.ProcessStartInfo no-undo.
    assign 
      cmd = 'schtasks.exe'
      arg = ' /query /fo LIST ' // + quoter(ipTaskName).
    
      
    oProcess = NEW System.Diagnostics.Process().
    oStartInfo = new System.Diagnostics.ProcessStartInfo().
    oStartInfo:UseShellExecute = false.
    oStartInfo:FileName        = cmd.
    oStartInfo:Arguments       = arg.
    oStartInfo:CreateNoWindow  = true.
    oStartInfo:RedirectStandardOutput = true.
    oStartInfo:RedirectStandardError = true.
    oProcess:StartInfo = oStartInfo.
    oProcess:Start().
    
    ProcessName = oProcess:ProcessName.
    ProcessID   = oProcess:Id. 

    oOutputReader = oProcess:StandardOutput. 

    outputText = oOutputReader:ReadToEnd().
    //System.Threading.Thread:Sleep(3000).
    //OpenAndDelete(OutputText,'.txt'). 
    
    CATCH e AS Progress.Lang.Error:
      MESSAGE e:GetMessage(1)
      VIEW-AS ALERT-BOX.
    END CATCH.
    
    FINALLY:
      this-object:OpenAndDelete(OutputText,'.txt').        
    END FINALLY.
  END Method.

END CLASS.