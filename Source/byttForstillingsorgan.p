def buffer b for npshsyst.
def buffer bnpshsyst for npshsyst.
def new shared var anleggsnrParam like npshanl.anleggsnr.
DEFINE new SHARED VAR  systemnrParam LIKE npshsyst.systemnr.

def form f cForstOrg 

find first npshforstilling where forstillingsorgan = 'B-NM24A-SR 2-10V 24V' no-lock.

disp npshforstilling.
for each bnpshsyst no-lock where tillegg_forstilling begins 'B-NM24A-SR 0-10V 24V':
   do trans:
     find first b of bnpshsyst exclusive-lock no-error.
      b.tillegg_forstilling = npshforstilling.forstillingsorgan.
    end.
    find current b no-lock no-error.
    disp transaction b.anleggsnr b.systemnr  b.tillegg_forstilling view-as fill-in.
    anleggsnrParam = b.anleggsnr.
    systemnrParam = b.systemnr.
    run systkode.p.
end.

