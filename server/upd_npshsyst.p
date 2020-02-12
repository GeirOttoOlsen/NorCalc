/*------------------------------------------------------------------------
    File        : nyfirmakontakt.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Mon Sep 26 08:53:02 CEST 2011
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

ROUTINE-LEVEL ON ERROR UNDO, THROW.
DEF INPUT  PARAM icRowid     AS CHAR NO-UNDO.
DEF INPUT  PARAM icFields    AS CHAR NO-UNDO.
DEF INPUT  PARAM icValues    AS CHAR NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.

DEF VAR dPrimHastighet AS DEC NO-UNDO.
DEF VAR dSekHastighet  AS DEC NO-UNDO.


FIND FIRST npshsyst WHERE ROWID(npshsyst) = TO-ROWID(icRowid) NO-ERROR.

/* Beregn indre hastighet */
RUN prc_hastighet.

   /* Default verdier for tillegg */
    IF type = 'FM' THEN
    DO:
      CASE shunt_dimmensjon:
          WHEN '25' THEN ASSIGN tillegg_fm_brakett_overgang = 'MB 23.5 Ø30/Ø10 SETT'.
          WHEN '50' THEN ASSIGN tillegg_fm_brakett_overgang = 'MB 37.5 Ø30/Ø10 SETT'.
          WHEN '65' THEN ASSIGN tillegg_fm_brakett_overgang = 'MB 56.0 Ø30/Ø10 SETT'.
      END CASE.
    END.
  
   /* Default for kapsling */
  CASE beregnet_anvendelse:
    WHEN  "Varme" OR WHEN "Lavtemperatur" THEN ASSIGN tillegg_kapsling = "Kapsling-Rød front".
    WHEN  "Kjøle" OR WHEN "Fryse" THEN         ASSIGN tillegg_kapsling = "Kapsling-Blå front".
    WHEN "Varmegjenvinning" THEN               ASSIGN tillegg_kapsling = "Kapsling-Grønn front".
    WHEN "Lavtemp/Kaldt medium" THEN           ASSIGN tillegg_kapsling = "Kapsling-Rød/Blå front".
  END CASE.


/* Fyll ut de felt som har data - resten med ?? */
DEFINE VAR c_kode AS CHAR.
/* Type */
IF  type <> "" THEN c_kode = npshsyst.TYPE.
ELSE c_kode = '??'.
/* Dimm */
IF  npshsyst.shunt_dimmensjon <> "" THEN c_kode = c_kode  + TRIM(npshsyst.shunt_dimmensjon).
ELSE c_kode = c_kode + '??'.
/* Legg til ventiltype ved MS */
IF npshsyst.type = 'MS' THEN c_kode = c_kode + '/' + npshsyst.ms_ventiltype.
/* KVS Hovedport (2-1)  og ventilkarakteristikk */
IF  kvs_hovedport > 0 THEN 
DO:
  c_kode = c_kode + '-Kvs' + STRING(npshsyst.kvs_hovedport).
  c_kode = c_kode + ' ' + ventil_karakteristikk_hoved.
END.        
ELSE c_kode = TRIM(c_kode) + '- Kvs' + '??-??'.
IF type = 'FM' THEN
DO:
  /* KVS Shuntport (3-1) og ventilkarakteristikk */
  IF  kvs_shuntport > 0 THEN
  DO:
    c_kode = c_kode + '/Kvs' + STRING(kvs_shuntport).
    c_kode = c_kode + ' ' + ventil_karakteristikk_shunt.
  END.        
END.
/* Koblingsalternativ */
c_kode = c_kode + '-' + STRING(NPSHSYST.koblings_alternativ).
/* Beregnet anvendelse */
CASE beregnet_anvendelse:
    WHEN 'Varme'         THEN c_kode = c_kode + '-V'.
    WHEN 'Lavtemperatur' THEN c_kode = c_kode + '-L'.
    WHEN 'Kjøle'         THEN c_kode = c_kode + '-K'.
    WHEN 'Fryse'         THEN c_kode = c_kode + '-F'.
    WHEN 'Varmegjenvinning' THEN c_kode = c_kode + '-VG'.
    WHEN "Lavtemp/Kaldt medium" THEN c_kode = c_kode + '-L/K'.
END CASE.
/* Reguleringsmotor */
IF tillegg_forstilling = 'Ingen' THEN c_kode = c_kode + '-0'.
ELSE c_kode = c_kode + '-<' + tillegg_forstilling + '>'.

/* Strupeventil type og dimmensjon */
IF tillegg_strupe THEN
DO:
  CASE NPSHSYST.koblings_alternativ:
    WHEN '1' OR WHEN '7A' THEN
    /* primær og sekundær er like */
    DO:
      IF  strupe_dimmensjon_sek <> "" THEN c_kode = c_kode + '-' + fabrikat + strupe_dimmensjon_sek + '/' + fabrikat + strupe_dimmensjon_sek.
      ELSE c_kode = c_kode + '- 0/0'.
    END.
    WHEN '2' OR WHEN '3' OR WHEN '6' THEN
    /* kun sekundærside */
    DO:
      IF strupe_dimmensjon_sek <> "" THEN c_kode = c_kode + '-KUL' + strupe_dimmensjon_sek + '/' + fabrikat + strupe_dimmensjon_sek.
      ELSE c_kode = c_kode + '-0/0'.
    END.
    WHEN '4' THEN
    /* kun primærside */
    DO:
      IF  NPSHSYST.strupe_dimmensjon_prim <> "" THEN c_kode = c_kode + '-' +  fabrikat + strupe_dimmensjon_prim + '/KUL' + strupe_dimmensjon_prim.
      ELSE c_kode = c_kode + '-0/0'.
    END.
    WHEN '5' OR WHEN '7' THEN
    /* både primærside or sekundærside */
    DO:
      IF strupe_dimmensjon_prim <> "" THEN c_kode = c_kode + '- ' +  fabrikat + strupe_dimmensjon_prim + '/' + fabrikat + strupe_dimmensjon_sek.
      ELSE c_kode = c_kode + '0/0'.
    END.
  END CASE.
END.
ELSE c_kode = c_kode + '-0/0'.

    /* Stengeventil type og dimmensjon */
    /* Koblingsalternativ uaktuelt - styres ved registrering av tillegg */
    CASE koblings_alternativ:
      WHEN '5' OR WHEN '7 '  THEN
      DO:
        IF tillegg_stengeventil_type_prim = 'Kule' THEN
        DO:
          IF tillegg_kuleventil_prim THEN c_kode = c_kode + '-KUL' + strupe_dimmensjon_prim + '/'.
          ELSE c_kode = c_kode + '-0/'.            
        END.
        ELSE IF tillegg_stengeventil_type_prim = 'Spjeld' THEN
        DO:
          IF tillegg_spjeldventil_prim THEN c_kode = c_kode + '-SPJ' + strupe_dimmensjon_prim + '/'.
          ELSE c_kode = c_kode + '-0/'.            
        END.
        IF tillegg_stengeventil_type_sek = 'Kule' THEN
        DO:                
          IF tillegg_kuleventil_sek THEN c_kode = c_kode + 'KUL' + strupe_dimmensjon_sek.
          ELSE c_kode = c_kode + '0'.
        END.
        ELSE IF tillegg_stengeventil_type_sek = 'Spjeld' THEN
        DO:
          IF tillegg_spjeldventil_sek THEN c_kode = c_kode + '-SPJ' + strupe_dimmensjon_sek.
          ELSE c_kode = c_kode + '0'.            
        END.
      END.
      OTHERWISE
      DO:
       IF tillegg_kuleventil_sek THEN c_kode = c_kode + '-KUL' + strupe_dimmensjon_prim + '/' +  'KUL' + strupe_dimmensjon_sek.
       ELSE IF tillegg_spjeldventil_sek THEN c_kode = c_kode + '-SPJ' + strupe_dimmensjon_prim + '/' +  'SPJ' + strupe_dimmensjon_sek.
       ELSE c_kode = c_kode + '-0/0'.
      END.
    END CASE.
        
  /* Pumpe */
  IF  tillegg_pumpe_fabrikat = "Ingen" THEN c_kode = c_kode + '-0'.
  ELSE c_kode = c_kode + '-P'.
     
  /* Montasje */
  IF  tillegg_montasje <> "" THEN c_kode = c_kode + '-' + SUBSTRING(tillegg_montasje,1 ,1).
  ELSE c_kode = c_kode + '- ??'.

  /*  Kapsling */
  IF  tillegg_kapsling <> "Kapsling, Ingen" THEN c_kode = c_kode + '-' + SUBSTRING(tillegg_kapsling, 10, 11).
  ASSIGN system_kode = c_kode.

/*     RUN jbserv_domessage.p (503,                                                       */
/*                             "Ugyldig leverandør: &1",                                  */
/*                             "",                                                        */
/*                             DYNAMIC-FUNCTION("getValue" IN SOURCE-PROCEDURE,"iLevNr"), */
/*                             icSessionId,                                               */
/*                             OUTPUT ocReturn).                                          */

ocReturn = ''. /*No error*/

PROCEDURE prc_hastighet:

  /*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
  ------------------------------------------------------------------------------*/
  define var v_prim as decimal format ">>>9,999999".
  define var v_sek as decimal format ">>>9,999999".
  define var pi as decimal initial 3.14.

  DEF VAR cReturn AS CHAR NO-UNDO.
  DEF VAR cDim    AS CHAR NO-UNDO.
  DEF VAR dNPIndrediam AS DECIMAL NO-UNDO.

  FIND FIRST NPIndrediam WHERE NPIndrediam.dimm = npshsyst.shunt_dimmensjon NO-LOCK NO-ERROR.
  IF AVAIL NPIndrediam THEN
  do:
    ASSIGN 
      v_prim = prim_kapasitet * 1000 /  ((NPIndrediam.indre_diameter * dNPIndrediam * pi) / 4)
      v_sek = sek_kapasitet * 1000 /   ((dNPIndrediam * dNPIndrediam * pi) / 4)
      dPrimHastighet = v_prim
      dSekHastighet  = v_sek
    .
  end.

  END PROCEDURE.
