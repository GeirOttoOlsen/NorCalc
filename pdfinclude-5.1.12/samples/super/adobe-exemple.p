/******************************************************************************

    Program:        adobe-exemple.p
    
    Description:    

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

/* DEFINE VARIABLE iFirst  AS INTEGER   NO-UNDO. */
/* DEFINE VARIABLE iSecond AS INTEGER   NO-UNDO. */
/* ETIME(TRUE). */

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/adobe-exemple.pdf").

RUN pdf_set_parameter("Spdf","unitTest","TRUE").
RUN pdf_set_parameter("Spdf","reuseExternal","TRUE").
/* RUN pdf_set_parameter("spdf", "retainAcroForm", "TRUE"). */
/* RUN pdf_set_parameter("spdf", "formFlatten", ""). */
RUN pdf_set_parameter("spdf", "retainAnnots", "Link").
/* RUN pdf_set_parameter("spdf", "retainAnnots", "*"). */

RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/adobe-exemple.pdf","fs").

RUN pdf_new_page("Spdf").
RUN pdf_use_PDF_page("Spdf","fs",1).

RUN pdf_fill_text("Spdf","Name_First","Pointy","").
RUN pdf_fill_text("Spdf","Name_Last","Haired-Boss","").
RUN pdf_fill_text("Spdf","Address_1","Eunice street","").
RUN pdf_fill_text("Spdf","Birthdate","25/12/1969","").
RUN pdf_fill_text("Spdf","SSN","12345678","").

RUN pdf_fill_text("Spdf","TRADE CERTIFICATE","On","").
RUN pdf_fill_text("Spdf","Sex","MALE","").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE "1" RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* iFirst = ETIME. */
/* ETIME(TRUE). */

/* 20-MAY-2014 jcc: reuse the template */

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/adobe-exemple2.pdf").
RUN pdf_set_parameter("Spdf","unitTest","TRUE").
/* RUN pdf_set_parameter("spdf", "formFlatten", ""). */
RUN pdf_set_parameter("spdf", "retainAnnots", "Link").
RUN pdf_set_parameter("Spdf","reuseExternal","TRUE").
RUN pdf_new_page("Spdf").
/* we reuse the "fs" template, without a call to pdf_open_PDF */
RUN pdf_use_PDF_page("Spdf","fs",1).
RUN pdf_fill_text("Spdf","Name_First","Dil","").
RUN pdf_fill_text("Spdf","Name_Last","Bert","").
RUN pdf_fill_text("Spdf","Address_1","Dilbert street","").
RUN pdf_fill_text("Spdf","Birthdate","25/12/1972","").
RUN pdf_fill_text("Spdf","SSN","98765432","").
RUN pdf_fill_text("Spdf","HIGH SCHOOL DIPLOMA","On","").
RUN pdf_fill_text("Spdf","Sex","MALE","").
RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE "2" RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
/* iSecond = ETIME. */
/* ETIME(TRUE). */

/* reuse it again! */
RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/adobe-exemple3.pdf").
RUN pdf_set_parameter("Spdf","unitTest","TRUE").
/* RUN pdf_set_parameter("spdf", "formFlatten", ""). */
RUN pdf_set_parameter("spdf", "retainAnnots", "Link").
/* RUN pdf_set_parameter("Spdf","reuseExternal","TRUE"). */ /* as it is the last one, do not set the parameter so that the cleanup will be done */
RUN pdf_new_page("Spdf").
/* we reuse the "fs" template, without a call to pdf_open_PDF */
RUN pdf_use_PDF_page("Spdf","fs",1).
RUN pdf_fill_text("Spdf","Name_First","Homer","").
RUN pdf_fill_text("Spdf","Name_Last","Simpson","").
RUN pdf_fill_text("Spdf","City","Springfield","").
RUN pdf_fill_text("Spdf","Birthdate","1/5/1968","").
RUN pdf_fill_text("Spdf","SSN","00000001","").
RUN pdf_fill_text("Spdf","BACHELORS DEGREE","On","").
RUN pdf_fill_text("Spdf","Sex","MALE","").
RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE "3" RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
/*
MESSAGE "1st execution:" iFirst SKIP
    "2nd execution:" iSecond SKIP
    "3rd execution:" ETIME
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
/* Use the following to know widget presents on the form */
/* DEFINE VARIABLE cWidgets AS CHARACTER  NO-UNDO. */
/* RUN pdf_get_widgets('Spdf', OUTPUT cWidgets).   */
/* MESSAGE cWidgets                                */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.          */
/* HIGH SCHOOL DIPLOMA,1,/Btn,checkbox,29.4 139.44 36.72 146.76,, */
/* TRADE CERTIFICATE,1,/Btn,checkbox,29.4 127.32 36.72 134.64,,   */
/* COLLEGE NO DEGREE,1,/Btn,checkbox,29.4 115.2 36.72 122.4,,     */
/* PHD,1,/Btn,checkbox,29.4 54.24 36.72 61.56,,                   */
/* OTHER DOCTORATE,1,/Btn,checkbox,29.4 42.12 36.72 49.44,,       */
/* ASSOCIATES DEGREE,1,/Btn,checkbox,65.4 102.96 72.72 110.28,,   */
/* MASTERS DEGREE,1,/Btn,checkbox,65.4 78.6 72.72 85.92,,         */
/* PROFESSIONAL DEGREE,1,/Btn,checkbox,65.4 66.48 72.72 73.68,,   */
/* STATE,1,/Tx,465.84 353.04 486.12 371.76,,                      */
/* ZIP,1,/Tx,494.52 353.04 582.12 371.76,,                        */
/* EMPLOYEE SIGNATURE,1,/Sig,338.593 83.52 579.037 102.24,,       */
/* Name_Last,1,/Tx,30.12 400.92 272.76 419.64,,                   */
/* Name_First,1,/Tx,30.12 376.8 272.76 391.44,,                   */
/* Name_Middle,1,/Tx,30.12 352.8 176.76 367.2,,                   */
/* Name_Suffix,1,/Tx,186.84 352.8 224.76 371.52,,                 */
/* Name_Prefix,1,/Tx,234.84 352.8 272.76 371.52,,                 */
/* Telephone_Home,1,/Tx,30.12 280.68 146.4 299.4,,                */
/* Telephone_Work,1,/Tx,156.48 280.68 272.76 299.4,,              */
/* SSN,1,/Tx,30.12 183.84 272.76 202.56,,                         */
/* BACHELORS DEGREE,1,/Btn,checkbox,65.4 90.72 72.72 98.04,,      */
/* Address_1,1,/Tx,339.48 400.92 582.12 419.64,,                  */
/* Address_2,1,/Tx,339.48 377.28 582.12 391.44,,                  */
/* City,1,/Tx,339.36 352.8 456.12 371.52,,                        */
/* Emergency_Phone,1,/Tx,339.36 280.68 582 299.4,,                */
/* Emergency_Contact,1,/Tx,339.36 256.44 455.64 271.32,,          */
/* Emergency_Relationship,1,/Tx,465.72 256.44 582 275.16,,        */
/* Sex,1,/Btn,radio,339.36 190.8 346.44 197.88,,                  */
/* Sex,1,/Btn,radio,339.36 178.68 346.44 185.64,,                 */
/* Birthdate,1,/Tx,436.56 187.8 507.12 206.52,,                   */
/* Print,1,/Btn,339.786 30.2243 422.374 48.7056,                  */

/* end of adobe-exemple.p */
