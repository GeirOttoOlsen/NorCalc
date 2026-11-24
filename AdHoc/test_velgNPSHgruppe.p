
/*------------------------------------------------------------------------
    File        : test_velgNPSHgruppe.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Mon Feb 19 15:55:09 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */


/***

    CASE koblings_alternativ:
        WHEN '5' OR WHEN '6' OR WHEN '7'  THEN
            DO:
                c_kapasitet = DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE).
                c_grunnlag = 'Sekundærkrets'.
            END.
         OTHERWISE
            DO:
                c_kapasitet = DECIMAL(NPSHSYST.prim_kapasitet:SCREEN-VALUE).
                c_grunnlag = 'Primærkrets'.
            END.
    END CASE.
    CASE  NPSHSYST.type:SCREEN-VALUE:
        WHEN  'FM' THEN
           RUN VELGFMDM.W (INPUT-OUTPUT  dimm_verdi, INPUT c_kapasitet, INPUT c_grunnlag).                       
        WHEN  'MS' /*or when 'MSE'*/ THEN
           RUN VELGMSDM.W (INPUT-OUTPUT  dimm_verdi, INPUT c_kapasitet, INPUT c_grunnlag).                       
        WHEN  'MSE' THEN
           RUN VELGMSEDM.W (INPUT-OUTPUT  dimm_verdi, INPUT c_kapasitet, INPUT c_grunnlag).
    END CASE.

***/

def var hC as handle no-undo.

run VelgNPSHgruppe.w persistent set hC.
if not valid-object(hC) then 
  undo, throw new Progress.Lang.AppError('feilet',0).
run InitializeObject in hC.
run MoveToTop in hC.
run setValues in hC ('MS',2,'Primærkrets').

//delete object hC. 