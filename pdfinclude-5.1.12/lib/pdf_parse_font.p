/******************************************************************************

  Program:      pdf_parse_fonts.p
  
  Written By:   Jean-Christophe Cardot
  Written On:   October 2014
  
  Description:  Parse a TTF font in order to get font metrics.
                This can replace the usage of afm/ufm files, through pdf_load_font2()
  
  10/16/14  JC Cardot   Created

******************************************************************************/

/* functions definitions */
{inc/pdf_func_error.i "SHARED"}
{inc/pdf_func_bin.i "SHARED"}
{inc/pdf_func_strconv.i}

/* Temp-tables definitions */
{inc/pdf_tt_fonts.i "SHARED"}

DEFINE VARIABLE cPost1Names AS CHARACTER EXTENT 258 NO-UNDO INITIAL [
    ".notdef",".null","nonmarkingreturn","space","exclam","quotedbl","numbersign","dollar","percent",
    "ampersand","quotesingle","parenleft","parenright","asterisk","plus","comma","hyphen","period",
    "slash","zero","one","two","three","four","five","six","seven","eight","nine","colon","semicolon",
    "less","equal","greater","question","at","A","B","C","D","E","F","G","H","I","J","K","L","M","N",
    "O","P","Q","R","S","T","U","V","W","X","Y","Z","bracketleft","backslash","bracketright",
    "asciicircum","underscore","grave","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o",
    "p","q","r","s","t","u","v","w","x","y","z","braceleft","bar","braceright","asciitilde",
    "Adieresis","Aring","Ccedilla","Eacute","Ntilde","Odieresis","Udieresis","aacute","agrave",
    "acircumflex","adieresis","atilde","aring","ccedilla","eacute","egrave","ecircumflex",
    "edieresis","iacute","igrave","icircumflex","idieresis","ntilde","oacute","ograve","ocircumflex",
    "odieresis","otilde","uacute","ugrave","ucircumflex","udieresis","dagger","degree","cent",
    "sterling","section","bullet","paragraph","germandbls","registered","copyright","trademark",
    "acute","dieresis","notequal","AE","Oslash","infinity","plusminus","lessequal","greaterequal",
    "yen","mu","partialdiff","summation","product","pi","integral","ordfeminine","ordmasculine",
    "Omega","ae","oslash","questiondown","exclamdown","logicalnot","radical","florin","approxequal",
    "Delta","guillemotleft","guillemotright","ellipsis","nonbreakingspace","Agrave","Atilde","Otilde",
    "OE","oe","endash","emdash","quotedblleft","quotedblright","quoteleft","quoteright","divide",
    "lozenge","ydieresis","Ydieresis","fraction","currency","guilsinglleft","guilsinglright","fi",
    "fl","daggerdbl","periodcentered","quotesinglbase","quotedblbase","perthousand","Acircumflex",
    "Ecircumflex","Aacute","Edieresis","Egrave","Iacute","Icircumflex","Idieresis","Igrave","Oacute",
    "Ocircumflex","apple","Ograve","Uacute","Ucircumflex","Ugrave","dotlessi","circumflex","tilde",
    "macron","breve","dotaccent","ring","cedilla","hungarumlaut","ogonek","caron","Lslash","lslash",
    "Scaron","scaron","Zcaron","zcaron","brokenbar","Eth","eth","Yacute","yacute","Thorn","thorn",
    "minus","multiply","onesuperior","twosuperior","threesuperior","onehalf","onequarter",
    "threequarters","franc","Gbreve","gbreve","Idotaccent","Scedilla","scedilla","Cacute","cacute",
    "Ccaron","ccaron","dcroat"].

DEFINE TEMP-TABLE tt_string_array NO-UNDO LABEL "Array of strings (tt_string_array)"
 FIELD id AS INTEGER
 FIELD str AS CHARACTER
 INDEX ix IS UNIQUE PRIMARY id.

FUNCTION basename RETURNS CHARACTER (ipcFile AS CHARACTER):
    RETURN ENTRY(NUM-ENTRIES(REPLACE(ipcFile, "~\", "~/"), "~/"), REPLACE(ipcFile, "~\", "~/"), "~/").
END FUNCTION.

FUNCTION GetWidgetOption2 RETURNS CHARACTER   /* PRIVATE */
    (INPUT pOption  AS CHARACTER,
     INPUT pOptions AS CHARACTER,
     INPUT pDefault AS CHARACTER):

    DEFINE VARIABLE cOpt AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i    AS INTEGER     NO-UNDO.

    DO i = NUM-ENTRIES(pOptions) TO 1 BY -1:
        cOpt = ENTRY(i, pOptions).
        IF ENTRY(1, cOpt, "=") = pOption THEN
            IF NUM-ENTRIES(cOpt, "=") = 1 THEN
                RETURN "YES".
            ELSE
                RETURN ENTRY(2, cOpt, "=").
    END.
    RETURN pDefault.
END FUNCTION. /* GetWidgetOption2 */

FUNCTION findOrCreate_TT_pdf_font_character RETURNS LOGICAL
    ( piCharId AS INTEGER,
      /* pcTag    AS CHARACTER, */
      INPUT-OUTPUT piNbChars AS INTEGER,
      BUFFER TT_pdf_font           FOR TT_pdf_font,
      BUFFER TT_pdf_font_character FOR TT_pdf_font_character):    

      FIND TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = TT_pdf_font.obj_stream
          AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
          AND TT_pdf_font_character.char_id = piCharId NO-ERROR.
      IF NOT AVAILABLE tt_pdf_font_character THEN DO:
          CREATE TT_pdf_font_character.
          ASSIGN
           TT_pdf_font_character.obj_stream = tt_pdf_font.obj_stream
           TT_pdf_font_character.font_name  = TT_pdf_font.font_name
           TT_pdf_font_character.char_id = piCharId
           /* TT_pdf_font_character.tag     = pcTag */
           piNbChars                     = piNbChars + 1.
          RETURN TRUE.
      END.
      /* ELSE */
          /* TT_pdf_font_character.tag     = TT_pdf_font_character.tag + "," + pcTag. */
      RETURN FALSE.
END FUNCTION.

&SCOPED-DEFINE cleanUp SET-SIZE(mFont) = 0. EMPTY TEMP-TABLE tt_pdf_font_table. EMPTY TEMP-TABLE tt_pdf_font_encoding_table. EMPTY TEMP-TABLE tt_pdf_font_index_to_loc. EMPTY TEMP-TABLE tt_pdf_font_segment. EMPTY TEMP-TABLE tt_string_array.

PROCEDURE parseFont:
    DEFINE INPUT PARAMETER pdfStream  AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pcFontName AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pcFileName AS CHARACTER   NO-UNDO.
    DEFINE PARAMETER BUFFER TT_pdf_font FOR TT_pdf_font.
    DEFINE INPUT PARAMETER pcOptions  AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE c                    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cCacheFileName       AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cErrorMsg            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cWidth               AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i                    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iChar                AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iCmapOffset          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iEncodingID          AS INTEGER     NO-UNDO. /* unicode */.
    DEFINE VARIABLE iEncodingTable       AS INTEGER     NO-UNDO. /* iter */.
    DEFINE VARIABLE iEndCharCode         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iEntryCount          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iFirstCode           AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iFlags               AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iFontFileSize        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iFormat              AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iGid                 AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iGlyph               AS INTEGER     NO-UNDO. /* iter */.
    DEFINE VARIABLE iGlyphIndex          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLength              AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iMacStyle            AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNbChars             AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNumberOfContours    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNumberOfGlyphs      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNumEncodingTables   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNumGroups           AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNumOfLongHorMetrics AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNumTables           AS INTEGER     NO-UNDO. /* number of tables */.
    DEFINE VARIABLE iOffset              AS INTEGER     INITIAL 1 NO-UNDO.
    DEFINE VARIABLE iOffset2             AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iPlatformID          AS INTEGER     NO-UNDO. /* windows */.
    DEFINE VARIABLE iSegCount            AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iShortOffset         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iStartCharCode       AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iStartGlyphCode      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iSubsetPrefix        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iTable               AS INTEGER     NO-UNDO. /* iter */.
    DEFINE VARIABLE iUnitsPerEm          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iXMax                AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iXMin                AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iYMax                AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iYMin                AS INTEGER     NO-UNDO.
    DEFINE VARIABLE j                    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE mFont                AS MEMPTR      NO-UNDO.

    DEFINE BUFFER TT_pdf_font_table              FOR TT_pdf_font_table.
    DEFINE BUFFER tt_pdf_font_encoding_table     FOR tt_pdf_font_encoding_table.
    DEFINE BUFFER tt_pdf_font_index_to_loc       FOR tt_pdf_font_index_to_loc.
    DEFINE BUFFER tt_pdf_font_segment            FOR tt_pdf_font_segment.
    DEFINE BUFFER TT_pdf_font_character          FOR TT_pdf_font_character.
    DEFINE BUFFER TT_pdf_font_compound_character FOR TT_pdf_font_character.

    OS-CREATE-DIR VALUE(SESSION:TEMP-DIRECTORY + "pdfcache/fonts/").

    cCacheFileName = ENCODE(pcFileName + pcOptions).

    CREATE TT_pdf_font.
    ASSIGN
     TT_pdf_font.obj_stream   = pdfStream
     TT_pdf_font.font_name    = pcFontName
     TT_pdf_font.font_file    = SEARCH(pcFileName)
     TT_pdf_font.is_unicode   = LOGICAL(GetWidgetOption2("unicode", pcOptions, "NO"))
     TT_pdf_font.font_tag     = "~/" + STRING(pcFontName)
     TT_pdf_font.cid2gid_file = SESSION:TEMP-DIRECTORY + "pdfcache/fonts/" + cCacheFileName + ".cid2gid".

    IF LOGICAL(GetWidgetOption2("usecache", pcOptions, "NO")) THEN blkCache: DO:
        /* check cache integrity */
        IF SEARCH(SESSION:TEMP-DIRECTORY + "pdfcache/fonts/" + cCacheFileName + ".cache") = ? THEN LEAVE blkCache.
        IF SEARCH(TT_pdf_font.cid2gid_file) = ? THEN LEAVE blkCache.
        /* load cache */
        INPUT FROM VALUE(SESSION:TEMP-DIRECTORY + "pdfcache/fonts/" + cCacheFileName + ".cache").
        IMPORT tt_pdf_font EXCEPT TT_pdf_font.obj_stream
                                  TT_pdf_font.is_unicode
                                  TT_pdf_font.used_flag
                                  TT_pdf_font.used_by_xobject
                                  TT_pdf_font.pdf_id
                                  TT_pdf_font.ext_page
                                  TT_pdf_font.font_embed
                                  TT_pdf_font.font_subset
                                  TT_pdf_font.font_options
                                  TT_pdf_font.font_dif
                                  TT_pdf_font.font_obj.
        ASSIGN
         TT_pdf_font.obj_stream = pdfStream
         TT_pdf_font.font_name  = pcFontName
         TT_pdf_font.font_tag   = "~/" + STRING(pcFontName)
         TT_pdf_font.is_unicode = LOGICAL(GetWidgetOption2("unicode", pcOptions, "NO"))
         .
        REPEAT:
            CREATE TT_pdf_font_character.
            ASSIGN
             TT_pdf_font_character.obj_stream = pdfStream
             TT_pdf_font_character.font_name  = pcFontName.
            IMPORT TT_pdf_font_character EXCEPT TT_pdf_font_character.obj_stream
                                                TT_pdf_font_character.font_name
                                                TT_pdf_font_character.alldone
                                                TT_pdf_font_character.used
                                                TT_pdf_font_character.used_as_component.
        END.
        INPUT CLOSE.
        DELETE TT_pdf_font_character. /* delete last character created - has not been filled because IMPORT has failed past last line */
        RETURN.
    END.

    SET-BYTE-ORDER(mFont) = 2. /* BIG ENDIAN */
    RUN getFileAsMemptr(pdfStream, pcFileName, ?, INPUT-OUTPUT mFont, OUTPUT iFontFileSize).

    /* font type */
    IF GET-UNSIGNED-LONG(mFont, 1) = 65536 /* 0x00010000 */ THEN
        tt_pdf_font.font_type = "TrueType".
    ELSE IF GET-STRING(mFont, 1, 4) = "true" THEN /* OS X or iOS only fonts - not tested */
        tt_pdf_font.font_type = "TrueType".
    ELSE IF GET-STRING(mFont, 1, 4) = "OTTO" THEN
        tt_pdf_font.font_type = "OpenType". /* unsupported */
    ELSE IF GET-STRING(mFont, 1, 4) = "typ1" THEN
        tt_pdf_font.font_type = "Type1". /* unsupported */
    ELSE
        tt_pdf_font.font_type = "Unsupported".

    IF tt_pdf_font.font_type <> "TrueType" THEN DO:
        {&cleanUp}
        RETURN ERROR "Unsupported font type " + QUOTER(tt_pdf_font.font_type).
    END.

    iOffset = iOffset + 4.

    iNumTables = GET-UNSIGNED-SHORT(mFont, iOffset).
    iOffset = iOffset + 2.

    /* skip searchRange, entrySelector and rangeShift */
    iOffset = iOffset + 6.

    /* get info about the font tables */
    DO iTable = 1 TO iNumTables:
        CREATE TT_pdf_font_table.
        ASSIGN
         TT_pdf_font_table.table_name = GET-STRING(mFont, iOffset, 4)
         TT_pdf_font_table.checksum   = GET-LONG(mFont, iOffset + 4)
         TT_pdf_font_table.offset     = GET-UNSIGNED-LONG(mFont, iOffset + 8) + 1 /* + 1 : the offset for the first byte is 1 for Progress in GET-* functions, whereas it is 0 is many other languages */
         TT_pdf_font_table.length     = GET-UNSIGNED-LONG(mFont, iOffset + 12).
        iOffset = iOffset + 16.
    END.

    /* check font magic number, must be 0x5F0F3CF5 */
    FIND tt_pdf_font_table WHERE tt_pdf_font_table.table_name = "head".
    iOffset = tt_pdf_font_table.offset + 12.
    IF GET-UNSIGNED-LONG(mFont, iOffset) <> 1594834165 /*0x5F0F3CF5*/ THEN
        {pdferror.i &msg="'bad magic at ' + STRING(iOffset) + ': ' + STRING(HEX-ENCODE(GET-BYTES(mFont, iOffset, 4))) + ' expected 0x5F0F3CF5'" &cleanup="{&cleanUp}" &return=YES &error=YES &returnmsg=YES}
    iOffset = iOffset + 4.

    iOffset = iOffset + 2. /* skip flags */

    iUnitsPerEm = GET-UNSIGNED-SHORT(mFont, iOffset).
    iOffset = iOffset + 2.

    iOffset = iOffset + 16. /* skip created & modified datetimes */

    /* Font bounding box */
    iXMin = ROUND(GET-FWORD(mFont, iOffset) * 1000 / iUnitsPerEm, 0).
    iXMax = ROUND(GET-FWORD(mFont, iOffset + 2) * 1000 / iUnitsPerEm, 0).
    iYMin = ROUND(GET-FWORD(mFont, iOffset + 4) * 1000 / iUnitsPerEm, 0).
    iYMax = ROUND(GET-FWORD(mFont, iOffset + 6) * 1000 / iUnitsPerEm, 0).
    iOffset = iOffset + 8.
    tt_pdf_font.afm_FontBBox = STRING(iXMin) + " " + STRING(iXMax) + " " + STRING(iYMin) + " " + STRING(iYMax).

    iMacStyle = GET-UNSIGNED-SHORT(mFont, iOffset).
    iOffset = iOffset + 2.
    /* bit 0 bold */
    /* bit 1 italic */
    /* bit 2 underline */
    /* bit 3 outline */
    /* bit 4 shadow */
    /* bit 5 condensed (narrow) */
    /* bit 6 extended */

    iOffset = iOffset + 4. /* skip lowestRecPPEM & fontDirectionHint */

    /* get offset mode (indexToLocFormat : 0 = short, 1 = long) */
    iShortOffset = GET-SHORT(mFont, iOffset).
    FIND tt_pdf_font_table WHERE tt_pdf_font_table.table_name = "loca".
    iOffset = tt_pdf_font_table.offset.
    IF iShortOffset = 0 THEN DO:
        iNumberOfGlyphs = TRUNCATE(tt_pdf_font_table.length / 2, 0).
        DO iGlyph = 1 TO iNumberOfGlyphs:
            CREATE tt_pdf_font_index_to_loc.
            ASSIGN
             tt_pdf_font_index_to_loc.glyph = iGlyph - 1
             tt_pdf_font_index_to_loc.loc   = GET-UNSIGNED-SHORT(mFont, iOffset) * 2.
            iOffset = iOffset + 2.
        END.
    END. ELSE DO:
        iNumberOfGlyphs = tt_pdf_font_table.length / 4.
        DO iGlyph = 1 TO iNumberOfGlyphs:
            CREATE tt_pdf_font_index_to_loc.
            ASSIGN
             tt_pdf_font_index_to_loc.glyph = iGlyph - 1
             tt_pdf_font_index_to_loc.loc   = GET-UNSIGNED-LONG(mFont, iOffset).
            iOffset = iOffset + 4.
        END.
    END.

    /* get data from 'hhea': Ascender, Descender & nb of horizontal metrics (for 'htmx') */
    FIND tt_pdf_font_table WHERE tt_pdf_font_table.table_name = "hhea".
    iOffset = TT_pdf_font_table.offset + 4. /* skip version */
    tt_pdf_font.afm_Ascender = STRING(ROUND(GET-FWORD(mFont, iOffset) * 1000 / iUnitsPerEm, 0)).
    iOffset = iOffset + 2.
    tt_pdf_font.afm_Descender = STRING(ROUND(GET-FWORD(mFont, iOffset) * 1000 / iUnitsPerEm, 0)).
    iOffset = iOffset + 4. /* skip lineGap */
    TT_pdf_font.afm_MaxWidth = STRING(ROUND(GET-UNSIGNED-SHORT(mFont, iOffset) * 1000 / iUnitsPerEm, 0)).
    iOffset = iOffset + 22. /* skip all fields up to numOfLongHorMetrics */
    iNumOfLongHorMetrics = GET-UNSIGNED-LONG(mFont, iOffset).

    /* get AvgWidth & estimates for StdHW & StdVW (resp. StemH & StemV) */
    DEFINE VARIABLE iUsWeightClass AS INTEGER     NO-UNDO.
    FIND tt_pdf_font_table WHERE tt_pdf_font_table.table_name = "os/2".
    iOffset = tt_pdf_font_table.offset + 2. /* skip version */
    TT_pdf_font.afm_AvgWidth = STRING(ROUND(GET-SHORT(mFont, iOffset) * 1000 / iUnitsPerEm, 0)).
    iOffset = iOffset + 2.
    iUsWeightClass = ROUND(GET-UNSIGNED-SHORT(mFont, iOffset) * 1000 / iUnitsPerEm, 0).
    TT_pdf_font.afm_StdHW = STRING(ROUND(iUsWeightClass * 30 / 400, 0)).
    TT_pdf_font.afm_StdVW = STRING(ROUND(iUsWeightClass * 70 / 400, 0)).
    /* 400 is for Normal. See table below: */
    /* usWC Description      */
    /* ==== ================ */
    /* 100  Thin             */
    /* 200  Extra Light      */
    /* 300  Light            */
    /* 400  Normal (Regular) */
    /* 500  Medium           */
    /* 600  Demibold         */
    /* 700  Bold             */
    /* 800  Extra Bold       */
    /* 900  Black            */

    /* get "names" from the font */
    DEFINE VARIABLE cName                AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iLanguageID          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNameID              AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNameStringLength    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNameStringOffset    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNumberOfNameRecords AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iPlatformSpecificID  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iStringOffset        AS INTEGER     NO-UNDO.
    FIND tt_pdf_font_table WHERE tt_pdf_font_table.table_name = "name".
    iOffset = tt_pdf_font_table.offset + 2. /* skip format selector, which is always zero */
    iNumberOfNameRecords = GET-UNSIGNED-SHORT(mFont, iOffset).
    iOffset = iOffset + 2.
    iStringOffset = GET-UNSIGNED-SHORT(mFont, iOffset).
    iOffset = iOffset + 2.
    DO i = 1 TO iNumberOfNameRecords:
        iPlatformID = GET-UNSIGNED-SHORT(mFont, iOffset).
        iPlatformSpecificID = GET-UNSIGNED-SHORT(mFont, iOffset + 2).
        iLanguageID = GET-UNSIGNED-SHORT(mFont, iOffset + 4).
        iNameID = GET-UNSIGNED-SHORT(mFont, iOffset + 6).
        iNameStringLength = GET-UNSIGNED-SHORT(mFont, iOffset + 8).
        iNameStringOffset = GET-UNSIGNED-SHORT(mFont, iOffset + 10).
        cName = GET-STRING(mFont, tt_pdf_font_table.offset + iStringOffset + iNameStringOffset, iNameStringLength).
        IF iPlatformID = 0 OR iPlatformID = 3 THEN cName = CODEPAGE-CONVERT(cName, SESSION:CPINTERNAL, "utf-16be").
        CASE iNameID:
            WHEN 0 THEN TT_pdf_font.afm_Notice     = cName.
            WHEN 1 THEN TT_pdf_font.afm_FamilyName = cName.
            WHEN 2 THEN TT_pdf_font.afm_Weight     = cName.
            WHEN 4 THEN TT_pdf_font.afm_FullName   = cName.
            WHEN 5 THEN TT_pdf_font.afm_Version    = cName.
            WHEN 6 THEN TT_pdf_font.afm_FontName   = cName.
        END CASE.
        iOffset = iOffset + 12.
        /* DEFINE VARIABLE mName AS MEMPTR      NO-UNDO. */
        /* SET-SIZE(mName) = iNameStringLength. */
        /* mName = GET-BYTES(mFont, tt_pdf_font_table.offset + iStringOffset + iNameStringOffset, iNameStringLength). */
        /* MESSAGE iPlatformID iPlatformSpecificID iLanguageID iNameID */
            /* SKIP QUOTER(cName) */
            /* SKIP hex-Encode(mName) */
            /* VIEW-AS ALERT-BOX INFO BUTTONS OK. */
        /* SET-SIZE(mName) = 0. */
    END.
    IF TT_pdf_font.afm_FontName = ? THEN
        TT_pdf_font.afm_FontName = REPLACE(TT_pdf_font.afm_FullName, " ", "").

    /* get glyphs indexes of chars from cmap table */
    FIND tt_pdf_font_table WHERE tt_pdf_font_table.table_name = "cmap".
    ASSIGN
     iCmapOffset = tt_pdf_font_table.offset
     iOffset     = tt_pdf_font_table.offset + 2.
    iNumEncodingTables = GET-UNSIGNED-SHORT(mFont, iOffset).
    iOffset = iOffset + 2.
    DO iEncodingTable = 1 TO iNumEncodingTables:
        CREATE tt_pdf_font_encoding_table.
        ASSIGN
         tt_pdf_font_encoding_table.platformID = GET-UNSIGNED-SHORT(mFont, iOffset)
         tt_pdf_font_encoding_table.encodingID = GET-UNSIGNED-SHORT(mFont, iOffset + 2)
         tt_pdf_font_encoding_table.offset     = GET-UNSIGNED-LONG(mFont, iOffset + 4).
        iOffset = iOffset + 8.
    END.
/* 17-MAR-2015 jcc:  */
    ASSIGN
        iPlatformID = INTEGER(GetWidgetOption2("platformID", pcOptions, "3"))  /* Windows: 3, Macintosh: 1 */
        iEncodingID = INTEGER(GetWidgetOption2("encodingID", pcOptions, "1")). /* for platform 3: 0: Symbol, 1: Unicode, 2: ShiftJIS, 3: PRC, 4: Big5, 5: Wansung, 6: Johab, 7: Reserved, 8: Reserved, 9: Reserved, 10: UCS-4 */
    IF NOT CAN-FIND(FIRST tt_pdf_font_encoding_table
                    WHERE tt_pdf_font_encoding_table.platformID = iPlatformID
                      AND tt_pdf_font_encoding_table.encodingID = iEncodingID) THEN DO:
        DEFINE VARIABLE cListPlatEnc AS CHARACTER   NO-UNDO.
        FOR EACH tt_pdf_font_encoding_table:
            cListPlatEnc = cListPlatEnc + STRING(tt_pdf_font_encoding_table.platformID) + "/" + STRING(tt_pdf_font_encoding_table.encodingID) + " ".
        END.
        {pdferror.i &msg="'Font ' + QUOTER(TT_pdf_font.font_name) + ' has no encoding table for PlatformID/EncodingID=' + STRING(iPlatformID) + '/' + STRING(iEncodingID) + '. Possible values are: ' + cListPlatEnc" &cleanup="{&cleanUp}" &return=YES &error=YES &returnmsg=YES}
    END.
/* 17-MAR-2015 jcc:  */
    FOR EACH tt_pdf_font_encoding_table
/* 17-MAR-2015 jcc:  */
        WHERE tt_pdf_font_encoding_table.platformID = iPlatformID
          AND tt_pdf_font_encoding_table.encodingID = iEncodingID:
/* 17-MAR-2015 jcc:  */
        iOffset = iCmapOffset + tt_pdf_font_encoding_table.offset.
        iFormat = GET-UNSIGNED-SHORT(mFont, iOffset).
        /* MESSAGE tt_pdf_font_encoding_table.platformID tt_pdf_font_encoding_table.encodingID iFormat */
            /* VIEW-AS ALERT-BOX INFO BUTTONS OK. */
        iOffset = iOffset + 2.
        CASE iFormat:
            WHEN 0 THEN DO: /* Format 0: Byte encoding table */
                iOffset = iOffset + 4. /* skip length and version/language */
                DO c = 0 TO 255:
                    IF findOrCreate_TT_pdf_font_character (c, INPUT-OUTPUT iNbChars, BUFFER TT_pdf_font, BUFFER TT_pdf_font_character) THEN
                        TT_pdf_font_character.glyph = GET-BYTE(mFont, iOffset).
                    iOffset = iOffset + 1.
                END.
            END.
            WHEN 2 THEN DO: /* Format 2: High-byte mapping through table */
                DEFINE VARIABLE iNumGlyphIndexArray    AS INTEGER   NO-UNDO.
                DEFINE VARIABLE iNumSubHeaders         AS INTEGER   NO-UNDO.
                DEFINE VARIABLE iOffsetGlyphIndexArray AS INTEGER   NO-UNDO.
                DEFINE VARIABLE iSubHeaderKeys         AS INTEGER   EXTENT 256 NO-UNDO.
                iOffset = iOffset + 4. /* skip length and version/language */
			    iNumSubHeaders = 0.
                DO c = 1 TO 256:
                    iSubHeaderKeys[c] = GET-UNSIGNED-SHORT(mFont, iOffset) / 8.
                    iOffset = iOffset + 2.
                    IF iNumSubHeaders < iSubHeaderKeys[c] THEN
                        iNumSubHeaders = iSubHeaderKeys[c].
                END.
                /* the number of subHeaders is equal to the max of subHeaderKeys + 1 */
                iNumSubHeaders = iNumSubHeaders + 1.
                /* read subHeader structures */
				iNumGlyphIndexArray = 0.
                DO i = 0 TO iNumSubHeaders:
                    CREATE tt_pdf_font_segment.
                    ASSIGN
                     tt_pdf_font_segment.segment       = i
                     tt_pdf_font_segment.startCount    = GET-UNSIGNED-SHORT(mFont, iOffset)     /* first code */
                     tt_pdf_font_segment.endCount      = GET-UNSIGNED-SHORT(mFont, iOffset + 2) /* entry count */
                     tt_pdf_font_segment.idDelta       = GET-UNSIGNED-SHORT(mFont, iOffset + 4)
                     tt_pdf_font_segment.idRangeOffset = (GET-UNSIGNED-SHORT(mFont, iOffset + 6) - (2 + ((iNumSubHeaders - i - 1) * 8)) ) / 2.
                    ASSIGN
                     iOffset = iOffset + 8
                     iNumGlyphIndexArray = iNumGlyphIndexArray + tt_pdf_font_segment.endCount /* entry count */.
                END.
                iOffsetGlyphIndexArray = iOffset. /* remember the glyph index array: we'll get the values later */
                iOffset = iOffset + 2 * iNumGlyphIndexArray. /* skip the glyph index array */
                DO c = 1 TO 256:
                    IF iSubHeaderKeys[c] = 0 THEN DO: /* one byte code */
                        IF findOrCreate_TT_pdf_font_character (c - 1, INPUT-OUTPUT iNbChars, BUFFER TT_pdf_font, BUFFER TT_pdf_font_character) THEN
                            TT_pdf_font_character.glyph = GET-UNSIGNED-SHORT(mFont, iOffsetGlyphIndexArray).
                    END.
                    ELSE DO: /* two bytes code */
                        FIND tt_pdf_font_segment WHERE tt_pdf_font_segment.segment = iSubHeaderKeys[c].
                        DO i = tt_pdf_font_segment.startCount TO tt_pdf_font_segment.startCount + tt_pdf_font_segment.endCount:
                            /* combine high and low bytes */
                            IF findOrCreate_TT_pdf_font_character (bin_lshift(c - 1, 8) + i, INPUT-OUTPUT iNbChars, BUFFER TT_pdf_font, BUFFER TT_pdf_font_character) THEN
                                TT_pdf_font_character.glyph =
                                    (GET-UNSIGNED-SHORT(mFont, iOffsetGlyphIndexArray + 2 * (tt_pdf_font_segment.idRangeOffset + i - tt_pdf_font_segment.startCount) )
                                    + tt_pdf_font_segment.idDelta) MODULO 65536.
                        END.
                    END.
                END.
                EMPTY TEMP-TABLE tt_pdf_font_segment.
            END.
            WHEN 4 THEN DO: /* Format 4: Segment mapping to delta values */
                iLength = GET-SHORT(mFont, iOffset).
                iOffset = iOffset + 4. /* skip version/language */
                iSegCount = TRUNCATE(GET-UNSIGNED-SHORT(mFont, iOffset) / 2, 0).
                iOffset = iOffset + 8. /* skip searchRange, entrySelector, rangeShift */
                /* now comes the following data:                                                             */
                /* UShort endCode[segCount]           Ending character code for each segment, last = 0xFFFF. */
                /* UShort reservedPad                 This value should be zero                              */
                /* UShort startCode[segCount]         Starting character code for each segment               */
                /* UShort idDelta[segCount]           Delta for all character codes in segment               */
                /* UShort idRangeOffset[segCount]     Offset in bytes to glyph indexArray, or 0              */
                /* UShort glyphIndexArray[variable]   Glyph index array                                      */
                DO i = 1 TO iSegCount:
                    CREATE tt_pdf_font_segment.
                    ASSIGN
                     tt_pdf_font_segment.segment       = i
                     tt_pdf_font_segment.endCount      = GET-UNSIGNED-SHORT(mFont, iOffset)
                     tt_pdf_font_segment.startCount    = GET-UNSIGNED-SHORT(mFont, iOffset + iSegCount * 2 + 2)
                     tt_pdf_font_segment.idDelta       = GET-UNSIGNED-SHORT(mFont, iOffset + iSegCount * 4 + 2)
                     tt_pdf_font_segment.idRangeOffset = GET-UNSIGNED-SHORT(mFont, iOffset + iSegCount * 6 + 2).
                    iOffset = iOffset + 2.
                END.
                iOffset = iOffset + iSegCount * 6 + 2. /* we position ourselves at the beginning of the glyph index array */
                /* iGidLen = TRUNCATE(iLength / 2, 0) - 8 - (4 * iSegCount). */

                FOR EACH tt_pdf_font_segment BY tt_pdf_font_segment.segment:
                    DO c = tt_pdf_font_segment.startCount TO tt_pdf_font_segment.endCount:
                        IF NOT CAN-FIND(TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
                                        AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
                                        AND TT_pdf_font_character.char_id = c) THEN DO:
                        /* IF findOrCreate_TT_pdf_font_character (c, "4", INPUT-OUTPUT iNbChars, BUFFER TT_pdf_font_character) THEN DO: */
                            IF tt_pdf_font_segment.idRangeOffset = 0 THEN
                                iGlyph = (c + tt_pdf_font_segment.idDelta) MODULO 65536.
                            ELSE ASSIGN
                                iGid   = TRUNCATE(tt_pdf_font_segment.idRangeOffset / 2, 0)
                                         + (c - tt_pdf_font_segment.startCount) - (iSegCount - tt_pdf_font_segment.segment)
                                iGlyph = (GET-UNSIGNED-SHORT(mFont, iOffset + 2 * (iGid - 1)) + tt_pdf_font_segment.idDelta) MODULO 65536.
                            IF iGlyph < 0 THEN
                                iGlyph = 0.
                            IF iGlyph <> ? THEN DO:
                                findOrCreate_TT_pdf_font_character (c, INPUT-OUTPUT iNbChars, BUFFER TT_pdf_font, BUFFER TT_pdf_font_character).
                                TT_pdf_font_character.glyph = iGlyph.
                            END.
                        END.
                    END.
                END.
                EMPTY TEMP-TABLE tt_pdf_font_segment.
            END.
            WHEN 6 THEN DO: /* Format 6: Trimmed table mapping */
                iOffset = iOffset + 4. /* skip length and version/language */
                iFirstCode = GET-UNSIGNED-SHORT(mFont, iOffset).
                iOffset = iOffset + 2.
                iEntryCount = GET-UNSIGNED-SHORT(mFont, iOffset).
                iOffset = iOffset + 2.
                DO i = 0 TO iEntryCount - 1:
                    c = iFirstCode + i.
                    IF findOrCreate_TT_pdf_font_character (c, INPUT-OUTPUT iNbChars, BUFFER TT_pdf_font, BUFFER TT_pdf_font_character) THEN
                        TT_pdf_font_character.glyph = GET-UNSIGNED-SHORT(mFont, iOffset).
                    iOffset = iOffset + 2.
                END.
            END.
            WHEN 8 THEN DO: /* Format 8: Mixed 16-bit and 32-bit coverage */
                MESSAGE "Format" iFormat "not implemented!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            WHEN 10 THEN DO: /* Format 10: Trimmed array */
                MESSAGE "Format" iFormat "not implemented!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            WHEN 12 THEN DO: /* Format 12: Segmented coverage */
                iOffset = iOffset + 10. /* skip length and version/language */
                iNumGroups = GET-UNSIGNED-LONG(mFont, iOffset).
                iOffset = iOffset + 4.
                DO i = 1 TO iNumGroups:
                    iStartCharCode = GET-UNSIGNED-LONG(mFont, iOffset).
                    iOffset = iOffset + 4.
                    iEndCharCode = GET-UNSIGNED-LONG(mFont, iOffset).
                    iOffset = iOffset + 4.
                    iStartGlyphCode = GET-UNSIGNED-LONG(mFont, iOffset).
                    iOffset = iOffset + 4.
                    DO c = iStartCharCode TO iEndCharCode:
                        IF findOrCreate_TT_pdf_font_character (c, INPUT-OUTPUT iNbChars, BUFFER TT_pdf_font, BUFFER TT_pdf_font_character) THEN
                            TT_pdf_font_character.glyph = iStartGlyphCode.
                        iStartGlyphCode = iStartGlyphCode + 1.
                    END.
                END.
            END.
            WHEN 13 THEN DO: /* Format 13: Many-to-one range mappings */
                MESSAGE "Format" iFormat "not implemented!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            WHEN 14 THEN DO: /* Format 14: Unicode Variation Sequences */
                MESSAGE "Format" iFormat "not implemented!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            OTHERWISE
                MESSAGE "Format" iFormat " unknown!" VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END CASE. /* iFormat */
    END. /* FOR EACH tt_pdf_font_encoding_table */
    TT_pdf_font.afm_Characters = STRING(iNbChars).

    /* always add glyph zero (.notdef): the first glyph in any TrueType font must be the MISSING CHARACTER GLYPH */
    iChar = iChar - 1. /* iChar < 0 */
    /* CREATE TT_pdf_font_character. */
    /* ASSIGN */
     /* TT_pdf_font_character.obj_stream = pdfStream */
     /* TT_pdf_font_character.font_name  = TT_pdf_font.font_name */
     /* TT_pdf_font_character.char_id    = iChar /* no char id */ */
     /* TT_pdf_font_character.glyph      = 0 */
     /* TT_pdf_font_character.used       = YES */
     /* TT_pdf_font_character.alldone    = YES. */
    /* add all composite glyphs parts */
    FIND tt_pdf_font_table WHERE tt_pdf_font_table.table_name = "glyf".
    DO WHILE CAN-FIND(FIRST TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
                      AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
                      AND TT_pdf_font_character.alldone = NO):

        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
          AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
          AND TT_pdf_font_character.alldone = NO,
            FIRST tt_pdf_font_index_to_loc WHERE tt_pdf_font_index_to_loc.glyph = TT_pdf_font_character.glyph:

            ASSIGN
             iSubsetPrefix = iSubsetPrefix + TT_pdf_font_character.glyph
             iOffset       = tt_pdf_font_table.offset + tt_pdf_font_index_to_loc.loc.
            iNumberOfContours = GET-SHORT(mFont, iOffset).
            iOffset = iOffset + 2.
            IF iNumberOfContours < 0 THEN DO: /* If the number of contours is -1, the glyph is compound */
                /* RUN debugLog("Glyph " + STRING(TT_pdf_font_character.glyph) + " is compound"). */
                iOffset = iOffset + 8. /* skip xMin, yMin, xMax, yMax (bounding box) */
                /* read the compound glyph data to know all the used glyph indices */
                DO WHILE TRUE:
                    /* RUN debugLog("Offset: " + STRING(iOffset - 1)). */
                    iFlags = GET-UNSIGNED-SHORT(mFont, iOffset).
                    iOffset = iOffset + 2.
                    iGlyphIndex = GET-UNSIGNED-SHORT(mFont, iOffset).
                    iOffset = iOffset + 2.
                    FIND FIRST TT_pdf_font_compound_character WHERE TT_pdf_font_compound_character.obj_stream = pdfStream
                      AND TT_pdf_font_compound_character.font_name = TT_pdf_font.font_name
                      AND TT_pdf_font_compound_character.glyph = iGlyphIndex NO-ERROR.
                    IF NOT AVAILABLE TT_pdf_font_compound_character THEN DO:
                        iChar = iChar - 1.
                        CREATE TT_pdf_font_compound_character.
                        ASSIGN
                         TT_pdf_font_compound_character.obj_stream = pdfStream
                         TT_pdf_font_compound_character.font_name  = TT_pdf_font.font_name
                         TT_pdf_font_compound_character.char_id    = iChar /* no char id */
                         TT_pdf_font_compound_character.glyph      = iGlyphIndex
                         iNbChars = iNbChars + 1.
                        /* RUN debugLog("Add glyph " + STRING(iGlyphIndex)). */
                    END.
                    /* TT_pdf_font_compound_character.used = YES. */
                    /* Skip some bytes depending on iFlags bits */
                    IF GET-BITS(iFlags, 1, 1) = 1 THEN /* ARG_1_AND_2_ARE_WORDS */
                        iOffset = iOffset + 4.
                    ELSE
                        iOffset = iOffset + 2.
                    IF GET-BITS(iFlags, 4, 1) = 1 THEN /* WE_HAVE_A_SCALE */
                        iOffset = iOffset + 2.
                    ELSE IF GET-BITS(iFlags, 7, 1) = 1 THEN /* WE_HAVE_AN_X_AND_Y_SCALE */
                        iOffset = iOffset + 4.
                    ELSE IF GET-BITS(iFlags, 8, 1) = 1 THEN /* WE_HAVE_A_TWO_BY_TWO */
                        iOffset = iOffset + 8.
                    IF GET-BITS(iFlags, 6, 1) = 0 THEN /* no MORE_COMPONENTS */
                        LEAVE.
                END.
            END.
            TT_pdf_font_character.alldone = YES.
        END.
    END.

    /* create dummy characters for missing glyphs */
    DO i = 1 TO iNumberOfGlyphs:
        IF NOT CAN-FIND(FIRST TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
                        AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
                        AND TT_pdf_font_character.glyph = i) THEN DO:
            iChar = iChar - 1.
            CREATE TT_pdf_font_character.
            ASSIGN
             TT_pdf_font_character.obj_stream = pdfStream
             TT_pdf_font_character.font_name  = TT_pdf_font.font_name
             TT_pdf_font_character.char_id    = iChar
             TT_pdf_font_character.glyph      = i
             iNbChars                         = iNbChars + 1.
        END.
    END.
    TT_pdf_font.afm_StartCharMetrics = STRING(iNbChars).

    /* get xHeight (height of the letter x) and CapHeight (height of capital letters that are flat, such as H or I) */
    FOR FIRST TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
      AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
      AND TT_pdf_font_character.char_id = 120,
        FIRST tt_pdf_font_index_to_loc WHERE tt_pdf_font_index_to_loc.glyph = TT_pdf_font_character.glyph:
        iOffset = tt_pdf_font_table.offset + tt_pdf_font_index_to_loc.loc + 4.
        iYMin = GET-FWORD(mFont, iOffset).
        iYMax = GET-FWORD(mFont, iOffset + 2).
        TT_pdf_font.afm_XHeight = STRING(ROUND((iYMax - iYMin) * 1000 / iUnitsPerEm, 0)).
    END.
    FOR FIRST TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
      AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
      AND TT_pdf_font_character.char_id = 72,
        FIRST tt_pdf_font_index_to_loc WHERE tt_pdf_font_index_to_loc.glyph = TT_pdf_font_character.glyph:
        iOffset = tt_pdf_font_table.offset + tt_pdf_font_index_to_loc.loc + 4.
        iYMin = GET-FWORD(mFont, iOffset).
        iYMax = GET-FWORD(mFont, iOffset + 2).
        TT_pdf_font.afm_CapHeight = STRING(ROUND((iYMax - iYMin) * 1000 / iUnitsPerEm, 0)).
    END.

    /* get characters bounding boxes */
    IF LOGICAL(GetWidgetOption2("charbbox", pcOptions, "NO")) THEN DO:
        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
          AND TT_pdf_font_character.font_name = TT_pdf_font.font_name,
            FIRST tt_pdf_font_index_to_loc WHERE tt_pdf_font_index_to_loc.glyph = TT_pdf_font_character.glyph:
            iOffset = tt_pdf_font_table.offset + tt_pdf_font_index_to_loc.loc + 2.
            iXMin = ROUND(GET-FWORD(mFont, iOffset) * 1000 / iUnitsPerEm, 0).
            iXMax = ROUND(GET-FWORD(mFont, iOffset + 2) * 1000 / iUnitsPerEm, 0).
            iYMin = ROUND(GET-FWORD(mFont, iOffset + 4) * 1000 / iUnitsPerEm, 0).
            iYMax = ROUND(GET-FWORD(mFont, iOffset + 6) * 1000 / iUnitsPerEm, 0).
            TT_pdf_font_character.char_bbox = STRING(iXMin) + " " + STRING(iXMax) + " " + STRING(iYMin) + " " + STRING(iYMax).
        END.
    END.

    /* get characters' width from 'hmtx' */
    FIND tt_pdf_font_table WHERE tt_pdf_font_table.table_name = "hmtx".
    iOffset = tt_pdf_font_table.offset.
    DO i = 0 TO iNumOfLongHorMetrics - 1:
        cWidth = STRING(ROUND(GET-UNSIGNED-SHORT(mFont, iOffset) * 1000 / iUnitsPerEm, 0)).
        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
          AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
          AND TT_pdf_font_character.glyph = i:
            TT_pdf_font_character.char_width = cWidth.
            IF i = 0 THEN TT_pdf_font.afm_MissingWidth = TT_pdf_font_character.char_width.
        END.
        iOffset = iOffset + 4. /* skip leftSideBearing */
    END.
    IF iNumOfLongHorMetrics < iNumberOfGlyphs THEN DO i = iNumOfLongHorMetrics TO iNumberOfGlyphs:
        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
          AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
          AND TT_pdf_font_character.glyph = i:
            /* 03-JUN-2015 jcc: not the missing width! we have to repeat the last width instead. */
            /* TT_pdf_font_character.char_width = TT_pdf_font.afm_MissingWidth. */
            TT_pdf_font_character.char_width = cWidth.
        END.
    END.

    /* for non unicode fonts, TT_pdf_font.font_width is a string with the widths of chars between 0 and 255 */
    DEFINE VARIABLE iLastChar AS INTEGER     NO-UNDO.
    IF NOT TT_pdf_font.is_unicode THEN DO:
        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
            AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
            AND TT_pdf_font_character.char_id < 256
            BY TT_pdf_font_character.char_id DESCENDING:
            iLastChar = TT_pdf_font_character.char_id.
            LEAVE.
        END.
        DO i = 0 TO iLastChar:
            FIND TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = TT_pdf_font.obj_stream
                AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
                AND TT_pdf_font_character.char_id = i NO-ERROR.
            TT_pdf_font.afm_Widths = TT_pdf_font.afm_Widths + " " + IF AVAILABLE TT_pdf_font_character THEN TT_pdf_font_character.char_width ELSE TT_pdf_font.afm_MissingWidth.
        END.
        TT_pdf_font.afm_Widths    = SUBSTRING(TT_pdf_font.afm_Widths, 2).
        TT_pdf_font.afm_FirstChar = "0".
        TT_pdf_font.afm_LastChar  = STRING(iLastChar).
    END.

    /* get some data from the 'post' table */
    DEFINE VARIABLE dPostFormat AS DECIMAL     NO-UNDO.
    FIND tt_pdf_font_table WHERE tt_pdf_font_table.table_name = "post".
    iOffset = tt_pdf_font_table.offset.
    dPostFormat = GET-FIXED(mFont, iOffset).
    iOffset = iOffset + 4.
    TT_pdf_font.afm_ItalicAngle = dec2string(GET-FIXED(mFont, iOffset)). /* 17-MAR-2015 jcc: dec2string instead of STRING! */
    iOffset = iOffset + 4.
    TT_pdf_font.afm_UnderlinePosition = STRING(ROUND(GET-FWORD(mFont, iOffset) * 1000 / iUnitsPerEm, 0)).
    iOffset = iOffset + 2.
    TT_pdf_font.afm_UnderlineThickness = STRING(ROUND(GET-FWORD(mFont, iOffset) * 1000 / iUnitsPerEm, 0)).
    iOffset = iOffset + 2.
    TT_pdf_font.afm_IsFixedPitch = STRING(GET-UNSIGNED-LONG(mFont, iOffset)).
    TT_pdf_font.font_pitch = IF TT_pdf_font.afm_IsFixedPitch = "0" THEN "VARIABLE" ELSE "FIXED".
    iOffset = iOffset + 20. /* go to the end of the 'post' header */

    IF TT_pdf_font.font_pitch = "VARIABLE" THEN
        TT_pdf_font.font_width = TRIM(TT_pdf_font.afm_Widths).
    ELSE
        TT_pdf_font.font_width = ENTRY(1, TT_pdf_font.afm_Widths," ").

    /* TODO: rewrite this part */
    tt_pdf_font.afm_Flags = IF TT_pdf_font.is_unicode THEN "00000000000000000000000000000110" ELSE "00000000000000000000000000100010".
    j = 0.
    iFlags = 0.
    IF TT_pdf_font.afm_IsFixedPitch = "0" THEN
        OVERLAY(tt_pdf_font.afm_Flags, 32, 1, "CHARACTER") = "1".
    DO i = LENGTH(tt_pdf_font.afm_Flags, "character":u) TO 1 BY -1 :
        IF SUBSTR(tt_pdf_font.afm_Flags, i, 1, "character") = "1" THEN
            iFlags = iFlags + EXP(2, j).
        j = j + 1.
    END.
    TT_pdf_font.afm_Flags = STRING(iFlags).

    /* get characters names from the 'post' table */
    IF LOGICAL(GetWidgetOption2("charname", pcOptions, "NO")) THEN DO:
        CASE dPostFormat:
            WHEN 1.0 THEN FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
              AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
              AND TT_pdf_font_character.glyph >= 0 AND TT_pdf_font_character.glyph <= 257:
                TT_pdf_font_character.char_name = cPost1Names[TT_pdf_font_character.glyph + 1].
            END.
            WHEN 2.0 THEN DO:
                DEFINE VARIABLE iGlyphNameIndex AS INTEGER   NO-UNDO.
                DEFINE VARIABLE iStrLen         AS INTEGER   NO-UNDO.
                iNumberOfGlyphs = GET-UNSIGNED-SHORT(mFont, iOffset).
                iOffset = iOffset + 2.
                /* Load the array of character names */
                IF iNumberOfGlyphs > 258 THEN DO:
                    iOffset2 = iOffset + iNumberOfGlyphs * 2.
                    blkReadStr: DO i = 1 TO iNumberOfGlyphs - 258:
                        iStrLen = GET-BYTE(mFont, iOffset2).
                        iOffset2 = iOffset2 + 1.
                        CREATE tt_string_array.
                        ASSIGN
                         tt_string_array.id  = i
                         tt_string_array.str = GET-STRING(mFont, iOffset2, iStrLen).
                        iOffset2 = iOffset2 + iStrLen.
                        IF iOffset2 > tt_pdf_font_table.offset + tt_pdf_font_table.length THEN DO: /* corrupt 'post' table? */
                            EMPTY TEMP-TABLE tt_string_array.
                            LEAVE blkReadStr.
                        END.
                    END.
                END.
                /* Assign the character names */
                DO i = 0 TO iNumberOfGlyphs - 1:
                    iGlyphNameIndex = GET-UNSIGNED-SHORT(mFont, iOffset).
                    iOffset = iOffset + 2.
                    IF iGlyphNameIndex < 257 THEN FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
                      AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
                      AND TT_pdf_font_character.glyph = i:
                        TT_pdf_font_character.char_name = cPost1Names[iGlyphNameIndex + 1].
                    END. ELSE DO:
                        iGlyphNameIndex = iGlyphNameIndex - 258.
                        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
                          AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
                          AND TT_pdf_font_character.glyph = i,
                            FIRST tt_string_array WHERE tt_string_array.id = iGlyphNameIndex + 1:
                            TT_pdf_font_character.char_name = tt_string_array.str.
                        END.
                    END.
                END.
                EMPTY TEMP-TABLE tt_string_array.
            END.
            WHEN 2.5 THEN DO:
                /* deprecated format */
                MESSAGE "'post' table format 2.5"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                DEFINE VARIABLE iGlyphOffset AS INTEGER     NO-UNDO.
                iNumberOfGlyphs = GET-UNSIGNED-SHORT(mFont, iOffset).
                iOffset = iOffset + 2.
                DO i = 1 TO iNumberOfGlyphs:
                    iGlyphOffset = GET-SHORT(mFont, iOffset).
                    iOffset = iOffset + 1.
                    FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
                      AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
                      AND TT_pdf_font_character.glyph = i:
                        TT_pdf_font_character.char_name = cPost1Names[i + iGlyphOffset].
                    END.
                END.
            END.
            WHEN 3.0 THEN DO:
                /* nothing: no PostScript name information is provided for the glyphs in this font. */
            END.
            WHEN 4.0 THEN DO:
                /* not implemented */
                MESSAGE "'post' table format 4"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
        END CASE.
        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
          AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
          AND TT_pdf_font_character.char_name = ?:
            TT_pdf_font_character.char_name = IF TT_pdf_font_character.glyph = 0 THEN '.notdef' ELSE "_d_" + STRING(TT_pdf_font_character.glyph).
        END.
    END.

    /* Create the cid2gid mapping file */
    IF LOGICAL(GetWidgetOption2("cid2gid", pcOptions, "NO")) THEN DO:
        DEFINE VARIABLE mCid2Gid AS MEMPTR      NO-UNDO.
        SET-BYTE-ORDER(mCid2Gid) = 2. /* BIG-ENDIAN */ /* 11-FEB-2014 jcc: ensure the glyph bytes are ordered correctly in the cid to gid map, see PUT-SHORT below */
        SET-SIZE(mCid2Gid) = 131072. /* 256 * 256 * 2 */
        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
            AND TT_pdf_font_character.font_name = pcFontName:
            IF TT_pdf_font_character.char_id >= 0 AND TT_pdf_font_character.char_id <= 65535 /* 0xFFFF */
               AND TT_pdf_font_character.glyph <> 0 THEN
                PUT-SHORT(mCid2Gid, TT_pdf_font_character.char_id * 2 + 1) = TT_pdf_font_character.glyph.
        END.
        OUTPUT TO VALUE(TT_pdf_font.cid2gid_file) BINARY NO-MAP NO-CONVERT NO-ECHO.
        EXPORT mCid2Gid.
        OUTPUT CLOSE.
        SET-SIZE(mCid2Gid) = 0.
    END.

    /* clean-up */
    SET-SIZE(mFont) = 0.
    EMPTY TEMP-TABLE tt_pdf_font_table.
    EMPTY TEMP-TABLE tt_pdf_font_encoding_table.
    EMPTY TEMP-TABLE tt_pdf_font_index_to_loc.

    /* reset tt_TT_pdf_font_character.alldone else buildFontSubset won't be able to mark components of compound glyphs as used */
    FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
        AND TT_pdf_font_character.font_name = TT_pdf_font.font_name
        AND TT_pdf_font_character.alldone = YES:
        TT_pdf_font_character.alldone = NO.
    END.

    /* create font cache */
    OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "pdfcache/fonts/" + cCacheFileName + ".cache").
    EXPORT TT_pdf_font EXCEPT TT_pdf_font.obj_stream
                              TT_pdf_font.is_unicode     
                              TT_pdf_font.used_flag      
                              TT_pdf_font.used_by_xobject
                              TT_pdf_font.pdf_id         
                              TT_pdf_font.ext_page       
                              TT_pdf_font.font_embed     
                              TT_pdf_font.font_subset    
                              TT_pdf_font.font_options   
                              TT_pdf_font.font_dif       
                              TT_pdf_font.font_obj.      
    FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.obj_stream = pdfStream
      AND TT_pdf_font_character.font_name = pcFontName:
        EXPORT TT_pdf_font_character EXCEPT TT_pdf_font_character.obj_stream
                                            TT_pdf_font_character.font_name
                                            TT_pdf_font_character.alldone
                                            TT_pdf_font_character.used
                                            TT_pdf_font_character.used_as_component.
    END.
    OUTPUT CLOSE.

END PROCEDURE. /* parseFont */

&UNDEFINE cleanUp
