def new shared var anleggsnrParam like npshanl.anleggsnr.
DEFINE new SHARED VAR  systemnrParam LIKE npshsyst.systemnr.

for each npshsyst where anleggsnr = 7468:
/*   disp tillegg_forstilling view-as fill-in anleggsnr systemnr. */
  anleggsnrparam = anleggsnr.
  systemnrparam = systemnr.
  run systkode.p.
end.
