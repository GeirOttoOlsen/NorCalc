
/*------------------------------------------------------------------------
    File        : shtilbud_pdf.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Wed Mar 29 11:31:23 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
ROUTINE-LEVEL ON ERROR UNDO, THROW.
def var oCMD as JBoxCMD no-undo.
/***************************** Oppsett ***********************************/
/*** Start instance property definitions for JBoxQuery object oQryNPSPTILBUD ***/
DEF VAR oQryNPSPTILBUD AS JBoxQuery NO-UNDO.

DEF TEMP-TABLE NPSPTILBUD
    FIELD anleggsnr AS integer
    FIELD avgittpris AS decimal
    FIELD bet_bet AS character
    FIELD deres_ref AS character
    FIELD gyldighetstid AS integer
    FIELD id AS integer
    FIELD kundenr AS character
    FIELD lev_bet AS character
    FIELD opplysninger AS character
    FIELD pris AS decimal
    FIELD rabatt% AS decimal
    FIELD tilbudsdato AS date
    FIELD tilbudsid AS integer
    FIELD tilbudsnr AS character
    FIELD vaar_ref AS character
    FIELD aktivt AS logical
    FIELD anbudsfrist AS date
    FIELD anlegg AS character
    FIELD anleggsnr2 AS integer
    FIELD arkivnr AS character
    FIELD beskrevet AS character
    FIELD byggestart AS date
    FIELD dato AS date
    FIELD endrings_laas AS logical
    FIELD entreprise AS character
    FIELD konsulentens_saksbeh AS character
    FIELD konsulentid AS integer
    FIELD kundenr2 AS character
    FIELD leveringsdato AS date
    FIELD leveringstid AS character
    FIELD oppf_aar AS integer
    FIELD oppf_uke AS integer
    FIELD opplysninger2 AS character
    FIELD ordre AS logical
    FIELD prosjektid AS integer
    FIELD referanse_tekst AS character
    FIELD saksbehandler AS character
    FIELD salgsdistrikt AS character
    FIELD selger AS character
    FIELD sikker AS logical
    FIELD standardpris AS decimal
    FIELD adresse1 AS character
    FIELD adresse2 AS character
    FIELD aktiv AS logical
    FIELD avdeling AS character
    FIELD avtale AS character
    FIELD dm_kode AS character
    FIELD er_konsulent AS logical
    FIELD fax AS character
    FIELD fylke AS character
    FIELD katalog_np_antall AS integer
    FIELD katalog_np_dato AS date
    FIELD katalog_np_oppdatert AS date
    FIELD katalog_np_type AS character
    FIELD katalog_nt_antall AS integer
    FIELD katalog_nt_dato AS date
    FIELD katalog_nt_oppdatert AS date
    FIELD katalog_nt_type AS character
    FIELD kilde AS character
    FIELD konsulentnr AS integer
    FIELD kontaktperson_np AS character
    FIELD kontaktperson_nt AS character
    FIELD kontor_type AS character
    FIELD kundedistrikt AS character
    FIELD kundekategori AS character
    FIELD kundenavn AS character
    FIELD kundenr3 AS character
    FIELD kundenr_de AS character
    FIELD kundenr_i AS integer
    FIELD kundenr_sp AS character
    FIELD land AS character
    FIELD mobil AS character
    FIELD organisasjon AS character
    FIELD postnr AS character
    FIELD poststed AS character
    FIELD rabatt%_1 AS decimal
    FIELD rabatt%_2 AS decimal
    FIELD sist_oppdatert AS date
    FIELD telefon AS character
    FIELD tilbudsmottager AS logical
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowCount AS INTEGER
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3
    .
DEFINE BUFFER v_NPSPTILBUD FOR NPSPTILBUD.

FUNCTION getTableHandleQryNPSPTILBUD RETURNS HANDLE().
  RETURN BUFFER NPSPTILBUD:HANDLE:TABLE-HANDLE.
END FUNCTION.
FUNCTION getBuffersAndFieldsQryNPSPTILBUD RETURNS CHARACTER().
  RETURN 
      'NPSPTILBUD'
    + ',NPSPANLG'
    + ',NPKUNDE'.
END FUNCTION.
FUNCTION getQueryJoinQryNPSPTILBUD RETURNS CHARACTER().
  RETURN 'EACH NPSPANLG OF NPSPTILBUD,EACH NPKUNDE OF NPSPTILBUD'.
END FUNCTION.
/*** End instance property settings for JBoxQuery object oQryNPSPTILBUD ***/

/* ***************************  Main Block  *************************** */
  oQryNPSPTILBUD = NEW JBoxQuery('NPSPTILBUD').
  oQryNPSPTILBUD:baseQuery = 'WHERE tilbudsnr = "16.11.4842.1"'.

  oQryNPSPTILBUD:openQuery().

MESSAGE oQryNPSPTILBUD:BUFFER-HANDLE::tilbudsnr
skip oQryNPSPTILBUD:BUFFER-HANDLE::kundenavn
VIEW-AS ALERT-BOX.

{ pdf_inc.i}
run pdf_new ("Spdf","./hello.pdf").

RUN pdf_new_page("Spdf").

run logo.
/* Place some text */

/**
npsptilbud anleggsnr kundenr
npkunde
npspanlg
**/

RUN pdf_skip    ("Spdf").
RUN pdf_text_at ("Spdf", oQryNPSPTilbud:BUFFER-HANDLE::kundenavn,10).
RUN pdf_skip    ("Spdf").
RUN pdf_text_at ("Spdf", oQryNPSPTilbud:BUFFER-HANDLE::adresse1,10).
RUN pdf_skip    ("Spdf").
RUN pdf_text_at ("Spdf", oQryNPSPTilbud:BUFFER-HANDLE::adresse2,10).
RUN pdf_skip    ("Spdf").
RUN pdf_text_at ("Spdf", oQryNPSPTilbud:BUFFER-HANDLE::postnr,10).
RUN pdf_text_at ("Spdf", oQryNPSPTilbud:BUFFER-HANDLE::poststed,17).
RUN pdf_skip    ("Spdf").
RUN pdf_text_at ("Spdf", 'Telefon',10).
RUN pdf_text_at ("Spdf", 'Faks',25).
RUN pdf_skip    ("Spdf").
RUN pdf_text_at ("Spdf", oQryNPSPTilbud:BUFFER-HANDLE::telefon,10).
RUN pdf_text_at ("Spdf", oQryNPSPTilbud:BUFFER-HANDLE::fax,15).

RUN pdf_text_to ("Spdf", "Position TO Column 70",70).
RUN pdf_text    ("Spdf", "Text placed at last X/Y Coordinate").
RUN pdf_skip    ("Spdf").

/* Change the text color to red */
RUN pdf_text_color("Spdf",1.0,.0,.0).

RUN pdf_set_font("Spdf","Courier",14.0).
RUN pdf_text_xy ("Spdf","This is text placed using XY coordinates",100,500).
RUN pdf_set_font("Spdf","Courier",10.0).

/* Change the text color back to black */
RUN pdf_text_color("Spdf",.0,.0,.0).

/* Change the Rectangle border to red and the fill to white */
RUN pdf_stroke_color("Spdf",1.0,.0,.0).
RUN pdf_stroke_fill("Spdf",1.0,1.0,1.0).

/* Display a boxed text string */
RUN pdf_text_boxed_xy ("Spdf",
                   "This is BOXED text placed using XY coordinates",
                   100,
                   450,
                   pdf_text_width("Spdf", "This is BOXED text placed using XY coordinates"),
                   10,"Left",1).

RUN pdf_close("Spdf").

oCMD = new JBoxCMD('C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe','./hello.pdf').

procedure PageHeader:
  RUN pdf_watermark ("Spdf","Tilbud fra NorShunt AS","Courier-Bold",30,.87,.87,.87,20,500).  
end.
procedure PageFooter:
  
end.

procedure logo:
  def var ivPos as int no-undo.
  def var ihPos as int no-undo.
  def var cFirmalogo as char init ".\img\norshuntlogo.jpg" no-undo.

    ivPos = pdf_TextY("Spdf"). 
    ihPos = pdf_TextX("Spdf").
    
  if search(cFirmaLogo) ne ? then
  do:
    RUN pdf_load_image ("Spdf","NorShuntLogo",cFirmalogo).
    RUN pdf_place_image ("Spdf","NorShuntLogo",400,30,200,30).
  end.
  RUN pdf_set_font("Spdf","Courier",14.0).
  RUN pdf_text_xy ("Spdf","Nor-Shunt AS",450,30).
  RUN pdf_set_font("Spdf","Courier",10.0).
  RUN pdf_text_xy ("Spdf","Møllevannsveien 9,",450,30).
  RUN pdf_set_font("Spdf","Courier",10.0).
  

end.
/*PROCEDURE new_page:                                                                                                            */
/*                                                                                                                               */
/*  /* Display Footer UnderLine */                                                                                               */
/*  IF Vpage > 0 THEN                                                                                                            */
/*    RUN page_footer.                                                                                                           */
/*                                                                                                                               */
/*  RUN  pdf_new_page("Spdf").                                                                                                   */
/*                                                                                                                               */
/*  Vpage = Vpage + 1.                                                                                                           */
/*                                                                                                                               */
/*  /* Place Logo but only on first page of Report */                                                                            */
/*  IF Vpage = 1 THEN DO:                                                                                                        */
/*   RUN  pdf_place_image ("Spdf","ProSysLogo",pdf_LeftMargin("Spdf"), pdf_TopMargin("Spdf") - 20 ,179,20).                      */
/*  END.                                                                                                                         */
/*                                                                                                                               */
/*  /* Set Header Font Size and Colour */                                                                                        */
/*  RUN pdf_set_font ("Spdf","Courier-Bold",10.0).                                                                               */
/*  RUN pdf_text_color ("Spdf",1.0,.0,.0).                                                                                       */
/*                                                                                                                               */
/*  /* Put a Rectangle around the Header */                                                                                      */
/*  RUN pdf_stroke_color ("Spdf", .0,.0,.0).                                                                                     */
/*  RUN pdf_stroke_fill ("Spdf", .9,.9,.9).                                                                                      */
/*  RUN pdf_rect ("Spdf", pdf_LeftMargin("Spdf"), pdf_TextY("Spdf") - 3, pdf_PageWidth("Spdf") - 30  , pdf_TextX("Spdf") + 12).  */
/*                                                                                                                               */
/*  /* Output Report Header */                                                                                                   */
/*  RUN pdf_text_at  ("Spdf","St",1).                                                                                            */
/*  RUN pdf_text_at  ("Spdf","Nbr",6).                                                                                           */
/*  RUN pdf_text_at  ("Spdf","Customer Name",12).                                                                                */
/*  RUN pdf_text_at  ("Spdf","Phone Number",44).                                                                                 */
/*  RUN pdf_text_to  ("Spdf","Balance",80).                                                                                      */
/*                                                                                                                               */
/*  /* Display Header UnderLine */                                                                                               */
/*  RUN pdf_skip ("Spdf").                                                                                                       */
/*  RUN pdf_set_dash ("Spdf",1,0).                                                                                               */
/*  RUN pdf_line  ("Spdf", pdf_LeftMargin("Spdf"), pdf_TextY("Spdf") + 5, pdf_PageWidth("Spdf") - 20 , pdf_TextY("Spdf") + 5, 2).*/
/*  RUN pdf_skip ("Spdf").                                                                                                       */
/*                                                                                                                               */
/*  /* Set Detail Font Colour */                                                                                                 */
/*  RUN pdf_text_color ("Spdf",.0,.0,.0).                                                                                        */
/*                                                                                                                               */
/*  Vlines = 3.                                                                                                                  */
/*END. /* new_page */                                                                                                            */

