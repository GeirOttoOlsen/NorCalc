  DEF VAR p_dapi  AS DATE              NO-UNDO INIT 10/19/2013.
  DEF VAR p_fichb AS CHAR              NO-UNDO INIT "tests/testbvr3-result.pdf".
  
  {pdf_inc.i "THIS-PROCEDURE"}
  
  {tests/pdf_tests.i}

  DEF VAR eadti      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR eadn1      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR eadn2      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR eadn3      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR eadn4      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR eadr1      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR eadr2      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR eadlo      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR eadtf      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR eadtp      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR eadem      AS CHAR FORMAT "x(44)"           NO-UNDO.
  DEF VAR edafa      AS CHAR FORMAT "x(26)"           NO-UNDO.
                                                       
  DEF VAR vpage      AS CHAR                          NO-UNDO.
  DEF VAR vnbre      AS INT                           NO-UNDO.
  DEF VAR vdapi      AS DATE FORMAT "99/99/9999"      NO-UNDO.
  DEF VAR t          AS INT INIT 1                    NO-UNDO.
  DEF VAR tr         AS INT                           NO-UNDO.

  DEF VAR vcpai      AS CHAR FORMAT "x(30)"           NO-UNDO.
  
  DEF VAR sad        AS CHAR FORMAT "x(35)" EXTENT 10 NO-UNDO.
  DEF VAR m10        AS CHAR FORMAT "x(10)" EXTENT 11 NO-UNDO.

/***************************************************************************
  Début de la procédure
 ***************************************************************************/
  ASSIGN sad[1] = CODEPAGE-CONVERT("Valsider SA", SESSION:CHARSET, "iso8859-1")
         sad[2] = CODEPAGE-CONVERT("Rue des condémines 22", SESSION:CHARSET, "iso8859-1")
         sad[3] = CODEPAGE-CONVERT("CH-1400 Yverdon", SESSION:CHARSET, "iso8859-1")
         sad[4] = CODEPAGE-CONVERT("+41 24 425 22 23", SESSION:CHARSET, "iso8859-1").

  ASSIGN eadn1 = CODEPAGE-CONVERT("INSENS SA", SESSION:CHARSET, "iso8859-1")
         eadn2 = CODEPAGE-CONVERT("Centre de soins", SESSION:CHARSET, "iso8859-1")
         eadr1 = CODEPAGE-CONVERT("Rue Ami-Lullin 12", SESSION:CHARSET, "iso8859-1")
         eadlo = CODEPAGE-CONVERT("1207 Genève", SESSION:CHARSET, "iso8859-1").

  DO t = 1 TO 6:
    IF eadr2 EQ ""
    THEN ASSIGN eadr2 = eadr1
                eadr1 = eadn4 
                eadn4 = eadn3
                eadn3 = eadn2
                eadn2 = eadn1
                eadn1 = eadti
                eadti = "".
    IF eadr1 EQ ""
    THEN ASSIGN eadr1 = eadn4
                eadn4 = eadn3
                eadn3 = eadn2
                eadn2 = eadn1
                eadn1 = eadti
                eadti = "".
    IF eadn4 EQ ""
    THEN ASSIGN eadn4 = eadn3
                eadn3 = eadn2
                eadn2 = eadn1
                eadn1 = eadti
                eadti = "".
    IF eadn3 EQ ""
    THEN ASSIGN eadn3 = eadn2
                eadn2 = eadn1
                eadn1 = eadti
                eadti = "".
    IF eadn2 EQ ""
    THEN ASSIGN eadn2 = eadn1
                eadn1 = eadti
                eadti = "".
    IF eadn1 EQ ""
    THEN ASSIGN eadn1 = eadti
                eadti = "".
  END.

  ASSIGN vdapi = 10/19/2013.

  ASSIGN edafa = (IF WEEKDAY(vdapi) EQ 1
                  THEN "Dimanche"
                  ELSE
                  IF WEEKDAY(vdapi) EQ 2
                  THEN "Lundi"
                  ELSE
                  IF WEEKDAY(vdapi) EQ 3
                  THEN "Mardi"
                  ELSE
                  IF WEEKDAY(vdapi) EQ 4
                  THEN "Mercredi"
                  ELSE
                  IF WEEKDAY(vdapi) EQ 5
                  THEN "Jeudi"
                  ELSE
                  IF WEEKDAY(vdapi) EQ 6
                  THEN "Vendredi"
                  ELSE "Samedi")
               + " "
               + TRIM(STRING(DAY(vdapi), ">9"))
               + " "
               + "juin"
               + " "
               + STRING(YEAR(vdapi), "9999").
  
  ASSIGN vcpai = "30 jours net".

  ASSIGN m10[1]  = "0946827135"
         m10[2]  = "9468271350"
         m10[3]  = "4682713509"
         m10[4]  = "6827135094"
         m10[5]  = "8271350946"
         m10[6]  = "2713509468"
         m10[7]  = "7135094682"
         m10[8]  = "1350946827"
         m10[9]  = "3509468271"
         m10[10] = "5094682713"
         m10[11] = "0987654321".
  
  RUN pdf_new ("Sbvr", gcTestsDir + p_fichb).

  RUN pdf_set_parameter("Sbvr", "UnitTest", "TRUE").

  RUN pdf_set_PaperType("Sbvr","A4").
  RUN pdf_set_VerticalSpace("Sbvr",12).
  RUN pdf_set_BottomMargin("Sbvr",343). 
  /* RUN pdf_load_font("Sbvr","Helvetica",OS-GETENV("windir") + "\fonts\Helvetica.ttf","samples/support/Helvetica.afm",""). */
  /* RUN pdf_load_font("Sbvr","Helvetica-Bold",OS-GETENV("windir") + "\fonts\Helveticabd.ttf","samples/support/Helveticabd.afm",""). */
  /* RUN pdf_load_font("Sbvr","Helvetica-BoldOblique",OS-GETENV("windir") + "\fonts\Helveticabi.ttf","samples/support/Helveticabi.afm",""). */
  /* RUN pdf_load_font("Sbvr","Helvetica-Oblique",OS-GETENV("windir") + "\fonts\Helveticai.ttf","samples/support/Helveticai.afm",""). */
  /* RUN pdf_load_font("Sbvr","Ocrb",OS-GETENV("windir") + "\fonts\ocrb.ttf","fonts\ocrb.afm",""). */

  pdf_PageHeader("Sbvr", THIS-PROCEDURE:HANDLE,"").
  pdf_PageFooter("Sbvr", THIS-PROCEDURE:HANDLE,"bvr").

  RUN pdf_new_page("Sbvr").

  RUN entete.
              
  IF vnbre NE 0
  THEN DO:
      RUN pdf_close("Sbvr").
      IF RETURN-VALUE > "" THEN
          MESSAGE RETURN-VALUE
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END. 

/***************************************************************************
  Fin de la procedure
 ***************************************************************************/
  PROCEDURE entete:
    ASSIGN vnbre = vnbre  + 1.
    RUN pdf_set_TextY("Sbvr",832).
    RUN pdf_set_font("Sbvr","Helvetica-Bold",16.0).

    RUN pdf_skipn("Sbvr",3).
    RUN pdf_text_at("Sbvr","Bulletin de versement",75).
    RUN pdf_set_font("Sbvr","Helvetica",10.0).
    RUN pdf_skipn("Sbvr",4).
            
    RUN pdf_text_at("Sbvr",sad[1],21).
    RUN pdf_skip("Sbvr").

    RUN pdf_text_at("Sbvr",sad[2],21).
    RUN pdf_skip("Sbvr").

    RUN pdf_text_at("Sbvr",sad[3],21).
    RUN pdf_skip("Sbvr").

    RUN pdf_text_at("Sbvr",sad[4],21).
    RUN pdf_set_font("Sbvr","Helvetica-Bold",10.0).
    RUN pdf_text_at("Sbvr",eadti,120).
    RUN pdf_set_font("Sbvr","Helvetica",10.0).
    RUN pdf_skip("Sbvr").

    RUN pdf_set_font("Sbvr","Helvetica-Bold",10.0).
    RUN pdf_text_at("Sbvr",eadn1,120).
    RUN pdf_set_font("Sbvr","Helvetica",10.0).
    RUN pdf_skip("Sbvr").

    RUN pdf_text_at("Sbvr","Tel.",21).
    RUN pdf_text_at("Sbvr",":",33).
    RUN pdf_text_at("Sbvr",sad[5],35).
    RUN pdf_set_font("Sbvr","Helvetica-Bold",10.0).
    RUN pdf_text_at("Sbvr",eadn2,120).
    RUN pdf_set_font("Sbvr","Helvetica",10.0).
    RUN pdf_skip("Sbvr").

    RUN pdf_text_at("Sbvr","Fax",21).
    RUN pdf_text_at("Sbvr",":",33).
    RUN pdf_text_at("Sbvr",sad[6],35).
    RUN pdf_set_font("Sbvr","Helvetica-Bold",10.0).
    RUN pdf_text_at("Sbvr",eadn3,120).
    RUN pdf_set_font("Sbvr","Helvetica",10.0).
    RUN pdf_skip("Sbvr").

    RUN pdf_text_at("Sbvr","Email",21).
    RUN pdf_text_at("Sbvr",":",33).
    RUN pdf_text_at("Sbvr",sad[7],35).
    RUN pdf_set_font("Sbvr","Helvetica-Bold",10.0).
    RUN pdf_text_at("Sbvr",eadn4,120).
    RUN pdf_set_font("Sbvr","Helvetica",10.0).
    RUN pdf_skip("Sbvr").

    RUN pdf_text_at("Sbvr","TVA n°",21).
    RUN pdf_text_at("Sbvr",":",33).
    RUN pdf_text_at("Sbvr","207 215",35).
    RUN pdf_set_font("Sbvr","Helvetica-Bold",10.0).
    RUN pdf_text_at("Sbvr",eadr1,120).
    RUN pdf_skip("Sbvr").

    RUN pdf_text_at("Sbvr",eadr2,120).
    RUN pdf_skip("Sbvr").

    RUN pdf_text_at("Sbvr",CODEPAGE-CONVERT("Numéro",SESSION:CHARSET,"iso8859-1"),21).
    RUN pdf_text_at("Sbvr",":",36).
    RUN pdf_text_at("Sbvr",TRIM(STRING(57013, ">>>>>>>>9")),38).
    RUN pdf_text_at("Sbvr",eadlo,120).
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr","Date",21).
    RUN pdf_text_at("Sbvr",":",36).
    RUN pdf_text_at("Sbvr",edafa,38).
    RUN pdf_set_font("Sbvr","Helvetica",10.0).

    RUN pdf_skipn("Sbvr",2).
  
    RUN pdf_set_font("Sbvr","Helvetica-Bold",10.0).
    RUN pdf_text_at("Sbvr","Conditions de paiement : " + vcpai,21).
    RUN pdf_set_font("Sbvr","Helvetica",10.0).
  END.

  PROCEDURE bvr: 
    DEF VAR adrbk1       AS CHAR FORMAT "x(27)"    NO-UNDO.
    DEF VAR locabk1      AS CHAR FORMAT "x(27)"    NO-UNDO.
    DEF VAR bk1-nocpte   AS CHAR FORMAT "x(20)"    NO-UNDO.
    DEF VAR bk1-favnom1  AS CHAR FORMAT "x(30)"    NO-UNDO.
    DEF VAR bk1-favnom2  AS CHAR FORMAT "x(30)"    NO-UNDO.
    DEF VAR bk1-favrue1  AS CHAR FORMAT "x(30)"    NO-UNDO.
    DEF VAR bk1-favrue2  AS CHAR FORMAT "x(30)"    NO-UNDO.
    DEF VAR ref          AS CHAR FORMAT "x(32)"    NO-UNDO.
    DEF VAR bk1-favville AS CHAR FORMAT "x(30)"    NO-UNDO.
    DEF VAR cpte         AS CHAR FORMAT "x(20)"    NO-UNDO.
    DEF VAR montf        AS INT  FORMAT ">>>>>>>9" NO-UNDO.
    DEF VAR montc        AS INT  FORMAT "99"       NO-UNDO.
    DEF VAR adr1         AS CHAR FORMAT "x(35)"    NO-UNDO.
    DEF VAR refr1        AS CHAR FORMAT "x(14)"    NO-UNDO.
    DEF VAR adr2         AS CHAR FORMAT "x(35)"    NO-UNDO.
    DEF VAR refr2        AS CHAR FORMAT "x(17)"    NO-UNDO.
    DEF VAR adr3         AS CHAR FORMAT "x(35)"    NO-UNDO.
    DEF VAR adrr1        AS CHAR FORMAT "x(25)"    NO-UNDO.
    DEF VAR adr4         AS CHAR FORMAT "x(35)"    NO-UNDO.
    DEF VAR adrr2        AS CHAR FORMAT "x(25)"    NO-UNDO.
    DEF VAR adr5         AS CHAR FORMAT "x(35)"    NO-UNDO.
    DEF VAR adrr3        AS CHAR FORMAT "x(25)"    NO-UNDO.
    DEF VAR adr6         AS CHAR FORMAT "x(35)"    NO-UNDO.
    DEF VAR adrr4        AS CHAR FORMAT "x(25)"    NO-UNDO.
    
    DEF VAR cod          AS CHAR FORMAT "x(59)"    NO-UNDO.

    DEF VAR ma           AS CHAR FORMAT "x(11)"    NO-UNDO.  
    DEF VAR pn           AS INT  FORMAT "99999999" NO-UNDO.  
    DEF VAR s1           AS CHAR FORMAT "x(12)"    NO-UNDO.  
    DEF VAR s2           AS CHAR FORMAT "x(26)"    NO-UNDO.  

    DEF VAR re           AS INT  FORMAT "9"        NO-UNDO.  
    DEF VAR ch           AS INT  FORMAT "9"        NO-UNDO.  
    DEF VAR c1           AS CHAR FORMAT "x"        NO-UNDO.  
    DEF VAR c2           AS CHAR FORMAT "x"        NO-UNDO.  

    ASSIGN bk1-favnom1       = "MAINTAIR S.A." 
           bk1-favnom2       = ""
           bk1-favrue1       = "1007 LAUSANNE"
           bk1-favrue2       = ""
           bk1-favville      = ""
           adrbk1            = "MAINTAIR S.A."
           locabk1           = "1007 LAUSANNE"
           bk1-nocpte        = ""
           ma                = STRING(2959.20, "99999999.99")
           pn                = INT("57013")
           SUBSTR(cod,4,2)   = "01" 
           SUBSTR(cod,6,8)   = SUBSTR(ma,1,8) 
           SUBSTR(cod,14,2)  = SUBSTR(ma,10,2)
           SUBSTR(cod,17,1)  = CHR(062)
           SUBSTR(cod,18,6)  = SUBSTR("011135",1,6)
           SUBSTR(cod,24,2)  = "99"
           SUBSTR(cod,26,10) = STRING(15615, "9999999999")
           SUBSTR(cod,36,8)  = STRING(pn, "99999999")        
           SUBSTR(cod,45,1)  = CHR(043)                       
           SUBSTR(cod,47,9)  = SUBSTR("010001135",1,9)          
           SUBSTR(cod,56,1)  = CHR(062)                         
           cpte              = "01-113-5"                       
           s1                = SUBSTR(cod,4,12)                    
           re                = 0.
    DO t = 1 TO 12:
      ASSIGN re = re + 1
             ch = INT64(SUBSTR(s1,t,1)) + 1
             re = INT64(SUBSTR(m10[ch],re,1)).
    END.
    ASSIGN c1               = SUBSTR(m10[11],(re + 1),1)
           SUBSTR(cod,16,1) = c1
           s2               = SUBSTR(cod,18,26)
           re               = 0.
    DO t = 1 TO 26:
      ASSIGN re = re + 1
             ch = INT64(SUBSTR(s2,t,1)) + 1
             re = INT64(SUBSTR(m10[ch],re,1)).
    END.
    ASSIGN c2               = SUBSTR(m10[11],(re + 1),1)
           SUBSTR(cod,44,1) = c2
           SUBSTR(ref,1,2)  = SUBSTR(cod,18,2)
           SUBSTR(ref,4,5)  = SUBSTR(cod,20,5)
           SUBSTR(ref,10,5) = SUBSTR(cod,25,5)
           SUBSTR(ref,16,5) = SUBSTR(cod,30,5)
           SUBSTR(ref,22,5) = SUBSTR(cod,35,5)
           SUBSTR(ref,28,5) = SUBSTR(cod,40,5)
           montf            = INT64(SUBSTR(ma,1,8))
           montc            = INT64(SUBSTR(ma,10,2))
           refr1            = SUBSTR(ref,1,14)
           refr2            = SUBSTR(ref,16,17)
           adr1             = "INSENS SA"
           adr2             = "Centre de soins"
           adr3             = ""
           adr4             = "Rue Ami-Lullin 12"
           adr5             = ""
           adr6             = CODEPAGE-CONVERT("Genève", SESSION:CHARSET, "iso8859-1")
           adrr1            = SUBSTR(CODEPAGE-CONVERT("INSENS SA", SESSION:CHARSET, "iso8859-1")        ,1,28)
           adrr2            = SUBSTR(CODEPAGE-CONVERT("Centre de soins", SESSION:CHARSET, "iso8859-1")  ,1,28)
           adrr3            = SUBSTR(CODEPAGE-CONVERT("Rue Ami-Lullin 12", SESSION:CHARSET, "iso8859-1"),1,28)
           adrr4            = SUBSTR(CODEPAGE-CONVERT("Genève", SESSION:CHARSET, "iso8859-1")      ,1,28).

    DO tr = 1 TO 5:
      IF adr1 EQ ""
      THEN ASSIGN adr1 = adr2
                  adr2 = adr3
                  adr3 = adr4
                  adr4 = adr5
                  adr5 = adr6
                  adr6 = "".
      IF adr2 EQ ""
      THEN ASSIGN adr2 = adr3
                  adr3 = adr4
                  adr4 = adr5
                  adr5 = adr6
                  adr6 = "".
      IF adr3 EQ ""
      THEN ASSIGN adr3 = adr4
                  adr4 = adr5
                  adr5 = adr6
                  adr6 = "".
      IF adr4 EQ ""
      THEN ASSIGN adr4 = adr5
                  adr5 = adr6
                  adr6 = "".
      IF adr5 EQ ""
      THEN ASSIGN adr5 = adr6
                  adr6 = "".
      IF adrr1 EQ ""
      THEN ASSIGN adrr1 = adrr2
                  adrr2 = adrr3
                  adrr3 = adrr4
                  adrr4 = "".
      IF adrr2 EQ ""
      THEN ASSIGN adrr2 = adrr3
                  adrr3 = adrr4
                  adrr4 = "".
      IF adrr3 EQ ""
      THEN ASSIGN adrr3 = adrr4
                  adrr4 = "".
    END.
    RUN pdf_set_font("Sbvr","Helvetica",10.0).
    RUN pdf_skipn("Sbvr",6).
    RUN pdf_text_at("Sbvr",adrbk1,2).
    RUN pdf_text_at("Sbvr",adrbk1,64).
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",locabk1,2).
    RUN pdf_text_at("Sbvr",locabk1,64).
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",bk1-nocpte,2).            
    RUN pdf_text_at("Sbvr",bk1-nocpte,64).            
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",bk1-favnom1,2).    
    RUN pdf_text_at("Sbvr",bk1-favnom1,64).    
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",bk1-favnom2,2). 
    RUN pdf_text_at("Sbvr",bk1-favnom2,64). 
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",bk1-favrue1,2).    
    RUN pdf_text_at("Sbvr",bk1-favrue1,64).    
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",bk1-favville,2).   
    RUN pdf_text_at("Sbvr",bk1-favville,64).   
    RUN pdf_text_at("Sbvr",ref,125).       
    RUN pdf_skipn("Sbvr",2).
    RUN pdf_text_at("Sbvr",cpte,24).   
    RUN pdf_text_at("Sbvr",cpte,86).   
    RUN pdf_skipn("Sbvr",2).
    RUN pdf_text_to("Sbvr",montf,17).    
    RUN pdf_text_to("Sbvr",STRING(montc, "99"),23).      
    RUN pdf_text_to("Sbvr",montf,43).    
    RUN pdf_text_to("Sbvr",STRING(montc, "99"),49).     
    RUN pdf_text_at("Sbvr",adr1,125).    
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",adr2,125).    
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",refr1,2).   
    RUN pdf_text_at("Sbvr",adr3,125).    
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",refr2,2).   
    RUN pdf_text_at("Sbvr",adr4,125).
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",adrr1,2).    
    RUN pdf_text_at("Sbvr",adr5,125).
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",adrr2,2). 
    RUN pdf_text_at("Sbvr",adr6,125).
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",adrr3,2).
    RUN pdf_skip("Sbvr").
    RUN pdf_text_at("Sbvr",adrr4,2).  
    RUN pdf_skip("Sbvr").
    /* RUN pdf_set_font("Sbvr","Ocrb",10.0). */
    RUN pdf_text_xy("Sbvr",cod,171,pdf_TextY("Sbvr")). 
  END.  

