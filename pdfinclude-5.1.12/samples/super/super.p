/******************************************************************************

    Program:        super.p
    
    Description:    This program illustrates how you can run PDFinclude as a
                    Session Super Procedure. This allows you to define 
                    PDFinclude only once and allows you to reuse the functions
                    in many different programs.
                    
                    Note: When using as a Session you should delete the
                          h_PDFinc handle at your initiating program when done
                          (see below).

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i }

RUN samples/super/super-1.p.
RUN samples/super/super-2.p.
RUN samples/super/super-3.p.

IF ENTRY(1, PROGRAM-NAME(2), " ") <> "testRun" /* 13-MAY-2014 jcc: do not kill pdf_inc.p when doing the unit tests */
  AND VALID-HANDLE(h_PDFinc) THEN
    DELETE PROCEDURE h_PDFinc.

/* end of super.pdf */
