def new shared var anleggsnrParam like npshanl.anleggsnr.
DEFINE new SHARED VAR  systemnrParam LIKE npshsyst.systemnr.


for each  npshsyst where system_kode matches '*0-10V*' and tillegg_forstilling matches '*2-10V*' no-lock:
disp tillegg_forstilling view-as fill-in format "x(40)" system_kode with width 300 1 col.
find npshanlg of npshsyst no-lock no-error.
disp npshanlg.anleggsnr prosjektid.
/*   anleggsnrparam = anleggsnr. */
/*   systemnrparam = systemnr. */
/*   run systkode.p. */
end.
