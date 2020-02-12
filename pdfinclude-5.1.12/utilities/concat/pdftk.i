DEFINE {1} TEMP-TABLE ttPdfFiles NO-UNDO LABEL "PDF files"
 FIELD file_name     AS CHARACTER LABEL "File name"      FORMAT "X(256)"
 FIELD order         AS INTEGER   
 FIELD id            AS INTEGER   
 FIELD page_count    AS INTEGER   LABEL "Page count" 
 FIELD pages_to_copy AS CHARACTER LABEL "Pages to copy" 
 FIELD pageRotate    AS INTEGER   LABEL "Page Rotate"
 FIELD rotateInPage  AS INTEGER   LABEL "Rotate in page"
 FIELD pageTitle     AS CHARACTER LABEL "Pages Titles"   FORMAT "X(256)"
 INDEX ix file_name order
 .
