 
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

CLASS jboxcmd:
  DEFINE VARIABLE oProcess AS System.Diagnostics.Process NO-UNDO.
  
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
  DEFINE PROPERTY ProcessID   AS INTEGER  NO-UNDO GET. PRIVATE SET.
  DEFINE PROPERTY ProcessName AS CHARACTER NO-UNDO GET. PRIVATE SET.

  CONSTRUCTOR PUBLIC jboxcmd (icExecuteable AS CHARACTER):
    oProcess = NEW System.Diagnostics.Process().
    oProcess:StartInfo = new System.Diagnostics.ProcessStartInfo(icExecuteable).
    oProcess:Start().
    
    CATCH e AS Progress.Lang.Error:
      MESSAGE e:GetMessage(1)
      VIEW-AS ALERT-BOX.
    END CATCH.
      
  END CONSTRUCTOR.
  		
	CONSTRUCTOR PUBLIC jboxcmd (icExecuteable AS CHARACTER, icArguments AS CHARACTER  ):
    oProcess = NEW System.Diagnostics.Process().
    oProcess:StartInfo = new System.Diagnostics.ProcessStartInfo(icExecuteable).
    oProcess:StartInfo:Arguments = icArguments.
    oProcess:StartInfo:UseShellExecute = false.
    oProcess:StartInfo:CreateNoWindow  = TRUE.
    oProcess:Start().
    ProcessName = oProcess:ProcessName.
    ProcessID   = oProcess:Id. 
  	
/*  	oProcess = NEW System.Diagnostics.Process().       */
/*  	oProcess:StartInfo:UseShellExecute = false.        */
/*  	oProcess:StartInfo:FileName        = icExecuteable.*/
/*  	oProcess:StartInfo:Arguments       = icArguments.  */
/*  	oProcess:StartInfo:CreateNoWindow  = TRUE.         */
/*  	oProcess:Start().                                  */
/*  	ProcessName = oProcess:ProcessName.                */
/*  	ProcessID   = oProcess:Id.                         */
/*  /*  oProcess:WaitForExit().*/                       */
/*                                                      */
    CATCH e AS Progress.Lang.Error:
      MESSAGE e:GetMessage(1)
      VIEW-AS ALERT-BOX.
    END CATCH.
  		
	END CONSTRUCTOR.


END CLASS.