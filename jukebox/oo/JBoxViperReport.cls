 
 /*------------------------------------------------------------------------
    File        : JBoxViperReport
    Purpose     : Helper class for viper
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Thu Mar 4 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

CLASS JBoxViperReport:
  
  DEF VAR cLogoImage             AS CHAR NO-UNDO.
  DEF VAR cOrientation           AS CHAR NO-UNDO.
  DEF VAR iImageXPos             AS INT NO-UNDO.
  DEF VAR cLayout                AS CHAR NO-UNDO.
  DEF VAR hHelper                AS HANDLE NO-UNDO.

  DEF PUBLIC PROPERTY showCellFieldWarning  AS LOG NO-UNDO GET. SET.

  DEF PUBLIC PROPERTY viperWebPrinter AS CHAR NO-UNDO 
     GET: 
       DEF VAR cPrinter AS CHAR NO-UNDO.
       RUN getViperWebPrinter IN hHelper (OUTPUT cPrinter).
       RETURN cPrinter.
     END GET.
     PROTECTED SET.  

  CONSTRUCTOR PUBLIC JBoxViperReport ():
    RUN JBoxViperReportHelper.p PERSIST SET hHelper.  
  END CONSTRUCTOR.


  METHOD PUBLIC CHARACTER activateDocumentLayout(INPUT icDocLayout AS CHAR):
    
   RUN vpr_ActivateReport IN hHelper (icDocLayout).
   RUN vpr_ResetDoc IN hHelper.
   RUN vpr_InitGroups IN hHelper("").

  END METHOD.

	METHOD PUBLIC CHARACTER getGroupObjects(INPUT icGroupName  AS CHAR
                                         ,INPUT icTypeList   AS CHAR):
                                         
    
    DEF VAR ocObjectList AS CHAR NO-UNDO.
		
    RUN getGroupObjects IN hHelper (icGroupName,icTypeList,OUTPUT ocObjectList).
    
    RETURN ocObjectList.
	END METHOD.

  METHOD PUBLIC CHARACTER getGroupList():
                                         
    
    DEF VAR ocGroupList AS CHAR NO-UNDO.
    
    RUN getGroupList IN hHelper (OUTPUT ocGroupList).
    
    RETURN ocGroupList.
  END METHOD.

  METHOD PUBLIC CHARACTER getGroupTTdef(INPUT icGroupName  AS CHAR):
                                         
    DEF VAR ix           AS INT  NO-UNDO.
    DEF VAR ocObjectList AS CHAR NO-UNDO.
    DEF VAR cTtDef       AS CHAR NO-UNDO.
    
    RUN getGroupObjects IN hHelper (icGroupName,"cell",OUTPUT ocObjectList).
    
    cTtDef = "DEF TEMP-TABLE " + icGroupName + " NO-UNDO" + CHR(10).
    
    DO ix = 1 TO NUM-ENTRIES(ocObjectList):
      cTtDef = cTtDef + "  FIELD " + ENTRY(ix,ocObjectList) + " AS CHAR" + CHR(10).  
    END.
    cTtDef = cTtDef + "  .".
    
    RETURN cTtDef.
  END METHOD.

  METHOD PUBLIC CHARACTER getReportDSdef():
                                         
    DEF VAR ix           AS INT  NO-UNDO.
    DEF VAR iy           AS INT  NO-UNDO.
    DEF VAR ocObjectList AS CHAR NO-UNDO.
    DEF VAR cDsDef       AS CHAR NO-UNDO.
    DEF VAR cTtDef       AS CHAR NO-UNDO.
    DEF VAR cGroupList   AS CHAR NO-UNDO.
    DEF VAR cGroupName   AS CHAR NO-UNDO.
    
    cGroupList = THIS-OBJECT:getGroupList().
    
    DO ix = 1 TO NUM-ENTRIES(cGroupList):
      cGroupName = ENTRY(ix,cGroupList).
      
      RUN getGroupObjects IN hHelper (cGroupName,"cell",OUTPUT ocObjectList).
    
      cTtDef = cTtDef + CHR(10) + "DEF TEMP-TABLE " + cGroupName + " NO-UNDO" + CHR(10).
    
      DO iy = 1 TO NUM-ENTRIES(ocObjectList):
        cTtDef = cTtDef + "  FIELD " + ENTRY(iy,ocObjectList) + " AS CHAR" + CHR(10).  
      END.
      cTtDef = cTtDef + "  .".
    END.  

    cDsDef = cTtDef + CHR(10) + "DEF DATASET dsReport FOR " + cGroupList + "." + CHR(10).
    
    RETURN cDsDef.
  END METHOD.
  
  METHOD PUBLIC CHARACTER loadVfrFile(INPUT icVFRfile AS CHAR
                                     ,INPUT icOrientation AS CHAR):
        
    IF icOrientation NE "" THEN
      RUN vpr_SetPageOrientation IN hHelper (icOrientation). 
    RUN vpr_LoadVFR IN hHelper (icVFRfile).
    RUN vpr_SetPreviewMode IN hHelper ("direct").
    RUN vpr_SetDelimiter IN hHelper ("|").
  END METHOD.

  METHOD PUBLIC CHARACTER printPDF(INPUT icPdfFileName AS CHAR
                                  ,INPUT ibOpen AS LOG ):
    THIS-OBJECT:setPrinter(THIS-OBJECT:viperWebPrinter).
                       
    IF THIS-OBJECT:viperWebPrinter BEGINS "Microsoft" THEN DO:
      MESSAGE "Skriver til " REPLACE(icPdfFileName,".pdf",".prn")
      VIEW-AS ALERT-BOX.
      RUN vpr_SetPrinterAttrib IN hHelper("tofile=yes,FileTo=" + REPLACE(icPdfFileName,".pdf",".prn")).
      RUN vpr_printDOC IN hHelper (0,0).
    END.  
    ELSE                                        
      RUN vpr_printPDF IN hHelper (0,0,INPUT-OUTPUT icPdfFileName).
    IF ibOpen THEN 
      OS-COMMAND NO-WAIT VALUE(icPdfFileName).
  END METHOD.

  METHOD PUBLIC VOID autoFillGroup (INPUT ihBufferOrQuery AS HANDLE
                                   ,INPUT icGroupName     AS CHAR
                                   ,INPUT iiGroupVpos     AS INT):

    DEF VAR cCellList  AS CHAR   NO-UNDO.
    DEF VAR cValueList AS CHAR   NO-UNDO.
    DEF VAR ix         AS INT    NO-UNDO.
    DEF VAR iy         AS INT    NO-UNDO.
    DEF VAR hField     AS HANDLE NO-UNDO.
    DEF VAR cValue     AS CHAR   NO-UNDO.
    DEF VAR cCellField AS CHAR   NO-UNDO.
    DEF VAR bLabel     AS LOG    NO-UNDO.
    DEF VAR hBuffer    AS HANDLE NO-UNDO EXTENT.
    DEF VAR cUsedFlds  AS CHAR   NO-UNDO.
    DEF VAR bAddColon  AS LOG    NO-UNDO.
    
    IF ihBufferOrQuery:TYPE = "query" THEN DO:
      EXTENT(hBuffer) = ihBufferOrQuery:NUM-BUFFERS.
      DO ix = 1 TO ihBufferOrQuery:NUM-BUFFERS:
        hBuffer[ix] = ihBufferOrQuery:GET-BUFFER-HANDLE (ix).
      END.    
    END.
    ELSE 
      ASSIGN EXTENT(hBuffer) = 1
             hBuffer[1] = ihBufferOrQuery.
    
    IF SUBSTR(icGroupName,LENGTH(icGroupName)) = ":" THEN 
      ASSIGN bAddColon = YES
             icGroupName = TRIM(icGroupName,":").
    
    cCellList = THIS-OBJECT:getGroupObjects(icGroupName,"").
    
    DO ix = 1 TO NUM-ENTRIES(cCellList):
      cValue = "".
      cCellField = ENTRY(ix,cCellList).
      DO iy = 1 TO EXTENT(hBuffer):
        hField = hBuffer[iy]:BUFFER-FIELD(cCellField) NO-ERROR.
        IF ERROR-STATUS:GET-MESSAGE(1) NE "" THEN DO:
          IF cCellField MATCHES "*JBlabel" THEN
            ASSIGN cCellField = SUBSTR(cCellField,1,R-INDEX(cCellField,"_JBlabel") - 1)
                   bLabel     = YES.
          hField = hBuffer[iy]:BUFFER-FIELD(cCellField) NO-ERROR.
        END.         
/*            IF ihBufferOrQuery:TYPE = "query" then                                */
/*              MESSAGE iy ix SKIP "cCellField" cCellField SKIP valid-handle(hField)*/
/*              VIEW-AS ALERT-BOX.                                                  */
        IF ERROR-STATUS:GET-MESSAGE(1) NE "" AND PROGRESS = "full" AND showCellFieldWarning THEN 
          MESSAGE "Field for cell" ENTRY(ix,cCellList) "not defined in buffer" SKIP 
                  "Continue to show these warnings for this run?" SKIP 
                  "(warning not shown in runtime)" SKIP(1)
                  ERROR-STATUS:GET-MESSAGE(1)
                  VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE showCellFieldWarning.
        ELSE IF ERROR-STATUS:GET-MESSAGE(1) = "" AND NOT CAN-DO(cUsedFlds,cCellField) THEN DO:
          IF bLabel THEN cValue = hField:LABEL.
          ELSE
            CASE hField:DATA-TYPE:
              WHEN "CHARACTER" THEN cValue = hField:BUFFER-VALUE.
              OTHERWISE cValue = STRING(hField:BUFFER-VALUE,hField:FORMAT).
            END.            
          cValueList = cValueList + (IF iy > 1 OR ix > 1 THEN "|" ELSE "") + (IF cValue NE ? THEN cValue + (IF bAddColon THEN ":" ELSE "") ELSE "").
          cUsedFlds = cUsedFlds + (IF cUsedFlds NE "" THEN "," ELSE "") + cCellField.
        END.  
      END.
    END.  
    
    IF ihBufferOrQuery:TYPE = "query" then
      MESSAGE icGroupName SKIP cCellField SKIP cCellList skip cValueList
      VIEW-AS ALERT-BOX.

    THIS-OBJECT:createGroup (icGroupName,iiGroupVpos,cCellList,cValueList).
  END METHOD.

  METHOD PUBLIC VOID autoFillGroup (INPUT ihBuffer AS HANDLE EXTENT
                                   ,INPUT icGroupName AS CHAR
                                   ,INPUT iiGroupVpos AS INT):
                                
    DEF VAR cCellList  AS CHAR   NO-UNDO.
    DEF VAR cValueList AS CHAR   NO-UNDO.
    DEF VAR ix         AS INT    NO-UNDO.
    DEF VAR hField     AS HANDLE NO-UNDO.
    DEF VAR cValue     AS CHAR   NO-UNDO.
    DEF VAR cCellField AS CHAR   NO-UNDO.
    DEF VAR bLabel     AS LOG    NO-UNDO.
    DEF VAR iBuff      AS INT    NO-UNDO.
    
    cCellList = THIS-OBJECT:getGroupObjects(icGroupName,"").
       
    DO iBuff = 1 TO EXTENT(ihBuffer): 
      DO ix = 1 TO NUM-ENTRIES(cCellList):
        cValue = "".
        cCellField = ENTRY(ix,cCellList).
        hField = ihBuffer[iBuff]:BUFFER-FIELD(cCellField) NO-ERROR.
        IF ERROR-STATUS:GET-MESSAGE(1) NE "" THEN DO:
          IF cCellField MATCHES "*JBlabel" THEN
            ASSIGN cCellField = SUBSTR(cCellField,1,R-INDEX(cCellField,"_JBlabel") - 1)
                   bLabel     = YES.
          hField = ihBuffer[iBuff]:BUFFER-FIELD(cCellField) NO-ERROR.
        END.         
        IF ERROR-STATUS:GET-MESSAGE(1) NE "" AND PROGRESS = "full" AND showCellFieldWarning THEN 
          MESSAGE "Field for cell" ENTRY(ix,cCellList) "not defined in buffer" SKIP 
                  "Continue to show these warnings for this run?" SKIP 
                  "(warning not shown in runtime)" SKIP(1)
                  ERROR-STATUS:GET-MESSAGE(1)
                  VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE showCellFieldWarning.
        ELSE IF ERROR-STATUS:GET-MESSAGE(1) = "" THEN DO:
          IF bLabel THEN cValue = hField:LABEL.
          ELSE
            CASE hField:DATA-TYPE:
              WHEN "CHARACTER" THEN cValue = hField:BUFFER-VALUE.
              OTHERWISE cValue = STRING(hField:BUFFER-VALUE,hField:FORMAT).
            END.            
        END.  
        cValueList = cValueList + (IF cValueList NE "" THEN "|" ELSE "") + (IF cValue NE ? THEN cValue ELSE "").
      END.
    END.  

    THIS-OBJECT:createGroup (icGroupName,iiGroupVpos,cCellList,cValueList).

  END METHOD.

  METHOD PUBLIC VOID autoFillLabelGroup (INPUT ihBufferOrQuery AS HANDLE
                                        ,INPUT icGroupName     AS CHAR
                                        ,INPUT iiGroupVpos     AS INT):
    IF SUBSTR(icGroupName,LENGTH(icGroupName)) = ":" THEN DO: 
      icGroupName = TRIM(icGroupName,":").
      THIS-OBJECT:autoFillGroup(ihBufferOrQuery, icGroupName + "_JBlabels:", iiGroupVpos).
    END.                                        
    ELSE                                          
      THIS-OBJECT:autoFillGroup(ihBufferOrQuery, icGroupName + "_JBlabels", iiGroupVpos).                                      
  END METHOD.                                        

  METHOD PUBLIC VOID createGroup (INPUT icGroupName  AS CHAR
                                 ,INPUT iiGroupVPos  AS INT
                                 ,INPUT icGroupFields AS CHAR
                                 ,INPUT icGroupValues AS CHAR):
  

  IF iiGroupVPos <> ? THEN
    RUN vpr_SetGroupVPos IN hHelper (icGroupName,iiGroupVPos).
  RUN vpr_SetGroupText IN hHelper (icGroupName,icGroupFields,icGroupValues).
  RUN vpr_FlushGroup IN hHelper (icGroupName).
    
  END METHOD.


  METHOD PUBLIC VOID printDocument ():
    RUN vpr_PrintDoc IN hHelper (0,0).
  END METHOD.

  METHOD PUBLIC VOID showPreview ().
    DEF VAR bPrvwRefreshed AS LOG NO-UNDO.
    DEF VAR ix           AS INT NO-UNDO.
    
/*    IF NOT VALID-HANDLE(hParent) THEN                                     */
/*      hParent = SOURCE-PROCEDURE.                                         */
/*                                                                          */
/*    IF VALID-HANDLE(hParent) AND VALID-HANDLE(hParent:CURRENT-WINDOW) THEN*/
/*      hParent:CURRENT-WINDOW:SENSITIVE = NO.                              */
    
    RUN vpr_EndDoc IN hHelper.
    IF cOrientation = "landscape" THEN
      RUN vpr_SetWindowPos IN hHelper (0,0,SESSION:WIDTH-PIXELS,SESSION:HEIGHT-PIXELS - 40). 
    ELSE
      RUN vpr_SetWindowPos IN hHelper (SESSION:WIDTH-PIXELS / 4,0,SESSION:WIDTH-PIXELS / 2,SESSION:HEIGHT-PIXELS - 40).
    
    RUN vpr_ShowPreview IN hHelper.
    
    /* DYNAMIC-FUNCTION("DoLockWindow",?).              */
    /*                                                  */
    DO WHILE DYNAMIC-FUNCTION("vpr_GetPreviewStatus" IN hHelper, 500) = "visible":
      ix = ix + 1.
    /*   IF ix > 1 AND NOT bPrvwRefreshed THEN DO: */
    /*     RUN vpr_HidePreview.                    */
    /*     RUN vpr_ShowPreview.                    */
    /*     bPrvwRefreshed = YES.                   */
    /*   END.                                      */
    END.
    
/*    IF VALID-HANDLE(hParent) AND VALID-HANDLE(hParent:CURRENT-WINDOW) THEN*/
/*      hParent:CURRENT-WINDOW:SENSITIVE = YES.                             */
  END METHOD.
  
  METHOD PUBLIC VOID NewPage ():
    RUN vpr_NewPage IN hHelper.
  
    RUN vpr_InitGroups IN hHelper ("").
  END METHOD.  

  METHOD PUBLIC INTEGER getPageVPos ():

    RETURN DYNAMIC-FUNCTION("vpr_GetPageVPos" IN hHelper).
  END.
  
  METHOD PUBLIC VOID loadImage (INPUT icImageFile AS CHAR
                               ,INPUT iiXpos AS INT
                               ,INPUT iiYpos AS INT
                               ,INPUT iiWidth AS INT
                               ,INPUT iiHeight AS INT).
    RUN vpr_DefBMP IN hHelper (icImageFile,iiXpos,iiYpos,iiWidth,iiHeight,"Resize,KeepRatio").
  END METHOD.
  
  METHOD PUBLIC CHARACTER getViperPrinter ():
    DEFINE VARIABLE result AS CHARACTER NO-UNDO.
  
    RUN getViperPrinter IN hHelper (OUTPUT result).
    RETURN result.
  END.

  METHOD PUBLIC VOID defHLine (INPUT iiXpos AS INT
                              ,INPUT iiYpos AS INT
                              ,INPUT iiLength AS INT
                              ,INPUT iiWidth  AS INT
                              ,INPUT icColor  AS CHAR):
     
    RUN vpr_DefHLine IN hHelper (iiXpos,iiYpos,iiLength,"solid",iiWidth,icColor).
  END METHOD.

  METHOD PUBLIC VOID defVLine (INPUT iiXpos AS INT
                              ,INPUT iiYpos AS INT
                              ,INPUT iiLength AS INT
                              ,INPUT iiWidth  AS INT
                              ,INPUT icColor  AS CHAR):
     
    RUN vpr_DefVLine IN hHelper (iiXpos,iiYpos,iiLength,"solid",iiWidth,icColor).
  END METHOD.

  METHOD PUBLIC VOID defRect (INPUT iiXpos AS INT
                             ,INPUT iiYpos AS INT
                             ,INPUT iiWidth  AS INT
                             ,INPUT iiHeight AS INT
                             ,INPUT icColor  AS CHAR):
     
    IF icColor NE "" THEN 
      RUN vpr_DefRect IN hHelper (iiXpos,iiYpos,iiWidth,iiHeight,"fill",icColor). /* "128,128,128" or color-name */
    ELSE        
      RUN vpr_DefRect IN hHelper (iiXpos,iiYpos,iiWidth,iiHeight,"",""). 
  END METHOD.

  METHOD PUBLIC VOID defRndRect (INPUT iiXpos AS INT
                                ,INPUT iiYpos AS INT
                                ,INPUT iiWidth  AS INT
                                ,INPUT iiHeight AS INT
                                ,INPUT icColor  AS CHAR):
     
    IF icColor NE "" THEN 
      RUN vpr_DefRndRect IN hHelper (iiXpos,iiYpos,iiWidth,iiHeight,"fill",icColor). /* "128,128,128" or color-name */
    ELSE        
      RUN vpr_DefRndRect IN hHelper (iiXpos,iiYpos,iiWidth,iiHeight,"",""). 
  END METHOD.

  METHOD PUBLIC VOID setGraphObject (INPUT icObjectName AS CHAR
                                    ,INPUT icGroupName  AS CHAR
                                    ,INPUT icType       AS CHAR    
                                    ,INPUT iiXpos AS INT
                                    ,INPUT iiYpos AS INT
                                    ,INPUT iiWidth AS INT
                                    ,INPUT iiHeight AS INT
                                    ,INPUT icAttribs AS CHAR
                                    ).
    RUN vpr_SetGraphObj IN hHelper (icObjectName,icGroupName,icType,iiXpos,iiYpos,iiWidth,iiHeight,icAttribs).
    RUN vpr_FlushGroup IN hHelper (icGroupName).
  END METHOD.
  
  METHOD PUBLIC VOID setPrinter (INPUT icPrinter AS CHAR).
    
    RUN vpr_SelectPrinter IN hHelper (icPrinter).
  END METHOD.

  METHOD PUBLIC VOID stopViper ().
    
    RUN vpr_ViperOff IN hHelper.
  END METHOD.


/*
  METHOD PUBLIC CHARACTER TextToFile (icText AS LONGCHAR,icFileName AS CHAR,INPUT ibOpen AS LOG).
    THIS-OBJECT:TextToFile(icText,icFileName).
    RETURN DYNAMIC-FUNCTION("setWebDoc","open",icFileName). 
  END.

  METHOD PUBLIC LOGICAL ToExcel (ihHandle AS HANDLE).
    IF VALID-HANDLE(ihHandle) THEN DO:
      RUN toExcelViaFile.p (ihHandle,0).
      RETURN YES.
    END.  
    ELSE RETURN NO.
  END.

  METHOD PUBLIC INTEGER spawnProwin (INPUT icProcedure AS CHAR
                                    ,INPUT icParameter AS CHAR):
                        
    DEF VAR cProwc      AS CHAR NO-UNDO.
    DEF VAR cInifile    AS CHAR NO-UNDO.
    DEF VAR cAssemblies AS CHAR NO-UNDO.
    DEF VAR cSmallS     AS CHAR NO-UNDO.
    DEF VAR cPf         AS CHAR NO-UNDO.
    DEF VAR oStartInfo  AS System.Diagnostics.ProcessStartInfo NO-UNDO.
    DEF VAR oProcess    AS System.Diagnostics.Process NO-UNDO.
    
    cProwc = DYNAMIC-FUNCTION("getMyExeFile") NO-ERROR.
    
    IF cProwc = "" OR cProwc = ? THEN DO:
      IF PROGRESS = "FULL" THEN 
        FILE-INFO:FILE-NAME = IF SEARCH("prowin32.exe") NE ? THEN SEARCH("prowin32.exe") ELSE SEARCH("prowin.exe"). 
      ELSE 
        FILE-INFO:FILE-NAME = SEARCH("prowc.exe").        
      cProwc = '"' + FILE-INFO:FULL-PATHNAME + '"'.  
    END.
        
    IF cProwc = ? THEN DO:
      MESSAGE "Couldn't find startup Progress executable"
      VIEW-AS ALERT-BOX.
      RETURN 0.
    END.  
    
    IF SEARCH(icProcedure) = ? THEN icProcedure = SUBSTR(icProcedure,1,LENGTH(icProcedure) - 1) + "r".
    IF SEARCH(icProcedure) = ? THEN DO:
      MESSAGE "Couldn't find startup procedure " icProcedure
      VIEW-AS ALERT-BOX.
      RETURN 0.
    END.  
    
    icProcedure = SEARCH(icProcedure).
    
    cSmallS = DYNAMIC-FUNCTION("getStartupParam","-s").
    cAssemblies = DYNAMIC-FUNCTION("getStartupParam","-assemblies").
    cPf = DYNAMIC-FUNCTION("getStartupParam","-pf").
    cInifile = DYNAMIC-FUNCTION("getMyIniFile").
    IF cInifile NE "" THEN cInifile = "-ininame " + cInifile.     
        
     /* Courtesy Mike Fechner, "extreme desktop integration": */
    oStartInfo = NEW System.Diagnostics.ProcessStartInfo().
    oStartInfo:FileName = cProwc.
    oStartInfo:Arguments = cInifile + ' ' + cPf + ' ' + cSmallS + ' ' + cAssemblies + ' -p ' + icProcedure + ' -nosplash -debugalert -wy -param "' + icParameter + '" -T ' + SESSION:TEMP-DIR.
    oStartInfo:WorkingDirectory = System.Environment:CurrentDirectory.
    /* optionally obtain access to stdout of the process */
    oStartInfo:UseShellExecute = NO.
    oStartInfo:RedirectStandardOutput = YES.
     
    oProcess = System.Diagnostics.Process:Start (oStartInfo).
    
    RETURN oProcess:Id.
  END METHOD.
    
  METHOD PUBLIC LOGICAL ActivePid (INPUT iiPid AS INT):
    DEFINE VARIABLE hProcess AS System.Diagnostics.Process EXTENT.
    DEFINE VARIABLE ix       AS INTEGER                    NO-UNDO.

    hProcess = System.Diagnostics.Process:GetProcesses().
    DO ix = 1 TO EXTENT (hProcess):
      IF hProcess[ix]:Id = iiPid THEN RETURN YES.
    END. 
    RETURN NO.  
    
  END METHOD.  
  


  METHOD PUBLIC HANDLE StartChildTab (icProcName     AS CHAR
                                     ,icTabTitle     AS CHAR
                                     ,ibNew          AS LOG).
    DEF VAR ohWinHandle    AS HANDLE NO-UNDO.
  
    PUBLISH "StartChildTab" FROM SOURCE-PROCEDURE(icProcName,icTabTitle,SOURCE-PROCEDURE,ibNew,NO,"",OUTPUT ohWinHandle).
  
    RETURN ohWinHandle.
    
  END METHOD.

  METHOD PUBLIC HANDLE StartChildTab (icProcName     AS CHAR
                                     ,icTabTitle     AS CHAR).
    DEF VAR ohWinHandle    AS HANDLE NO-UNDO.
  
    PUBLISH "StartChildTab" FROM SOURCE-PROCEDURE(icProcName,icTabTitle,SOURCE-PROCEDURE,NO,NO,"",OUTPUT ohWinHandle).
  
    RETURN ohWinHandle.
    
  END METHOD.

  METHOD PUBLIC HANDLE StartChildTab (icProcName     AS CHAR).
    DEF VAR ohWinHandle    AS HANDLE NO-UNDO.
  
    PUBLISH "StartChildTab" FROM SOURCE-PROCEDURE(icProcName,"",SOURCE-PROCEDURE,NO,NO,"",OUTPUT ohWinHandle).
  
    RETURN ohWinHandle.
    
  END METHOD.
  
  METHOD PUBLIC VOID ViewMessage (icMessage     AS CHAR).
    DYNAMIC-FUNCTION("DoMessage",0,0,icMessage,"","").
  END METHOD.
  METHOD PUBLIC VOID ViewMessage (iiMsgNum      AS INT
                                 ,icMessage     AS CHAR).
    DYNAMIC-FUNCTION("DoMessage",iiMsgNum,0,icMessage,"","").
  END METHOD.
  METHOD PUBLIC VOID ViewMessage (iiMsgNum      AS INT
                                 ,icMessage     AS CHAR
                                 ,icTitle       AS CHAR).
    DYNAMIC-FUNCTION("DoMessage",iiMsgNum,0,icMessage,icTitle,"").
  END METHOD.
  
  METHOD PUBLIC LOGICAL ViewQuestionYesNo (icQuestion AS CHAR).
    RETURN DYNAMIC-FUNCTION("DoMessage",0,4,icQuestion,"","") = 6.
  END METHOD.
  METHOD PUBLIC LOGICAL ViewQuestionYesNo (iiMsgNum   AS INT
                                          ,icQuestion AS CHAR).
    RETURN DYNAMIC-FUNCTION("DoMessage",iiMsgNum,4,icQuestion,"","") = 6.
  END METHOD.
  METHOD PUBLIC LOGICAL ViewQuestionYesNo (iiMsgNum   AS INT
                                          ,icQuestion AS CHAR
                                          ,icTitle    AS CHAR).
    RETURN DYNAMIC-FUNCTION("DoMessage",iiMsgNum,4,icQuestion,icTitle,"") = 6.
  END METHOD.

  METHOD PUBLIC INTEGER ViewQuestionYesNoCancel (icQuestion AS CHAR).
    DEF VAR iReturn AS INT NO-UNDO. 
    iReturn = DYNAMIC-FUNCTION("DoMessage",0,3,icQuestion,"","").
    CASE iReturn:
      WHEN 6 THEN RETURN 1.
      WHEN 7 THEN RETURN 2.
      WHEN 2 THEN RETURN 3.
    END CASE.  
  END METHOD.
  METHOD PUBLIC INTEGER ViewQuestionYesNoCancel (iiMsgNum   AS INT
                                                ,icQuestion AS CHAR).
    DEF VAR iReturn AS INT NO-UNDO. 
    iReturn = DYNAMIC-FUNCTION("DoMessage",iiMsgNum,3,icQuestion,"","").
    CASE iReturn:
      WHEN 6 THEN RETURN 1.
      WHEN 7 THEN RETURN 2.
      WHEN 2 THEN RETURN 3.
    END CASE.  
  END METHOD.
  METHOD PUBLIC INTEGER ViewQuestionYesNoCancel (iiMsgNum   AS INT
                                                ,icQuestion AS CHAR
                                                ,icTitle    AS CHAR).
    DEF VAR iReturn AS INT NO-UNDO. 
    iReturn = DYNAMIC-FUNCTION("DoMessage",iiMsgNum,3,icQuestion,icTitle,"").
    CASE iReturn:
      WHEN 6 THEN RETURN 1.
      WHEN 7 THEN RETURN 2.
      WHEN 2 THEN RETURN 3.
    END CASE.  
  END METHOD.

  METHOD PUBLIC LOGICAL ViewQuestionOkCancel (icQuestion AS CHAR).
    RETURN DYNAMIC-FUNCTION("DoMessage",0,1,icQuestion,"","") = 1.
  END METHOD.
  METHOD PUBLIC LOGICAL ViewQuestionOkCancel (iiMsgNum   AS INT
                                          ,icQuestion AS CHAR).
    RETURN DYNAMIC-FUNCTION("DoMessage",iiMsgNum,1,icQuestion,"","") = 1.
  END METHOD.
  METHOD PUBLIC LOGICAL ViewQuestionOkCancel (iiMsgNum   AS INT
                                          ,icQuestion AS CHAR
                                          ,icTitle    AS CHAR).
    RETURN DYNAMIC-FUNCTION("DoMessage",iiMsgNum,2,icQuestion,icTitle,"") = 1.
  END METHOD.
  METHOD PUBLIC CHARACTER getFiles (INPUT icFilterList       AS CHAR
                                   ,INPUT icInitialDirectory AS CHAR
                                   ,INPUT icDialogTitle      AS CHAR):
                        
    RETURN DYNAMIC-FUNCTION("SelectFileNames",icFilterList,icInitialDirectory,icDialogTitle).
  END METHOD.
  
  METHOD PUBLIC CHARACTER getFiles ():
                        
    RETURN DYNAMIC-FUNCTION("SelectFileNames","","","").
  END METHOD.
  
  METHOD PUBLIC LOGICAL StartLogMgr (icLogFile AS CHAR):
    
    IF SEARCH("log-manager-report.p") = ? THEN RETURN NO.

    LOG-MANAGER:CLOSE-LOG() NO-ERROR.
    
    IF icLogFile = "source-proc" THEN
      cLogFile = SESSION:TEMP-DIR + hSourceProc:FILE-NAME + ".log".
    ELSE cLogFile = icLogFile.
    LOG-MANAGER:LOGFILE-NAME    = cLogFile. 
    LOG-MANAGER:LOG-ENTRY-TYPES = "4gltrace:4".
    LOG-MANAGER:CLEAR-LOG().
    LOG-MANAGER:LOGGING-LEVEL   = 4.
    
    RETURN YES.
    
  END METHOD.  

  METHOD PUBLIC LOGICAL StartLogMgr ():
    hSourceProc = SOURCE-PROCEDURE.
    RETURN THIS-OBJECT:StartLogMgr("source-proc").
  END.  

  METHOD PUBLIC LOGICAL ViewLogMgrResult ():
    
    IF SEARCH("log-manager-report.p") = ? THEN RETURN NO.

    LOG-MANAGER:CLOSE-LOG().

    RUN log-manager-report.p (cLogFile,cLogFile + ".txt").
    OS-COMMAND NO-WAIT VALUE("notepad " + cLogFile + ".txt").
    
    RETURN YES.
  END.
*/                               
  DESTRUCTOR PUBLIC JBoxViperReport ( ):
//    RUN stopViper IN hHelper.
    RUN vpr_ViperOff IN hHelper NO-ERROR.
    
    DELETE PROCEDURE hHelper NO-ERROR.
  END DESTRUCTOR.
END CLASS.
  
