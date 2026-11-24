
/*------------------------------------------------------------------------
    File        : tt_schema.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Thu Jun 29 23:35:41 CEST 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


DEF {1} TEMP-TABLE tt_db NO-UNDO
    FIELD cLDBname     AS CHAR
    FIELD cDbType      AS CHAR
    FIELD cConnection  AS CHAR
    FIELD cSourceName  AS CHAR
    FIELD cSourceType  AS CHAR
    FIELD cSourceHost  AS CHAR
    FIELD iTableCnt    AS INT
    FIELD iUsrTableCnt AS INT
    FIELD iDbNum       AS INT
    FIELD hServer      AS HANDLE
    INDEX idxDbNum IS PRIMARY UNIQUE iDbNum.

DEF {1} TEMP-TABLE tt_file NO-UNDO
    FIELD cFile-Name    AS CHAR
    FIELD cTbl-Type     AS CHAR
    FIELD cLDBname      AS CHAR
    FIELD cType         AS CHAR /* table / view */
    FIELD iFileNum      AS INT
    FIELD iDbNum        AS INT
    FIELD cSqlTableName AS CHAR
    FIELD cJsonFileName AS CHAR
    FIELD hTempTable    AS HANDLE
    INDEX DbNum   iDbNum
    INDEX FileNum IS PRIMARY UNIQUE iFileNum.
    
DEF {1} TEMP-TABLE tt_field NO-UNDO
    FIELD cField-Name   AS CHAR
    FIELD cData-Type    AS CHAR
    FIELD cFormat       AS CHAR
    FIELD cLabel        AS CHAR
    FIELD iOrder        AS INT
    FIELD iExtent       AS INT
    FIELD iFileNum      AS INT
    FIELD iFieldNum     AS INT
    FIELD iDbNum        AS INT
    FIELD cSqlFieldName AS CHAR
    FIELD cSqlDataType  AS CHAR
    INDEX FileNum iFileNum
    INDEX DbNum   iDbNum
    INDEX FieldName cField-Name
    INDEX FieldNum IS PRIMARY UNIQUE iFieldNum iFileNum.
    
DEF {1} TEMP-TABLE tt_index NO-UNDO 
    FIELD cIndex-name AS CHAR
    FIELD bActive     AS LOG
    FIELD bUnique     AS LOG
    FIELD iFileNum    AS INT
    FIELD iIdxNum     AS INT
    FIELD cCode       AS CHAR
    INDEX FileNum iFileNum
    INDEX IdxNum IS PRIMARY UNIQUE iIdxNum iFileNum.
    
DEF {1} TEMP-TABLE tt_index-field NO-UNDO
    FIELD iFileNum    AS INT
    FIELD iIdxNum     AS INT
    FIELD iFieldNum   AS INT
    FIELD cFieldName  AS CHAR
    FIELD iIdxSeq     AS INT
    INDEX FileNum iFileNum
    INDEX FieldNum iFieldNum
    INDEX IdxNum IS PRIMARY UNIQUE iIdxSeq iIdxNum iFileNum.
    
DEF {1} TEMP-TABLE tt_sequence NO-UNDO
    FIELD cSeq-name   AS CHAR
    FIELD cLDBname    AS CHAR
    FIELD iDbNum      AS INT
    INDEX IdxSeq IS PRIMARY UNIQUE iDbNum cLDBname cSeq-name.
    .

DEF DATASET dsSchema FOR tt_db, tt_file, tt_field, tt_index, tt_index-field, tt_sequence.
DEF VAR hdsSchema AS HANDLE NO-UNDO.