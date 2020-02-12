 /******************************************************************************

    Program:        w2form.p
    
    Description:    This program illustrates how to open the W2 Form .
                    

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}
   
DEFINE VARIABLE iPage AS INTEGER NO-UNDO.

/* Create a new output document */
RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/fw2-2005-out.pdf").

RUN pdf_set_parameter("Spdf","UseExternalPageSize","TRUE").

/* Compress the contents */
RUN pdf_set_parameter("Spdf","Compress","TRUE").

/* Open the blank Bill-of-Lading template */
RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/fw2-2005.pdf","W2"). 

RUN DoNewPage (1).
RUN DoNewPage (2).
RUN DoNewPage (3).
RUN DoNewPage (4).
RUN DoNewPage (5). /* Error when reading the document */
RUN DoNewPage (6).
RUN DoNewPage (7).  /* Error when reading the document */
RUN DoNewPage (8).
RUN DoNewPage (9).  /* Error when reading the document */
RUN DoNewPage (10).
RUN DoNewPage (11).  /* READS PAGE BUT ERROR OCCURS WHEN DISPLAYING PAGE 11 */

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* ------------------- INTERNAL PROCEDURES ------------------------- */
PROCEDURE DoNewPage:
  DEFINE INPUT PARAMETER pPage  AS INTEGER NO-UNDO.

  RUN pdf_new_page("Spdf").
  RUN pdf_use_PDF_page("Spdf","W2",pPage). 
END.

/* end of w2form.p */
 

