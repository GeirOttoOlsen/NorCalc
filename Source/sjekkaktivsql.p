/* Oversikt over alle anlegg med tilhørende tilbud for å sjekke status */

/*output to printer.*/
/* AGREGATER */
/*display ">>>>>>>>>>> AGREGATER ".
select anleggsnr, anlegg, aktivt 
from npaganlg
where aktivt = false  
and anleggsnr not in (
select anleggsnr 
from npagtilbud, npagtopp
where npagtilbud.id = npagtopp.id 
and (npagtopp.oppf_status MATCHES "Tapt*" 
  or npagtopp.oppf_status = "ORDRE"   
  or npagtopp.oppf_status BEGINS 'Plassbygd' 
  or npagtopp.oppf_status BEGINS 'Ikke' ) )

update npaganlg
set aktivt = false
where aktivt = true 
and anleggsnr in (
select anleggsnr 
from npagtilbud, npagtopp
where npagtilbud.id = npagtopp.id 
and (npagtopp.oppf_status MATCHES "Tapt*" 
  or npagtopp.oppf_status = "ORDRE"   
  or npagtopp.oppf_status BEGINS 'Plassbygd' 
  or npagtopp.oppf_status BEGINS 'Ikke' ) )
*/
/* SHUNTER */
/*display ">>>>>>>>>>> SHUNTER ".
select anleggsnr, anlegg, aktivt 
from npshanlg
where aktivt = false
and anleggsnr not in (
select anleggsnr 
from npshtilbud, npshtopp
where npshtilbud.id = npshtopp.id 
and (npshtopp.oppf_status MATCHES "Tapt*" 
  or npshtopp.oppf_status = "ORDRE"   
  or npshtopp.oppf_status BEGINS 'Plassbygd' 
  or npshtopp.oppf_status BEGINS 'Ikke' ) )

update npshanlg
set aktivt = true
where aktivt = false 
and anleggsnr not in (
select anleggsnr 
from npshtilbud, npshtopp
where npshtilbud.id = npshtopp.id 
and (npshtopp.oppf_status MATCHES "Tapt*" 
  or npshtopp.oppf_status = "ORDRE"   
  or npshtopp.oppf_status BEGINS 'Plassbygd' 
  or npshtopp.oppf_status BEGINS 'Ikke' ) )
*/


/* SPIROVENT */
/*display ">>>>>>>>>>> SPIROVENT ".
select anleggsnr, anlegg, aktivt 
from npspanlg
where aktivt = false 
and anleggsnr not in (
select anleggsnr 
from npsptilbud, npsptopp
where npsptilbud.id = npsptopp.id 
and (npsptopp.oppf_status MATCHES "Tapt*" 
  or npsptopp.oppf_status = "ORDRE"   
  or npsptopp.oppf_status BEGINS 'Plassbygd' 
  or npsptopp.oppf_status BEGINS 'Ikke' ) )

update npspanlg
set aktivt = false
where aktivt = true 
and anleggsnr in (
select anleggsnr 
from npsptilbud, npsptopp
where npsptilbud.id = npsptopp.id 
and (npsptopp.oppf_status MATCHES "Tapt*" 
  or npsptopp.oppf_status = "ORDRE"   
  or npsptopp.oppf_status BEGINS 'Ikke' ) )
*/
