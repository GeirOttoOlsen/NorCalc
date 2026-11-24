
/*------------------------------------------------------------------------
    File        : JBoxSchemaCacheGlobal.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : brynj
    Created     : Thu Feb 20 01:57:47 CET 2025
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
{tt_schema.i SHARED}

hdsSchema = DATASET dsSchema:HANDLE.

SUBSCRIBE TO "getIsCachedTempTable" ANYWHERE.

PROCEDURE refreshGlobal:
  DEF INPUT PARAM ihDsSchema AS HANDLE NO-UNDO.
    
  hdsSchema:COPY-DATASET (ihDsSchema,YES,YES,YES).
    
END PROCEDURE.  

PROCEDURE createTempTable:
  DEF INPUT  PARAM iiFileNum     AS INT    NO-UNDO.
  DEF INPUT  PARAM ihTempTable   AS HANDLE NO-UNDO.
  DEF INPUT  PARAM icExtraFields AS CHAR   NO-UNDO.
  DEF OUTPUT PARAM ohTempTable   AS HANDLE NO-UNDO.
    
  DEF VAR ix AS INT NO-UNDO.
    
  IF ihTempTable:TYPE = "buffer" THEN ihTempTable = ihTempTable:TABLE-HANDLE.  
  
  FIND FIRST tt_file
       WHERE tt_file.iFileNum = iiFileNum
       NO-ERROR.
  IF AVAIL tt_file THEN DO:
    CREATE TEMP-TABLE tt_file.hTempTable.
    tt_file.hTempTable:CREATE-LIKE(ihTempTable).
    DO ix = 1 TO NUM-ENTRIES(icExtraFields):
      IF NUM-ENTRIES(ENTRY(ix,icExtraFields),";") > 2 THEN
        tt_file.hTempTable:ADD-NEW-FIELD (ENTRY(1,ENTRY(ix,icExtraFields),";"),ENTRY(2,ENTRY(ix,icExtraFields),";"),0,REPLACE(ENTRY(3,ENTRY(ix,icExtraFields),";"),"<",",")).
      ELSE  
        tt_file.hTempTable:ADD-NEW-FIELD (ENTRY(1,ENTRY(ix,icExtraFields),";"),ENTRY(2,ENTRY(ix,icExtraFields),";")).
    END.  
    tt_file.hTempTable:TEMP-TABLE-PREPARE (ihTempTable:NAME).     
    tt_file.hTempTable:COPY-TEMP-TABLE (ihTempTable,NO,NO,YES).
    ohTempTable = tt_file.hTempTable.
  END.   
  CATCH eErr AS Progress.Lang.Error :
    MESSAGE PROGRAM-NAME(1) eErr:GetMessage(1)
    VIEW-AS ALERT-BOX.  
  END CATCH.
END.  

PROCEDURE deleteFile:
  DEF INPUT PARAM iiDbNum     AS INT NO-UNDO.
  DEF INPUT PARAM icTableName AS CHAR NO-UNDO.

  FOR EACH tt_db WHERE tt_db.iDbNum = iiDbNum  
     ,EACH tt_file
      WHERE tt_file.iDbNum = tt_db.iDbNum
        AND tt_file.cFile-Name = icTableName
      :
    FOR EACH tt_field
        WHERE tt_field.iFileNum = tt_file.iFileNum
        :      
      DELETE tt_field.
    END.
    FOR EACH tt_index
        WHERE tt_index.iFileNum = tt_file.iFileNum
        :
      FOR EACH tt_index-field
          WHERE tt_index-field.iFileNum = tt_file.iFileNum
            AND tt_index-field.iIdxNum = tt_index.iIdxNum
          :
        DELETE tt_index-field.
      END.
      DELETE tt_index.
    END.
    DELETE tt_file.
    tt_db.iUsrTableCnt = tt_db.iUsrTableCnt - 1.  
  END.           

END PROCEDURE.  

PROCEDURE getIsCachedTempTable:
  DEF INPUT PARAM ihTempTable AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM obCached   AS LOG NO-UNDO.
  
  FOR EACH tt_db
      WHERE CAN-DO("tempdata,datafjord",tt_db.cSourceName)
     ,EACH tt_file
           WHERE tt_file.iDbNum = tt_db.iDbNum
             AND tt_file.hTempTable = ihTempTable
      :
    IF VALID-HANDLE(tt_file.hTempTable) THEN DO:
      obCached = YES.
      LEAVE.
    END.
  END.            
END PROCEDURE.  