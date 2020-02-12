/******************************************************************************

    Program:        freeservicing2.p
    
    Description:    

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/FreeServicing2.pdf").

RUN pdf_set_parameter("Spdf", "unitTest", "TRUE").

RUN pdf_set_parameter("Spdf", "UseExternalPageSize", "TRUE").
/* RUN pdf_set_parameter("Spdf", "retainAcroForm", "TRUE"). */

RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/FreeServicing2.pdf","fs").

/* copy info from the template */
RUN pdf_set_info('Spdf', "Author", pdf_get_pdf_info("Spdf","fs","Author")).
RUN pdf_set_info('Spdf', "Title", pdf_get_pdf_info("Spdf","fs","Title")).

RUN pdf_set_info('Spdf', "Producer", "PDFInclude").

RUN pdf_new_page("Spdf").
RUN pdf_use_PDF_page("Spdf","fs",1).

/* Use the following to know widget presents on the form */
/* DEFINE VARIABLE cWidgets AS CHARACTER  NO-UNDO. */
/* RUN pdf_get_widgets('Spdf', OUTPUT cWidgets).   */
/* MESSAGE cWidgets                                */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.          */
/* SalesExec,1,/Tx,251.973 116.243 401.973 138.243,  */
/* Date,1,/Tx,440.29 174.595 590.29 196.595,         */
/* Date,1,/Tx,439.406 117.128 589.406 139.128,       */
/* Date,1,/Tx,57.4676 549.46 207.468 571.46,         */
/* CustName,1,/Tx,86.6434 519.401 236.643 541.401,   */
/* CustFull,1,/Tx,58.3517 672.353 208.352 694.353,   */
/* Add1,1,/Tx,58.3517 650.25 208.352 672.25,         */
/* Add2,1,/Tx,58.3517 628.147 208.352 650.147,       */
/* Add3,1,/Tx,58.3517 606.044 208.352 628.044,       */
/* CustFL,1,/Tx,251.973 173.711 401.973 195.711,     */
/* DealerName,1,/Tx,275.844 356.723 425.844 378.723, */
/* DealerName,1,/Tx,383.706 784.635 533.706 806.635, */
/* DAdd1,1,/Tx,383.706 762.533 533.706 784.533,      */
/* DAdd2,1,/Tx,383.706 740.43 533.706 762.43,        */
/* DPcode,1,/Tx,383.706 718.327 533.706 740.327,     */
/* Pcode,1,/Tx,58.3517 583.941 208.352 605.941       */

RUN pdf_fill_text("Spdf","Date","06/08/1972","").
RUN pdf_fill_text("Spdf","CustName","Dilbert","").
RUN pdf_fill_text("Spdf","CustFull","Dilbert","").
RUN pdf_fill_text("Spdf","Add1","Alien road, 1728","").
RUN pdf_fill_text("Spdf","DealerName","Pointy-Haired Boss","").
RUN pdf_fill_text("Spdf","DAdd1","Eunice street, 144","").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of freeservicing.p */
/*
OUTPUT TO "clipboard".
FOR EACH TT_Object WHERE TT_Object.stream_obj = 0
    BY TT_Object.obj_ptr :
    DISP TT_Object.obj_id TT_Object.obj_ptr TT_Object.stream_idx TT_Object.stream_obj.
END.
FOR EACH TT_Object WHERE TT_Object.stream_obj > 0: 
    DISP TT_Object.obj_id TT_Object.obj_ptr TT_Object.stream_idx TT_Object.stream_obj.
END.
OUTPUT CLOSE.

----------obj_id ---------obj_ptr ------stream_idx -----stream_obj-

        13               15                0                0
        18              115                0                0
        41              458                0                0
        14              607                0                0
        15              732                0                0
        16            3.833                0                0
        17            4.645                0                0
         1            7.573                0                0
         2            8.365                0                0
         3           12.197                0                0
         4           12.501                0                0
         5           12.720                0                0

----------obj_id ---------obj_ptr ------stream_idx -----stream_obj-

         6            6.042                0                1
         7            6.125                1                1
         8            6.207                2                1
         9            6.299                3                1
        10            6.378                4                1
        11           12.141                0                3
        12           12.339                0                4
        19              921                0               16
        20            1.135                1               16
        21            1.268                2               16
        22            1.409                3               16
        23            1.552                4               16
        24            1.693                5               16
        25            1.837                6               16
        26            1.983                7               16
        27            2.123                8               16
        28            2.265                9               16
        29            2.407               10               16
        30            2.550               11               16
        31            2.689               12               16
        32            2.835               13               16
        33            2.976               14               16
        34            3.120               15               16
        35            3.259               16               16
        36            3.405               17               16
        37            3.545               18               16
        38            3.600               19               16
        39            3.644               20               16
        40            3.736               21               16
*/
