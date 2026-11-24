
/*------------------------------------------------------------------------
    File        : JBoxQueryJobbKoScheduler.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : bryhasle
Brynjar
    Created     : Thu Jun 16 10:59:12 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEF INPUT PARAM ioDynDataBrowse AS JBoxDynDataBrowse NO-UNDO.

/*

MESSAGE ioDynDataBrowse:userSettingId skip
        ioDynDataBrowse:userSettingName skip
        ioDynDataBrowse:userSettingContext skip
        ioDynDataBrowse:myQuery
VIEW-AS ALERT-BOX.
*/                                   

DEF VAR cRowIdList  AS CHAR NO-UNDO.
DEF VAR cRunNow     AS CHAR NO-UNDO.

cRowIdList = JBoxServerAPI:Instance:getRowIdList("JobbKoSchedulerItem,JobbKoScheduler",
            "WHERE cItem = '" + ioDynDataBrowse:userSettingId + "',FIRST JobbKoScheduler WHERE JobbKoScheduler.iJobbKoSchedulerId = JobbKoSchedulerItem.iJobbKoSchedulerId").

JBoxServerAPI:Instance:Selector("JobbKoScheduler"
         + ';JobbKoSchedulerNavn'
         + ';iJobbKoSchedulerId'
         + ';JobbKoSchedulerAktiv'
        ,"where JobbKoSchedulerAktiv"
        ,cRowIdList
        ,"iJobbKoSchedulerId").
IF JBoxServerAPI:Instance:SelectorOk THEN DO:
  IF NOT JBoxServerAPI:Instance:CallServerProc("jbadmin_addquery_to_jobbko_schedule.p",JBoxServerAPI:Instance:SelectorReturnValueList + ";" + ioDynDataBrowse:userSettingId + ";" + cRunNow) THEN 
    JBoxServerAPI:Instance:viewCallMessage().
END.      

PROCEDURE mySelectorObject:
  DEF INPUT PARAM ioSelector AS JBoxDynSelector NO-UNDO.
  
//  ioSelector:TOOLBAR-OBJECT:addTool("Filter").
//  ioSelector:ExpandSelectorDialogX(400).
  
  ioSelector:LoadPanel("JBoxQueryScheduleNowPanel.w").
  
  ioSelector:SOURCE-BROWSE-OBJECT:openQuery().
END PROCEDURE.

PROCEDURE getSelectorAttributes :
/*------------------------------------------------------------------------------
  Purpose:     Retrieve value(s) from the selector panel
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM ihBrwSource AS HANDLE NO-UNDO.
DEF INPUT  PARAM ihBrwTarget AS HANDLE NO-UNDO.
DEF INPUT  PARAM icDeSelRows AS CHAR   NO-UNDO.
DEF OUTPUT PARAM oiReturn    AS INT    NO-UNDO.

IF VALID-HANDLE(JBoxServerAPI:Instance:SELECTOR-PANEL-HANDLE) THEN
  cRunNow = DYNAMIC-FUNCTION("getRunNow" IN JBoxServerAPI:Instance:SELECTOR-PANEL-HANDLE).

END PROCEDURE.
